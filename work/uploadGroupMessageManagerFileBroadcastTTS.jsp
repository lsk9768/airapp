<%@ page trimDirectiveWhitespaces="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, AnyTalkBean.*" %>
<%@ page import="java.util.*, AnyTalkBean.TalkFile.*" %>
<jsp:useBean id="admin" class="AnyTalkBean.AdminQueryAnyTalk" scope="page" />
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>


<%  request.setCharacterEncoding("UTF-8");  %>
<%
	  
	  
	String userid = request.getParameter("userid");         //그룹아이디
	String groupid = request.getParameter("groupid");         //그룹아이디
  	String MsgType = request.getParameter("MsgType");       //발송업무 0:일반 1:경보
  	String SendType = request.getParameter("SendType");     //발송구분 0:Talk+SMS 1:Talk 2:SMS
  	String SendPhone = request.getParameter("SendPhone");   //발신번호
  	String txtMsg = request.getParameter("txtMsg");         //전송메시지
	String ScheduleType = request.getParameter("ScheduleType");         //즉시전송 : 0  예약전송 : 1
	String ScheduleDate = request.getParameter("ScheduleDate");         //예약전송날짜
	String fileName = "";
	String file_name = "";
	
	int success  =0;
	
	
	
	PathTalkFile filepath = new PathTalkFile();
	
	if(ScheduleDate!=null){
		ScheduleDate = ScheduleDate.replaceAll("\\p{Space}", "");
		ScheduleDate = ScheduleDate.replaceAll("-", "");
		ScheduleDate = ScheduleDate.replaceAll(":", "");
		ScheduleDate = ScheduleDate+"00";
	}else{
		ScheduleType = "0";	
	}
	
	
	String CheckString1 = "\\";
	String CheckString2 = "'";
	
	String tmpMSG = "";
	
		
	for(int i=0; i<txtMsg.length(); i++){
		if(txtMsg.charAt(i)==CheckString1.charAt(0)) tmpMSG+="\\";
		if(txtMsg.charAt(i)==CheckString2.charAt(0)) tmpMSG+="\\'";
		else tmpMSG+=txtMsg.charAt(i);
	}
	
	
	txtMsg=tmpMSG;
	  
	try {	
	
	
	
			File dirMain = new File(filepath.getFilePath()+"/file/group/"+groupid);
  			if (!dirMain.exists()) dirMain.mkdirs();
	  
			File dirImg = new File(filepath.getFilePath()+"/file/group/"+groupid+"/img");
  			if (!dirImg.exists()) dirImg .mkdirs();
	  
			File dirDoc = new File(filepath.getFilePath()+"/file/group/"+groupid+"/doc");
  			if (!dirDoc.exists())dirDoc.mkdirs();
		  
			File dirSound = new File(filepath.getFilePath()+"/file/group/"+groupid+"/media");
  			if (!dirSound.exists())dirSound.mkdirs();
			
			
			File dirMovie = new File(filepath.getFilePath()+"/file/group/"+groupid+"/movie");
  			if (!dirMovie.exists())dirMovie.mkdirs();
			
			File dirBroadcast = new File(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast");
  			if (!dirBroadcast.exists())dirBroadcast.mkdirs();
	
	
	//tts 생성
		NV_TTS tts = new NV_TTS();
					
		if(tts.makeTTStoMP3File("group", groupid, txtMsg)){
			fileName = tts.getFileName();	
			String tmpFileName = fileName;
						File file = new File(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast", tmpFileName);
						if ( file.exists() ){
							 for(int p=1; true; p++){
								 String tempFile = p+"_"+tmpFileName;
								 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
								 file = new File(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast", tempFile);
								if(!file.exists()){ //존재하지 않는 경우
									 tmpFileName = tempFile;
									 break;
								 }//if : 존재하지 않는 경우
							 }//for
						 }//if : 중복되면
									 
				
									
					   FileInputStream fis = new FileInputStream(filepath.getFilePath()+"/file/group/"+groupid+"/media/"+fileName);
					   FileOutputStream fos = new FileOutputStream(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast/"+tmpFileName);
						   
					   int data = 0;
					   while((data=fis.read())!=-1) {
							fos.write(data);
					   }
					   fis.close();
					   fos.close();
			
						fileName = tmpFileName;
		
		}
		
		long      startDate = System.currentTimeMillis() ;
		long     startNanoseconds = System.nanoTime() ;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS") ;


		long microSeconds = (System.nanoTime() - startNanoseconds) / 1000 ;
		long dateSecond = startDate + (microSeconds/1000) ;

		String dateSMS = dateFormat.format(dateSecond) + String.format("%03d", microSeconds % 1000);
		
		String sms_id = "sms"+dateSMS;
		
		
		
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String date = dayTime.format(new Date(time));
	
		 admin.makeConnection();
		 if(admin.checkTable("t_"+userid+"_group_message_member")<=0)admin.createGroupMessageMember(userid);
		int maxcount = admin.countGroupMessageMember(userid,"1=1");	 
		
		
		file_name = "/file/group/"+groupid+"/broadcast/"+fileName;
		
		
		Vector<AnyTalkInfo> vctDNSList = admin.selectDNSList("talkfile");
		
		int dns_maxcount = vctDNSList.size();
		int dns_count = 0;
		
		
		
		int o=0;
		
		int file_count = 0;
		
		
		
		file_name = vctDNSList.elementAt(dns_count).name + file_name;	
		if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++;
		
		
		for(int m=0; m<maxcount; m=m+50){
			
			
			Vector<AnyTalkInfo> vctMember = admin.selectGroupMessageMember(userid,50,0);
			
			
			if(file_count+200<=m){
					file_count = m;
						
					try {
						String tmpFileName = o+"_"+fileName;
						File file = new File(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast", tmpFileName);
						if ( file.exists() ){
							 for(int p=1; true; p++){
								 String tempFile = p+"_"+tmpFileName;
								 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
								 file = new File(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast", tempFile);
								if(!file.exists()){ //존재하지 않는 경우
									 tmpFileName = tempFile;
									 break;
								 }//if : 존재하지 않는 경우
							 }//for
						 }//if : 중복되면
									 
				
									
					   FileInputStream fis = new FileInputStream(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast/"+fileName);
					   FileOutputStream fos = new FileOutputStream(filepath.getFilePath()+"/file/group/"+groupid+"/broadcast/"+tmpFileName);
						   
					   int data = 0;
					   while((data=fis.read())!=-1) {
							fos.write(data);
					   }
					   fis.close();
					   fos.close();
								   
						
						file_name = tmpFileName;	
		   				//file_name = "/file/group/"+groupid+"/broadcast/"+file_name;	  
						
						file_name = vctDNSList.elementAt(dns_count).name + "/file/group/"+groupid+"/broadcast/"+file_name;	   
						
						if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++; 
						
				  } catch (IOException e) {
					   // TODO Auto-generated catch block
					   e.printStackTrace();
				  }	
				  
				  
				  o++;
				  
			}
			
			for(int n=0; n<vctMember.size(); n++){
			
				AnyTalkInfo info = (AnyTalkInfo)vctMember.elementAt(n);
				
				if(info.state.equals("GROUP")){
					
					
					if(n==0){
										
						File dirMain2 = new File(filepath.getFilePath()+"/file/group/"+info.name);
									if (!dirMain2.exists()) dirMain2.mkdirs();
										  
									File dirImg2 = new File(filepath.getFilePath()+"/file/group/"+info.name+"/img");
									if (!dirImg2.exists()) dirImg2.mkdirs();
									  
									File dirDoc2 = new File(filepath.getFilePath()+"/file/group/"+info.name+"/doc");
									if (!dirDoc2.exists())dirDoc2.mkdirs();
										  
									File dirSound2 = new File(filepath.getFilePath()+"/file/group/"+info.name+"/media");
									if (!dirSound2.exists())dirSound2.mkdirs();
									
									File dirMovie2 = new File(filepath.getFilePath()+"/file/group/"+info.name+"/movie");
									if (!dirMovie2.exists())dirMovie2.mkdirs();
									
									
									File dirBroadcast2 = new File(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast");
									if (!dirBroadcast2.exists())dirBroadcast2.mkdirs();
					
					
									try {
										
										String tmpFileName1 = fileName;
										File file = new File(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast", tmpFileName1);
										if ( file.exists() ){
											 for(int p=1; true; p++){
												 String tempFile = p+"_"+tmpFileName1;
												 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
												 file = new File(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast", tempFile);
												if(!file.exists()){ //존재하지 않는 경우
													 tmpFileName1 = tempFile;
													 break;
												 }//if : 존재하지 않는 경우
											 }//for
										 }//if : 중복되면
										
										
										
									   FileInputStream fis = new FileInputStream(filepath.getFilePath()+"/"+fileName);
									   FileOutputStream fos = new FileOutputStream(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast/"+tmpFileName1);
									   
									   int data = 0;
									   while((data=fis.read())!=-1) {
										fos.write(data);
									   }
									   fis.close();
									   fos.close();
									   
									   //복사한뒤 원본파일을 삭제함
									   //File I = new File(filepath.getFilePath()+"/"+file_name);
  									   //I.delete();
									   
									    file_name = vctDNSList.elementAt(dns_count).name +"/file/group/"+info.name+"broadcast/"+tmpFileName1;	   
														
										if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++;
									   
									   
									  } catch (IOException e) {
									   // TODO Auto-generated catch block
									   e.printStackTrace();
									  }
					
									
									
									}
										
									
					
					
					int GroupMaxCount = admin.countGroupMember(info.name);
					int t=0;
					int file_count2 = 0;
					for(int l=0; l<GroupMaxCount; l=l+50){
					
						Vector<AnyTalkInfo> vctGroupMember = admin.listGroupMember(info.name,50,l);
						
						if(file_count2+200<=l){
							
							file_count2 = l;
						
							try {
								String tmpFileName = t+"_"+fileName;
								File file = new File(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast", tmpFileName);
								if ( file.exists() ){
									 for(int p=t+1; true; p++){
										 t=p;
										 String tempFile = p+"_"+tmpFileName;
										 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
										 file = new File(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast", tempFile);
										if(!file.exists()){ //존재하지 않는 경우
											 tmpFileName = tempFile;
											 break;
										 }//if : 존재하지 않는 경우
									 }//for
								 }//if : 중복되면
								
							   FileInputStream fis = new FileInputStream(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast/"+fileName);
							   FileOutputStream fos = new FileOutputStream(filepath.getFilePath()+"/file/group/"+info.name+"/broadcast/"+tmpFileName);
							   
							   int data = 0;
							   while((data=fis.read())!=-1) {
								fos.write(data);
							   }
							   fis.close();
							   fos.close();
							   
							   
								 file_name = tmpFileName;	
								//file_name = "/file/group/"+info.name+"/broadcast/"+file_name;
								file_name = vctDNSList.elementAt(dns_count).name + "/file/group/"+info.name+"/broadcast/"+file_name;	   
						
								if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++;	
							   
							  } catch (IOException e) {
							   // TODO Auto-generated catch block
							   e.printStackTrace();
							  }	
							  
						}
						
						
							String group_id="";
								
							if(info.name.equals("")||info.name.equals("all")||info.name.equals("employee")
                               		 ||info.name.equals("school")||info.name.equals("professor")
									 ||info.name.equals("student")
                               		 ||info.name.equals("public"))group_id = "all";
								else group_id=info.name;
						
						if(l==0){
							
							int member_count = GroupMaxCount-1;
								
							 String member = "";
										
							if(member_count>0) member= " 외"+Integer.toString(member_count)+"명";
							
							AnyTalkInfo infoGroupMember = (AnyTalkInfo)vctGroupMember.elementAt(0);
							
							if(admin.checkTable("sms_list")==0)admin.createSMS();
							
							if(admin.checkSMS(sms_id)<=0){
								admin.insertSMS(userid, sms_id, SendPhone, infoGroupMember.name+member,group_id,SendType,MsgType,member_count+1,Integer.parseInt(ScheduleType),ScheduleDate);
											
							}else{
													
								for(int k=0; true; k++){
									String id = sms_id+"_"+k;
									//파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
									if(admin.checkSMS(id)<=0){ //존재하지 않는 경우
										sms_id = id;
										admin.insertSMS(userid, sms_id, SendPhone, infoGroupMember.name+member,group_id,SendType,MsgType,member_count+1,Integer.parseInt(ScheduleType),ScheduleDate);
										
										
										
										break;
									}//if : 존재하지 않는 경우
								}//for
								
							}
							
							
								
								

								if(admin.checkSMSMessage(sms_id)<=0)admin.insertSMSMessage(group_id,userid,"broadcast1",txtMsg+"|||"+file_name,sms_id);
							
							
							
						}
						
						for(int k=0; k<vctGroupMember.size(); k++){
					
							AnyTalkInfo infoGroup = (AnyTalkInfo)vctGroupMember.elementAt(k);
						
							SMSInfo infoSMS = new SMSInfo();
										
											
							infoSMS.msg_id = sms_id;
							infoSMS.user_id = userid;
							infoSMS.schedule_type = Integer.parseInt(ScheduleType);
							infoSMS.sms_msg = txtMsg+"|||"+file_name;
							if(SendType.equals("0"))infoSMS.subject = "TalkSMS발송";
							else if(SendType.equals("1"))infoSMS.subject = "Talk발송";
							else if(SendType.equals("2"))infoSMS.subject = "SMS발송";
							infoSMS.callback = SendPhone;
							infoSMS.dest_type = 0;
							infoSMS.dest_count = 1;	
							infoSMS.dest_info = infoGroup.name+"^"+infoGroup.hp+"|";
							infoSMS.now_date = date;	
							if(ScheduleType.equals("0"))infoSMS.send_date = date;
							else infoSMS.send_date = ScheduleDate;	
							infoSMS.send_type = SendType;	
							infoSMS.send_msg_type = "broadcast1";	
							infoSMS.send_group = info.state;	
							infoSMS.send_group_id = group_id;		
							
							//infoSMS.cdr_id = "hanill07";
							
							admin.insertUMS_SMS(infoSMS);
						}
					
					}
					
					
					admin.deleteGroupMessageMember(userid,Integer.toString(info.num));
				}else{
					
					if(m==0&&n==0){
							
							int member_count = maxcount-1;
								
							 String member = "";
										
							if(member_count>0) member= " 외"+Integer.toString(member_count)+"명";
							
							AnyTalkInfo infoGroupMember = info;
						
							
							if(admin.checkTable("sms_list")==0)admin.createSMS();
							
							if(admin.checkSMS(sms_id)<=0){
								admin.insertSMS(userid, sms_id, SendPhone, infoGroupMember.name+member,"all",SendType,MsgType,member_count+1,Integer.parseInt(ScheduleType),ScheduleDate);
											
							}else{
													
								for(int k=0; true; k++){
									String id = sms_id+"_"+k;
										//파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
									if(admin.checkSMS(id)<=0){ //존재하지 않는 경우
										sms_id = id;
										admin.insertSMS(userid, sms_id, SendPhone, infoGroupMember.name+member,"all",SendType,MsgType,member_count+1,Integer.parseInt(ScheduleType),ScheduleDate);
											break;
									}//if : 존재하지 않는 경우
								}//for	
								
							}
							
							
							
							String group_id="all";
								

							if(admin.checkSMSMessage(sms_id)<=0)admin.insertSMSMessage(group_id,userid,"broadcast1",txtMsg+"|||"+file_name,sms_id);
							
						}
				
					SMSInfo infoSMS = new SMSInfo();
					
					
									
					infoSMS.msg_id = sms_id;
					infoSMS.user_id = userid;
					infoSMS.schedule_type = Integer.parseInt(ScheduleType);
					infoSMS.sms_msg = txtMsg+"|||"+file_name;
					if(SendType.equals("0"))infoSMS.subject = "TalkSMS발송";
					else if(SendType.equals("1"))infoSMS.subject = "Talk발송";
					else if(SendType.equals("2"))infoSMS.subject = "SMS발송";
					infoSMS.callback = SendPhone;
					infoSMS.dest_type = 0;
					infoSMS.dest_count = 1;	
					infoSMS.dest_info = info.name+"^"+info.hp+"|";
					infoSMS.now_date = date;	
					if(ScheduleType.equals("0"))infoSMS.send_date = date;
					else infoSMS.send_date = ScheduleDate;	
					infoSMS.send_type = SendType;	
					infoSMS.send_msg_type = "broadcast1";	
					infoSMS.send_group = info.state;		
					infoSMS.send_group_id = "all";	
					
					admin.insertUMS_SMS(infoSMS);
					
					admin.deleteGroupMessageMember(userid,Integer.toString(info.num));
					
				
				}
			}
		}
			success = 1;
			
			admin.disConnect();  
	} catch(Exception e) {
	   	e.printStackTrace();
		admin.disConnect();
	}
			 
	
	  

PathTalkFile pathtalkfile = new PathTalkFile();
%>
<script type="text/javascript">
	 alert( '전송이 완료되었습니다..' );
	window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/manager/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
  </script>


