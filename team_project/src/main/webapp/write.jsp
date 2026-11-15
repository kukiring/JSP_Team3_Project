<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>해안 쓰레기 신고하기</title>
<!-- 카카오 지도 API Script -->
<%@ include file="./config.jsp" %>
<!-- config.jsp로 api키 관리 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%= KAKAO_API_KEY%>"></script>
<!-- 스타일 부분 길어져서 다른 파일로 분류함. -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/stylefile/write.css"> 
</head>
<body>
    <div class="page-wrapper">
        <!-- 상단 헤더 -->
	<%@ include file="/header.jsp" %>

        <!-- 메인신고 폼 및 위치 선택 영역 -->
        <div class="container">
            <!-- 좌측 입력 폼 -->
            <div class="form-area">
                <h2>쓰레기 신고 등록</h2>
				<!-- 사진 입력을 위한 enctype="multipart/form-data" -->
                <form action="./write_process.jsp" method="post"enctype="multipart/form-data">
                
                    <div class="form-group">
                        <label for="title">신고제목</label>
                        <input type="text" id="title" name="title" placeholder="예: 속초 해수욕장 스티로폼 발견" required>
                    </div>
                    <div class="form-group">
                        <label for="title">제보자이름</label>
                        <input type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label for="wasteType">쓰레기 유형</label>
                        <input type="text" id="wasteType" name="wasteType" placeholder="예: 플라스틱, 페트병, 기타쓰레기" required>
                    </div>
                    <!-- 해당부분 jsp교재 파일업로드 부분 참고 -->
                    <div class="form-group">
	                    <label for="uploadFile">상세사진</label>
						<input type="file" name="uploadFile" multiple><br>
					</div>
                    <div class="form-group">
                        <label>선택한 위치 좌표 (지도 클릭으로 입력가능)</label>
                        <div class="latlng-box">
                            <input type="text" id="latitude" name="latitude" placeholder="위도(Lat)" readonly required>
                            <input type="text" id="longitude" name="longitude" placeholder="경도(Lng)" readonly required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="content">상세설명</label>
                        <textarea id="content" name="content" placeholder="발견 위치의 특징이나 쓰레기 양 등을 상세히 적어주세요."></textarea>
                    </div>
			
                    <button type="submit" class="btn-submit">신고 제출하기</button>
                </form>
            </div>

            <!-- 우측 위치 지정 지도 -->
            <div id="map" class="map-area">
            </div>
        </div>
    </div>

    <script>
    	// 지도 마커 구현부 //https://apis.map.kakao.com/web/guide/ 해당 사이트 참고 하고 작성함.
        // 카카오 지도 생성 
        // div id="map"에 생성
        var container = document.getElementById('map');
        var options = {
            center: new kakao.maps.LatLng(35.117082, 129.048976), // 기본 중심 좌표 (부산으로 임의 설정)
            level: 7
        };
        var map = new kakao.maps.Map(container, options);

        // 클릭 시 마커 생성
        var marker = new kakao.maps.Marker({
            position: map.getCenter()
        });
        
        // 지도를 클릭하기 전까지는 마커를 보이지 않게 세팅
        marker.setMap(null);

        // 지도 클릭 이벤트 등록
        kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
            // 클릭한 위도, 경도 정보 가져오기
            var latLng = mouseEvent.latLng;

            // 마커 위치를 클릭한 곳으로 이동시키고 지도에 표시
            marker.setPosition(latLng);
            marker.setMap(map);

            // 좌측 폼 input에 좌표값 입력하기
            document.getElementById('latitude').value = latLng.getLat().toFixed(6);
            document.getElementById('longitude').value = latLng.getLng().toFixed(6);
        });
    </script>
</body>
</html>