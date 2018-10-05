<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.*, AnyTalkBean.*" %>
<%@ page import="AnyTalkBean.TalkFile.*" %>
<jsp:useBean id="admin" class="AnyTalkBean.AdminQueryAnyTalk" scope="page" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<html>
<head>
<title>업로드 처리</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");


PathTalkFile pathtalkfile = new PathTalkFile();
	ReplaceAll strReplace = new ReplaceAll();

String file_name = "";
String fileName = "";
String real_fileName = "";
String userid = "";
String groupid = ""; 
String type = "";  //메시지 구분 이미지 : img 음성:media 영상:movie 문서 :doc

String MsgType = "";      //발송업무 0:일반 1:경보
String SendType = "";     //발송구분 0:Talk+SMS 1:Talk 2:SMS
String SendPhone = "";   //발신번호
String msg = "";
String ScheduleType = "";         //즉시전송 : 0  예약전송 : 1
String ScheduleDate = "";         //예약전송날짜

//	up2.html의 enctype="multipart/form-data" 이 아닐 경우 예외 발생
if ( ! FileUpload.isMultipartContent(request)) {
%>
	예외 : 인코딩 타입이 multipart/form-data가 아닙니다.
<%
	return;	//	아래로 실행이 진행되지 않는다.
}//if
%>
<%
request.setCharacterEncoding("utf-8");

int file_num=0;
int updateCount=0;
int i = 0;
int success = 0;
int stateThumNail = 0;

 try {


	PathTalkFile filepath = new PathTalkFile();
	
	
	//먼저 WebContent 폴더 밑에 upfolder 폴더를 만든다. (파일이 저장될 위치)
	String path = filepath.getFilePath();
	DiskFileUpload upload = new DiskFileUpload();
	upload.setSizeMax(50*1024 * 1024); //파일  업로드  최대  size : 1메가
	upload.setSizeThreshold(100*1024*1024);//메모리에  저장할  최대  size
	upload.setRepositoryPath(path + "/temp"); //파일  임시  저장소
	List items = upload.parseRequest(request);
	Iterator iter = items.iterator();
	
	while (iter.hasNext()) {
		file_num++;
		
		FileItem item = (FileItem) iter.next();
		if (item.isFormField()) { // 올린 사람 이름이면
		
		
			switch(i){
			
			case 0:{
				userid=item.getString("UTF-8");
				System.out.println(userid);
				break;
			}
			case 1:{
				groupid = item.getString("UTF-8");
				System.out.println(groupid);
				break;
			}
			case 2:{
				type = item.getString("UTF-8");
				System.out.println(type);
				break;
			}
			case 5:{
				//msg = item.getString("UTF-8");
				msg = "";
				System.out.println(msg);
				break;
			}
			case 6:{
				MsgType = item.getString("UTF-8");
				System.out.println(MsgType);
				break;
			}
			case 7:{
				SendType = item.getString("UTF-8");
				
				System.out.println(SendType);
				break;
			}
			case 8:{
				ScheduleType = item.getString("UTF-8");
				System.out.println(ScheduleType);
				break;
			}	
			case 9:{
				if(ScheduleType.equals("0"))SendPhone = item.getString("UTF-8");
				
				else{
					ScheduleDate = item.getString("UTF-8");
	
					if(ScheduleDate!=null){
						ScheduleDate = ScheduleDate.replaceAll("\\p{Space}", "");
						ScheduleDate = ScheduleDate.replaceAll("-", "");
						ScheduleDate = ScheduleDate.replaceAll(":", "");
						ScheduleDate = ScheduleDate+"00";
					}
					
				}
				System.out.println(SendPhone);
				break;
			}
			case 10:{
				if(ScheduleType.equals("1"))SendPhone = item.getString("UTF-8");
				System.out.println(SendPhone);
				break;
			}	
				
			}
		 
			i++;
			
			
		} else { // 파일이면
		
		
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
			
		
		String fileFieldName = item.getName();
			real_fileName = item.getName();
			fileName = item.getName();
			
			int idx = fileName.lastIndexOf("\\");//윈도우의 경우
			if (idx == -1) {
				idx = fileName.lastIndexOf("/");//유닉스(리눅스)의 경우
			}//if
			fileName = fileName.substring(idx + 1);
			long fileSize = item.getSize();
	
			if(fileName==""){
				updateCount=1;
			}else{
				String ext="";
				int j=fileName.lastIndexOf('.');
				 if(j>0 && j <fileName.length()-1){
					ext=fileName.substring(j+1).toLowerCase();
				 }
				 
				  Calendar oCalendar = Calendar.getInstance( );
				
				fileName = Integer.toString(oCalendar.get(Calendar.YEAR))+Integer.toString(oCalendar.get(Calendar.MONTH) + 1)+Integer.toString(oCalendar.get(Calendar.DAY_OF_MONTH))+Integer.toString(oCalendar.get(Calendar.HOUR_OF_DAY))+Integer.toString(oCalendar.get(Calendar.MINUTE))+Integer.toString(oCalendar.get(Calendar.SECOND))+"."+ext;
				 
		
				File file = new File(path + "/file/group/"+groupid+"/"+type, fileName);
				file_name=fileName;
				//올리려는 파일과 같은 이름이 존재하면 중복파일 처리
				 if ( file.exists() ){
					 for(int k=0; true; k++){
						 String tempFile = k+"_"+fileName;
						 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
						 file = new File(path+"/file/group/"+groupid+"/"+type, tempFile);
						if(!file.exists()){ //존재하지 않는 경우
							 fileName = tempFile;
							 break;
						 }//if : 존재하지 않는 경우
					 }//for
				 }//if : 중복되면
			item.write(file);
			
			file_name=fileName;
			
			if(type.equals("img")){
			
				ImageManagement image = new ImageManagement();
								
				stateThumNail = image.ImageScaling(path + "/file/group/"+groupid+"/"+type,file_name,120,120);
			}
			String CheckString1 = "\\";
			String CheckString2 = "'";
		
		    msg = "/file/group/"+groupid+"/"+type+"/"+file_name;
		
			String tmpMSG = "";
		
			
			for(int m=0; m<msg.length(); m++){
				if(msg.charAt(m)==CheckString1.charAt(0)) tmpMSG+="\\";
				if(msg.charAt(m)==CheckString2.charAt(0)) tmpMSG+="\\'";
				else tmpMSG+=msg.charAt(m);
			} 
		
			msg=tmpMSG;
	
		 
		
			
			}
		}//else
		//out.println(name2 + ":"+ fname[file_num]);
	}//while
	
	if(userid!=null&&!userid.equals("")&&stateThumNail==0){
	
		try {	
		
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
		int maxcount = admin.countGroupMessageMember(userid,"1=1");	 
		
		
		
		Vector<AnyTalkInfo> vctDNSList = admin.selectDNSList("talkfile");
		
		int dns_maxcount = vctDNSList.size();
		int dns_count = 0;
		
		
		
		int o=0;
		
		int file_count = 0;
		
		
		
		msg = vctDNSList.elementAt(dns_count).name + msg;	
		
						
		if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++;
			
			
			
		
		for(int m=0; m<maxcount; m=m+50){
			
			
			Vector<AnyTalkInfo> vctMember = admin.selectGroupMessageMember(userid,50,0);
			
			if(file_count+2000<=m){
					file_count = m;
						
					try {
						String tmpFileName = o+"_"+fileName;
						File file = new File(path+"/file/group/"+groupid+"/"+type, tmpFileName);
						if ( file.exists() ){
							 for(int p=1; true; p++){
								 String tempFile = p+"_"+tmpFileName;
								 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
								 file = new File(path+"/file/group/"+groupid+"/"+type, tempFile);
								if(!file.exists()){ //존재하지 않는 경우
									 tmpFileName = tempFile;
									 break;
								 }//if : 존재하지 않는 경우
							 }//for
						 }//if : 중복되면
									 
				
									
					   FileInputStream fis = new FileInputStream(path+"/file/group/"+groupid+"/"+type+"/"+fileName);
					   FileOutputStream fos = new FileOutputStream(path+"/file/group/"+groupid+"/"+type+"/"+tmpFileName);
						   
					   int data = 0;
					   while((data=fis.read())!=-1) {
							fos.write(data);
					   }
					   fis.close();
					   fos.close();
					   
					
						
						 if(type.equals("img")){
									   
								FileInputStream fisThum = new FileInputStream(path + "/file/group/"+groupid+"/"+type+"/thum_"+fileName);
								FileOutputStream fosThum = new FileOutputStream(path + "/file/group/"+groupid+"/"+type+"/thum_"+tmpFileName);
										   
								int dataThum = 0;
								while((dataThum=fisThum.read())!=-1) {
									fosThum.write(dataThum);
								}
								fisThum.close();
								 fosThum.close();
									   
						}
								   
						
						msg = tmpFileName;	
		   				msg = vctDNSList.elementAt(dns_count).name + "/file/group/"+groupid+"/"+type+"/"+msg;	   
						
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
										File file = new File(path+"/file/group/"+info.name+"/"+type, tmpFileName1);
										if ( file.exists() ){
											 for(int p=1; true; p++){
												 String tempFile = p+"_"+tmpFileName1;
												 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
												 file = new File(path+"/file/group/"+info.name+"/"+type, tempFile);
												if(!file.exists()){ //존재하지 않는 경우
													 tmpFileName1 = tempFile;
													 break;
												 }//if : 존재하지 않는 경우
											 }//for
										 }//if : 중복되면
										
										
										
									   FileInputStream fis = new FileInputStream(path + "/file/group/"+info.name+"/"+type+"/"+fileName);
									   FileOutputStream fos = new FileOutputStream(path + "/file/group/"+info.name+"/"+type+"/"+tmpFileName1);
									   
									   int data = 0;
									   while((data=fis.read())!=-1) {
										fos.write(data);
									   }
									   fis.close();
									   fos.close();
									   
									   if(type.equals("img")){
									   
											FileInputStream fisThum = new FileInputStream(path + "/file/group/"+info.name+"/"+type+"/thum_"+fileName);
											FileOutputStream fosThum = new FileOutputStream(path + "/file/group/"+info.name+"/"+type+"/thum_"+tmpFileName1);
													   
											int dataThum = 0;
											while((dataThum=fisThum.read())!=-1) {
												fosThum.write(dataThum);
											}
											fisThum.close();
											 fosThum.close();
												   
									}
									   
									   //복사한뒤 원본파일을 삭제함
									   //File I = new File(filepath.getFilePath()+"/"+file_name);
  									   //I.delete();
									   
																	   
										msg = vctDNSList.elementAt(dns_count).name +"/file/group/"+info.name+"/"+type+"/"+tmpFileName1;	   
														
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
						
						if(file_count2+2000<=l){
							
							file_count2 = l;
						
							try {
								String tmpFileName = t+"_"+fileName;
								File file = new File(path+"/file/group/"+info.name+"/"+type, tmpFileName);
								if ( file.exists() ){
									 for(int p=t+1; true; p++){
										 t=p;
										 String tempFile = p+"_"+tmpFileName;
										 //파일명 중복을 피하기 위한 일련 번호를 생성하여 파일명으로 조합
										 file = new File(path+"/file/group/"+info.name+"/"+type, tempFile);
										if(!file.exists()){ //존재하지 않는 경우
											 tmpFileName = tempFile;
											 break;
										 }//if : 존재하지 않는 경우
									 }//for
								 }//if : 중복되면
								
							   FileInputStream fis = new FileInputStream(path+"/file/group/"+info.name+"/"+type+"/"+fileName);
							   FileOutputStream fos = new FileOutputStream(path+"/file/group/"+info.name+"/"+type+"/"+tmpFileName);
							   
							   int data = 0;
							   while((data=fis.read())!=-1) {
								fos.write(data);
							   }
							   fis.close();
							   fos.close();
							   
							   if(type.equals("img")){
									   
									FileInputStream fisThum = new FileInputStream(path + "/file/group/"+info.name+"/"+type+"/thum_"+fileName);
									FileOutputStream fosThum = new FileOutputStream(path + "/file/group/"+info.name+"/"+type+"/thum_"+tmpFileName);
													   
									int dataThum = 0;
									while((dataThum=fisThum.read())!=-1) {
										fosThum.write(dataThum);
									}
									fisThum.close();
									 fosThum.close();
												   
								}
							   
							   
								msg = tmpFileName;	
								//file_name = "/file/group/"+info.name+"/broadcast/"+file_name;	
								msg = vctDNSList.elementAt(dns_count).name + "/file/group/"+info.name+"/"+type+"/"+msg;	   
						
								if(dns_count+1>=dns_maxcount) dns_count = 0;
else dns_count++;
							   
							  } catch (IOException e) {
							   // TODO Auto-generated catch block
							   e.printStackTrace();
							  }	
							  
							  
							t++;
							  
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
							
							
							
								

								if(admin.checkSMSMessage(sms_id)<=0)admin.insertSMSMessage(group_id,userid,type,msg,sms_id);
							
							
							
						}
						
						for(int k=0; k<vctGroupMember.size(); k++){
					
							AnyTalkInfo infoGroup = (AnyTalkInfo)vctGroupMember.elementAt(k);
						
							SMSInfo infoSMS = new SMSInfo();
							
							msg = strReplace.replaces(msg);			
											
							infoSMS.msg_id = sms_id;
							infoSMS.user_id = userid;
							infoSMS.schedule_type = Integer.parseInt(ScheduleType);
							infoSMS.sms_msg = "<msg><info><filename>"+real_fileName+"</filename><file>"+msg+"</file></info></msg>";
							if(SendType.equals("0"))infoSMS.subject = "TalkSMS발송";
							else if(SendType.equals("1"))infoSMS.subject = "Talk발송";
							else if(SendType.equals("2"))infoSMS.subject = "SMS발송";
							infoSMS.callback = SendPhone;
							infoSMS.dest_type = 0;
							infoSMS.dest_count = 1;	
							infoSMS.dest_info = infoGroup.name+"^"+infoGroup.hp+"|";
							infoSMS.send_type = SendType;	
							infoSMS.now_date = date;	
							if(ScheduleType.equals("0"))infoSMS.send_date = date;
							else infoSMS.send_date = ScheduleDate;
							infoSMS.send_type = SendType;	
							infoSMS.send_msg_type = type;
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
								

							if(admin.checkSMSMessage(sms_id)<=0)admin.insertSMSMessage(group_id,userid,type,msg,sms_id);
							
						}
						
					
					SMSInfo infoSMS = new SMSInfo();
					
					msg = strReplace.replaces(msg);
									
					infoSMS.msg_id = sms_id;
					infoSMS.user_id = userid;
					infoSMS.schedule_type = Integer.parseInt(ScheduleType);
					infoSMS.sms_msg = "<msg><info><filename>"+real_fileName+"</filename><file>"+msg+"</file></info></msg>";
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
					infoSMS.send_msg_type = type;	
					infoSMS.send_group = info.state;	
					infoSMS.send_group_id = "all";		
					
					//infoSMS.cdr_id = "hanill07";
					
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
	
	}else if(stateThumNail==31){
		%>
         <script type="text/javascript">
		  	alert('썸네일 이미지가 지원되지 않은 이미지 파일 입니다.\npng 파일로저장하여 다시 업로드 하십시오.');
			window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/admin/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
			</script>
		<%
	
	}else if(stateThumNail>0){
	
				%>
             <script type="text/javascript">
		  	alert('업로드시 예기치 못한 오류가 발생하였습니다');
			window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/admin/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
			</script>    
                
			<%	
		
	}
  } catch (org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException e) {

          // 파일 사이즈 초과시 발생하는 익셉션
          //System.out.println("파일 사이즈가 5메가 보다 더 초과되었습니다");
		  %>
          <script type="text/javascript">
		  	alert('이미지 파일은 50MB 이상 업로드 할 수 없습니다.');
			window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/admin/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
			</script>
          <%
		 //out.print("2"); 
		  
      } catch (Exception e) {
          System.out.println("업로드시 예기치 못한 오류가 발생하였습니다");
		   %>
          <script type="text/javascript">
		  	alert('업로드시 예기치 못한 오류가 발생하였습니다');
			window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/admin/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
			</script>
          <%
		 //out.print("3"); 
      }
   
   


%>
<script type="text/javascript">		 
	success='<%=success%>'; 
	if(success==1)alert( '전송이 완료되었습니다..' );
	else alert( '전송 실패하였습니다..' );
	
	window.setTimeout("location='<%=pathtalkfile.getTalkURLPath()%>/admin/formGroupMessage.jsp'",1); //1ms후 페이지 자동이동
</script>

</body>
</html>

<%
/*
 DiskFileUpload 을 이용해서 파일 업로드를 처리하는 과정
 1. FileUpload.isMulipartContent(request) : multipart/form-data 전송했는지 체크
 2. DiskFileUpload 객체를 생성
 3. DiskFileUpload.parseRequest(request)로 전송한 데이터를 추출
 4. 리턴된 FileItem 목록을 사용하여 파일 및 파라미터를 처리

=== DiskFileUpload 객체 초기화 메소드들 ===
void setRepositoryPath() : 파일을 임시로 저장할 디렉토리를 지정
void setSizeMax()           : 최대로 업로드할 수 있는 파일의 크기를 바이트 단위로 지정
void setSizeThreshold()   : 메모리에 저장할 수 있는 최대 크기를 바이트 단위로 지정

=== FileItem(업로드한 파일)에 관한 메소드들 ===
boolean isFormField()     : 파일이 아닌 일반적인 입력 파라미터일 경우 true를 리턴
String getFieldName()     : 파라미터의 이름
String getString()            : 기본 캐릭터 셋을 사용하여 파라미터의 값 구함
String getString(String encoding) : 지정한 인코딩을 이용하여 파라미터의 값 구함
String getName()           : 업로드한 파일의 이름(경로포함)
long getSize()               : 업로드한 파일의 크기
void write(File file)        :  업로드한 파일을 file이 나타내는 파일로 저장
InputStream getInputStream()    :  업로드한 파일을 읽어오는 입력 스트림
byte[] get()                  : 업로드한 파일을 byte 배열로 구함
boolean isInMemory()    : 업로드한 파일이 메모리에 저장된 상태인 경우 true 리턴
                                     임시 디렉토리에 파일로 저장된 경우 false 리턴
void delete()                       : 파일과 관련된 자원 제거
*/
%>