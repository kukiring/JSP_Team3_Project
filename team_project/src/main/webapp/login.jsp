<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javafile.Report" %>
<!-- api키나 오라클 유저 비밀번호 부분 따로 관리 -->
<%@ include file="./config.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<!-- 스타일태그 분리 main.css-->
<link rel="stylesheet" href="${pageContext.request.contextPath}/stylefile/main.css"> 
</head>
<body>

<%
	/** 마지막 로그인 실패 시간으로부터 10분이 지나면 로그인 실패 기록 삭제*/

	/** 마지막 로그인 실패 시간 + 10분을 가져오기 */
	LocalDateTime loginFailTime = (LocalDateTime)session.getAttribute("loginFailTime");
	/** 현재 시간 */
	LocalDateTime now = LocalDateTime.now();
	
	/** 로그인 실패 이력이 있을 경우 */
	if(loginFailTime != null)
	{	
		/** 로그인 실패 시간으로부터 10분이 지났는지 체크하고 지났다면 로그인 실패 이력 삭제 */
		if(now.isAfter(loginFailTime))
		{
			/** 로그인 실패 횟수, 실패 시간 세션 삭제 */
			session.removeAttribute("loginFailCount");
			session.removeAttribute("loginFailTime");
		}
	}
%>

<div class="page">
    <%@ include file="/header.jsp" %>
    <div class="main">
        <div class="login">
        	<form action = login_process.jsp method = "POST">
        	<%
			Object loginFailCount = session.getAttribute("loginFailCount");

        	/** 로그인 실패 횟수가 없거나 5회 미만일 경우 */
			if(loginFailCount == null || (Integer)loginFailCount < 5)
			{
			%>
			<p>아 이 디 : <input type = "text" name = "id" ></p>
        	<p>비밀번호 : <input type = "password" name = "passwd" ></p>
        	<p><input type = "submit" value = "로그인" ></p>	
			<% 	
				/** 로그인 실패 이력이 존재할 경우 출력*/
				if((Integer)loginFailCount != null)
				{
					out.print("<p>로그인 실패 횟수 " + (Integer)loginFailCount);
					out.print("<p>5회 실패할 경우 일시적으로 로그인이 차단됩니다. ");
				}
			}
			else
			{
			%>
			<p>아 이 디 : <input type = "text" name = "id" disabled></p>
        	<p>비밀번호 : <input type = "password" name = "passwd" disabled></p>
        	<p><input type = "submit" value = "로그인" disabled></p>
			<% 	
			/** 날짜 데이터를 원하는 형식으로 출력하기 위한 포멧 설정*/
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYYY년 MM월 dd일 HH시 mm분");			

			/** 로그인 차단 사유와 언제까지 차단되는지 출력 */
        	out.print("<p>로그인 실패 5회.");
        	out.print("<p>" + loginFailTime.format(formatter) + "까지 로그인이 차단됩니다.");
			}
        	%>
        	</form>
        </div><!-- /div class="login" -->
    </div><!-- /div class="main" -->

</div><!-- /div class="page" -->



</body>
</html>
