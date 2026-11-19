<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="javafile.Report" %>
<!-- api키나 오라클 유저 비밀번호 부분 따로 관리 -->
<%@ include file="./config.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 신고 목록을 Report 객체로 관리
    List<Report> r_List = new ArrayList<>();
    //sql문 id를 기준으로 내림차순
    String sql = "SELECT * FROM report ORDER BY report_id DESC";

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        
        try (Connection conn = DriverManager.getConnection(url, user, pw);
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                // DB 데이터를 Report 객체로 변환
                Report report = new Report(
                    rs.getInt("report_id"),
                    rs.getString("title"),
                    null, // 안쓰는 데이터는 null 혹은 0 으로 받음.
                    null,
                    rs.getString("latitude"),
                    rs.getString("longitude"),
                    rs.getString("status"),
                    null,
                    0
                );
                r_List.add(report);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>해안 쓰레기 실시간 지도</title>
<!-- 카카오지도 API -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= KAKAO_API_KEY%>"></script>
<!-- 스타일태그 분리 main.css-->
<link rel="stylesheet" href="${pageContext.request.contextPath}/stylefile/main.css"> 
</head>
<body>
<div class="page">
    <%@ include file="/header.jsp" %>
    <div class="main">
        <!-- 신고 목록 -->
        <div class="sidebar">
            <h2>신고된 목록</h2>
            <hr>
            <br>
            <%
                if (r_List.isEmpty()) {
            %>
                <div class="empty_message">
                    접수된 신고 내역이 없습니다.
                </div>
            <%
                } else {
                    // 위쪽에서 불러온 r_List을 이용해 아래 div class = "report"에 저장
                    for (Report report : r_List) {
                        String title = report.getTitle();
                        String latitude = report.getLatitude();
                        String longitude = report.getLongitude();
                        String status = report.getStatus();
            %>
                <div class="report"
                     data-lat="<%= latitude %>"
                     data-lng="<%= longitude %>"
                     data-title="<%= title %>">
                    <h4>
                        <%= title %>
                    </h4>
                    <p>
                        상태 :
                        <% if ("처리 완료".equals(status)) { %>
                            <span class="status_green">해결 완료</span>
                        <% } else { %>
                            <span class="status_blue">접수</span>
                        <% } %>
                    </p>

                </div>
            <%
                    }
                }
            %>
        </div>
        <!--오른쪽 지도 부분 -->
        <div id="map" class="map_area"></div>

    </div>

</div>

<!--카카오 지도 및 마커 표시 -->
<script>

    // 지도 초기화
    var container = document.getElementById('map');

    var map = new kakao.maps.Map(container, {
        center: new kakao.maps.LatLng(35.117082, 129.048976),
        level: 7
    });

    // 지도 범위 설정
    var bounds = new kakao.maps.LatLngBounds();
	
    // 신고 목록 가져오기 (변수명을 reportCards로 통일)
    //위에 div clase = "report"에
    //data-lat=" latitude,
    //data-lng=" longitude",
    //data-title=" title "를 reportCards에 저장함
    //아래에서 forEach를 돌려 마커를 생성하기 위한 위도 경도 제목을 저장함.
    
    var reportCards = document.querySelectorAll('.report');

    reportCards.forEach(function(card) {
        //reportCard에서 위도 경도 제목을 뽑아냄.
        var lat = Number(card.dataset.lat);
        var lng = Number(card.dataset.lng);
        var title = card.dataset.title;

        // 지도 좌표 생성 // 위도 경도를 저장
        var position = new kakao.maps.LatLng(lat, lng);

        // 마커 생성 //위에 생성한 위도 경도를 바탕으로 마커생성
        var marker = new kakao.maps.Marker({
            position: position,
            map: map
        });

        // 마커 클릭 시 신고 제목 표시
        // createElement div를 동적으로 생성합니다. 
        var infoContent = document.createElement('div');
        infoContent.style.padding = '8px 12px';
        infoContent.style.fontSize = '13px';
        infoContent.style.whiteSpace = 'nowrap';
        infoContent.textContent = title;

        var infowindow = new kakao.maps.InfoWindow({
            content: infoContent
        });

        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
        });

        // 지도 범위에 신고 위치 추가
        bounds.extend(position);

        // 신고 목록 클릭 시 해당 위치로 이동
        card.addEventListener('click', function() {
            map.panTo(position);
            infowindow.open(map, marker);
        });

    });

    // 모든 신고 위치가 보이도록 지도 범위 조정
    if (!bounds.isEmpty()) {
        map.setBounds(bounds);
    }

</script>

</body>
</html>
