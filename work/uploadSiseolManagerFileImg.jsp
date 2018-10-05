<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="AnyTalkBean.TalkFile.*" %>
<%@ page import="java.util.*, AnyTalkBean.*" %>
<jsp:useBean id="admin" class="AnyTalkBean.QueryExt" scope="page" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src= "https://code.jquery.com/jquery-3.1.1.min.js"></script>
<title>Insert title here</title>
</head>
<%
request.setCharacterEncoding("UTF-8");

PathTalkFile pathtalkfile = new PathTalkFile();

// 신고 정보
String m_num = "";
String m_id = "";
String m_phone = "";
// 처리 정보
String file_name = "";
String m_msg = "";
String manager_name = "";
String manager_phone = "";
String r_date = "";
String m_status = "";
String rank = "";

String msg = "";

int file_num=0;
int updateCount=0;
int i = 0;
int success = 0;

try{	
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
		if (item.isFormField()) {
			switch(i){
				case 0:{
					m_num=item.getString("UTF-8");
					break;
				}
				case 1:{
					m_status = item.getString("UTF-8");
					if(m_status.equals("S")){
						rank = "siseol";
					}else if(m_status.equals("D")){
						rank = "disaster";
					}else if(m_status.equals("O")){
						rank = "oyem";
					}
					break;
				}
				case 2:{
					m_msg = item.getString("UTF-8");
					break;
				}
				case 3:{
					manager_name = item.getString("UTF-8");
					break;
				}
				case 4:{
					manager_phone = item.getString("UTF-8");					
					break;
				}
				case 5:{
					r_date = item.getString("UTF-8");
					break;
				}
			}
			i++;
		}else{			
			File dirMain = new File(filepath.getFilePath() + "/file/" + rank + "/answer");
			if (!dirMain.exists()){
				dirMain.mkdirs();
			}
			File dirImg = new File(filepath.getFilePath() + "/file/" + rank + "/answer/img");
			if (!dirImg.exists()){
				dirImg.mkdirs();
			}
			
			String fileFieldName = item.getName();
			String fileName = item.getName();
			int idx = fileName.lastIndexOf("\\");//윈도우의 경우
			if (idx == -1) {
				idx = fileName.lastIndexOf("/");//유닉스(리눅스)의 경우
			}
			
			fileName = fileName.substring(idx + 1);
			long fileSize = item.getSize();
			
			if(fileName == ""){
				updateCount = 1;
			}else{
				String ext = "";
				int j = fileName.lastIndexOf('.');
				if(j > 0 && j < fileName.length() - 1){
					ext = fileName.substring(j + 1).toLowerCase();
				}
				
				Calendar calendar = Calendar.getInstance();
				
				fileName = Integer.toString(calendar.get(Calendar.YEAR)) + Integer.toString(calendar.get(Calendar.MONTH) + 1) + Integer.toString(calendar.get(Calendar.DAY_OF_MONTH)) + Integer.toString(calendar.get(Calendar.HOUR_OF_DAY)) + Integer.toString(calendar.get(Calendar.MINUTE)) + Integer.toString(calendar.get(Calendar.SECOND)) + "." + ext;
				
				File file = new File(path + "/file/" + rank + "/answer/img", fileName);
				file_name = fileName;
				//올리려는 파일과 같은 이름이 존재하면 중복파일 처리
				if(file.exists()){
					for(int k = 0; true; k++){
						String tempFile = k+"_"+fileName;
						file = new File(path + "/file/" + rank + "/answer/img", tempFile);
						file_name = fileName;
						if(!file.exists()){
							fileName = tempFile;
							break;
						}
					}
				}
				
				item.write(file);
				file_name=fileName;
				
				ImageManagement image = new ImageManagement();
				image.ImageScaling(path + "/file/" + rank + "/answer/img", file_name, 120, 120);
				
				String CheckString1 = "\\";
				String CheckString2 = "'";
				
				msg = path + "/file/" + rank + "/answer/img/" + file_name;
				
				String tmpMSG = "";
				
				for(int m = 0; m < msg.length(); m++){
					if(msg.charAt(m) == CheckString1.charAt(0)){
						tmpMSG += "\\";
					}
					if(msg.charAt(m) == CheckString2.charAt(0)){
						tmpMSG += "\\'";
					}else{
						tmpMSG += msg.charAt(m);
					}
				}
				msg = tmpMSG;
			}
		}
	}
	
	if(m_num != null && !m_num.equals("")){
		try{
			admin.makeConnection();
			
			AnyTalkExtInfo info = new AnyTalkExtInfo();
			info = admin.selectManagerReport(m_num);
			
			AnyTalkExtInfo myModel = new AnyTalkExtInfo();
			
			myModel.m_num = info.m_num;
			myModel.m_id = info.m_id;
			myModel.m_phone = info.m_phone;
			myModel.m_location_x = info.m_location_x;
			myModel.m_location_y = info.m_location_y;
			myModel.m_msg = m_msg;
			myModel.m_file_type = "img";
			myModel.m_file_thumbnail = "/file/" + rank + "/answer/img/thum_" + file_name;
			myModel.m_file_name1 = "/file/" + rank + "/answer/img/" + file_name;
			myModel.s_file_name2 = "";
			myModel.s_file_name3 = "";
			myModel.manager_name = manager_name;
			myModel.manager_phone = manager_phone;
			myModel.r_date = r_date;
			myModel.m_status = m_status;
			
			admin.insertManagerAnswer(myModel);
			success = 1;
		}catch(Exception e){
			out.println("연결되지 않았습니다.");
			out.println(e.getMessage());
			e.printStackTrace();
		}finally{
			try{
			admin.disConnect();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
}catch(org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException e){
	// 파일 사이즈 초과시 발생하는 익셉션
	%>
    <script>
	alert('이미지 파일은 50MB 이상 업로드 할 수 없습니다.');

	window.close();
	</script>
    <%
}catch(Exception e){
	//out.print("<script>alert('" + e.getMessage() + "')</script>");
	%>
    <script>
	alert('업로드시 예기치 못한 오류가 발생하였습니다.');
	
	window.close();
	</script>
    <%
}
%>
<script>
$(document).ready(function(){
	window.close();
});
</script>
<body>

</body>
</html>