
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="./config.jsp" %>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= KAKAO_API_KEY%>"></script>

<%

    request.setCharacterEncoding("UTF-8");

    // 사진 파일 저장 코드

    //파일 저장 경로 설정 c드라이버에 파일 생성후 저장.
   String uploadPath = "C:/write_image_uploadfile/";

    //위 경로로 파일 경로 설정
    File uploadDir = new File(uploadPath);

    //만약 해당 파일이 없을시 파일생성
    if (!uploadDir.exists())
    {
        uploadDir.mkdirs();
    }

    //해당부분 jsp교재에 파일업로드 부분 참고해 작성 했습니다. 
    //cos.jar 오픈 라이브러리 다운로드해 사용가능.
    //

    int maxSize = 10 * 1024 * 1024; // 업로드 최대 용량 10MB
    String encType = "UTF-8";

    // DB 저장을 위해 변수 선언
    String name = null;
    String title = null;
    String wasteType = null;
    String latitude = null;
    String longitude = null;
    String content = null;
    String imageFilesStr = null;

    try
    {
        //MultipartRequest 객체 생성
        /*
        MultipartRequest multi = new MultipartRequest(
            request, 
            "./write_image_uploadfile/", 
            10 * 1024 * 1024, 
            "UTF-8", 
            new DefaultFileRenamePolicy() // 동일한 이름의 파일이 있으면 뒤에 번호를 붙여 충돌방지
        );
        위 코드랑 똑같습니다.*/

        MultipartRequest multi = new MultipartRequest
        (
            request,
            uploadPath,
            maxSize,
            encType,
            new DefaultFileRenamePolicy() // 동일한 이름의 파일이 있으면 뒤에 번호를 붙여 충돌 방지
        );

        //폼 데이터 받아오기 "MultipartRequest"를 통해 텍스트를 가져옴
        name = multi.getParameter("name");
        title = multi.getParameter("title");
        wasteType = multi.getParameter("wasteType");
        latitude = multi.getParameter("latitude");
        longitude = multi.getParameter("longitude");
        content = multi.getParameter("content");

        // 필수 데이터 검증 널값이면 원래 페이지로 돌아가도록 설정.
        if
        (
            name == null || name.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            wasteType == null || wasteType.trim().isEmpty() ||
            latitude == null || latitude.trim().isEmpty() ||
            longitude == null || longitude.trim().isEmpty() ||
            content == null || content.trim().isEmpty()
        )
        	
        {
            out.println("<script>");
            out.println("alert('모든 항목을 입력해주세요.');");
            out.println("location.href='" + request.getContextPath() + "/write.jsp';");
            out.println("</script>");
            return;
        }

     // 업로드된 파일 이름들 수집
        List<String> savedFileNames = new ArrayList<String>();

        Enumeration<?> files = multi.getFileNames();

        while (files.hasMoreElements())
        {
            String fileParamName = (String) files.nextElement();

            String savedFileName = multi.getFilesystemName(fileParamName);

            // 파일을 선택하지 않았다면 null이므로 저장하지 않음
            if (savedFileName != null && !savedFileName.trim().isEmpty())
            {
                savedFileNames.add(savedFileName);
            }
            
        }

        // 사진이 없으면 빈 문자열 저장
        imageFilesStr = String.join(",", savedFileNames);

        /* 위 코드 for문으로 구현했는데 join써서 구현함.

        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < savedFileNames.size(); i++) {
            sb.append(savedFileNames.get(i)); // 파일명 추가

            // 마지막 파일이 아닐 경우에만 콤마(,)를 붙임 (마지막에 콤마가 붙는 것 방지)
            if (i < savedFileNames.size() - 1) {
                sb.append(",");
            }
        }

        String imageFilesStr = sb.toString();
        */
        //테스트용 코드
        System.out.println("저장 경로: " + uploadPath);
        System.out.println("업로드 폴더 존재: " + uploadDir.exists());
        System.out.println("업로드 폴더 쓰기 가능: " + uploadDir.canWrite());

    } catch (Exception e) {

        e.printStackTrace();

        out.println("<script>");
        out.println("alert('파일 업로드에 실패했습니다.');");
        out.println("location.href='" + request.getContextPath() + "/write.jsp';");
        out.println("</script>");
        return;
    }


    //필요시 수정.
    // DB구성
    String sql =
    "INSERT INTO JSP_DB (title, name, waste_type, latitude, longitude, content, image_file) VALUES (?, ?, ?, ?, ?, ?, ?)";


    try
    {
    	Class.forName("oracle.jdbc.driver.OracleDriver");

        try
        (
            Connection conn = DriverManager.getConnection(url, user, pw);
            PreparedStatement pstmt = conn.prepareStatement(sql)
        )
        {
            pstmt.setString(1, title);
            pstmt.setString(2, name);
            pstmt.setString(3, wasteType);
            pstmt.setString(4, latitude);
            pstmt.setString(5, longitude);
            pstmt.setString(6, content);          // CLOB 데이터 처리
            pstmt.setString(7, imageFilesStr);    // 콤마로 묶인 파일명 문자열

            pstmt.executeUpdate();
        }

    } catch (Exception e) {

        e.printStackTrace();

        out.println("<script>");
        out.println("alert('DB저장에 실패했습니다.');");
        //저장실패시 write.jsp로 이동
        out.println("location.href='" + request.getContextPath() + "/write.jsp';");
        out.println("</script>");
        return;
    }
	//아직 리스트 부분 구현안되어 있어 주석처리함.
    //response.sendRedirect(request.getContextPath() + "/list.jsp");

%>
