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

    //파일 저장 경로 설정 c드라이버에 파일 생성후 저장. // 
   String uploadPath = "/write_image_uploadfile/";

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

    int maxSize = 100 * 1024 * 1024; // 업로드 최대 용량 10MB
    String encType = "UTF-8";

    // DB 저장을 위해 변수 선언
    String user_name = null;
    String title = null;
    String wasteType = null;
    String latitude = null;
    String longitude = null;
    String content = null;
    
    //파일 담을 리스트
    List<String> savedFileNames = new ArrayList<>();
    
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
        //사진 저장하는 부분
        MultipartRequest multi = new MultipartRequest
        (
            request,
            uploadPath,
            maxSize,
            encType,
            new DefaultFileRenamePolicy() // 동일한 이름의 파일이 있으면 뒤에 번호를 붙여 충돌 방지
        );

        //폼 데이터 받아오기 "MultipartRequest"를 통해 텍스트를 가져옴
        user_name = multi.getParameter("name");
        title = multi.getParameter("title");
        wasteType = multi.getParameter("wasteType");
        latitude = multi.getParameter("latitude");
        longitude = multi.getParameter("longitude");
        content = multi.getParameter("content");

        // 필수 데이터 검증 널값이거나 값이 없으면 원래 페이지로 돌아가도록 설정.
        if
        (
           user_name == null || user_name.trim().isEmpty() ||
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
        
        Enumeration<?> files = multi.getFileNames();
        while (files.hasMoreElements()) {
            String name = (String) files.nextElement();
            // 해당 파일 입력창에 실제로 업로드된 파일이 있을 경우에만 가져옴
            String savedFileName = multi.getFilesystemName(name);
            System.out.println(savedFileName);
            if (savedFileName != null) {
                savedFileNames.add(savedFileName);
            }
        }


        //테스트용 코드
        System.out.println("저장 경로: " + uploadPath);
        System.out.println("업로드 폴더 존재: " + uploadDir.exists());
        System.out.println("업로드 폴더 쓰기 가능: " + uploadDir.canWrite());

    } catch (Exception e) {

        e.printStackTrace();

        out.println("<script>");
        out.println("alert('파일 업로드에 실패했습니다.');");
        out.println("location.href='./write.jsp';");
        out.println("</script>");
        return;
    }
    
 // 위도, 경도를 double 타입으로 변환
    double lat = Double.parseDouble(latitude);
    double lon = Double.parseDouble(longitude);

    // 대한민국 기준 중심점 (세종시)
    double centerLat = 36.5;
    double centerLon = 127.5;

    int admin = 1;

    // 4분면 판별
    if (lat >= centerLat) {
        if (lon < centerLon) {
        	admin = 1; // 1사분면 북서 (수도권)
        } else {
        	admin= 2; // 2사분면 북동 (강원도)
        }
    } else {
        if (lon < centerLon) {
        	admin = 3; // 3사분면 남서 (전라,제주 등)
        } else {
        	admin = 4; // 4사분면 남동 (경상,부산,대구 등)
        }
    }

    //필요시 수정.
    // sql문
	// DB 저장 처리
    String report_sql = "INSERT INTO report (user_name, title, waste_type, latitude, longitude, content, admin_no) VALUES (?, ?, ?, ?, ?, ?, ?)";
    String fileSql = "INSERT INTO image_file (report_id, file_name) VALUES (?, ?)";

    Connection conn = null;
    PreparedStatement pstmt_Report = null;
    PreparedStatement pstmt_File = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, user, pw);
        
        conn.setAutoCommit(false);

        // 리포트 테이블 INSERT (자동 생성된 PK를 가져오기 위해 ID 지정)
        String[] report_primaryk = {"report_id"};
        pstmt_Report = conn.prepareStatement(report_sql, report_primaryk);
        
        pstmt_Report.setString(1, user_name);
        pstmt_Report.setString(2, title);
        pstmt_Report.setString(3, wasteType);
        pstmt_Report.setString(4, latitude);
        pstmt_Report.setString(5, longitude);
        pstmt_Report.setString(6, content);
        pstmt_Report.setInt(7, admin);
        
        pstmt_Report.executeUpdate();

        // 방금 생성된 리포트의 primarykey값 가져오기
        int ReportId = -1;
        rs = pstmt_Report.getGeneratedKeys();
        if (rs.next()) {
            ReportId = rs.getInt(1);
        } 
        
        //  업로드된 파일이 있다면 image_file 테이블에 인서트
        if (!savedFileNames.isEmpty() && ReportId != -1) {
            pstmt_File = conn.prepareStatement(fileSql);
           
            for (String savedFileName : savedFileNames) {
                pstmt_File.setInt(1, ReportId);
                pstmt_File.setString(2, savedFileName);
                pstmt_File.addBatch();
            }
            
            pstmt_File.executeBatch();
        }

        
        conn.commit(); // 성공 시 커밋

    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        }
        
        out.println("<script>");
        out.println("alert('DB저장에 실패했습니다.');");
        out.println("location.href='./write.jsp';");
        out.println("</script>");
        return;
    } 
    finally 
    {
        if (conn != null) conn.close();
        if (pstmt_Report != null) pstmt_Report.close();
        if (pstmt_File != null) pstmt_File.close();
        if (rs != null) rs.close();
    }

	//아직 리스트 부분 구현안되어 있어 주석처리함.
    //response.sendRedirect(request.getContextPath() + "/list.jsp");
		
%>
	<p>현재 list.jsp를 작성 안해서 write_process.jsp에서 멈춘게 정상입니다. 오라클에서 select 해보고 데이터 저장되었는지 확인해주세요.
	<p>list.jsp는 구현 안되어있지만 main엔 신고 내역이 올라올겁니다.