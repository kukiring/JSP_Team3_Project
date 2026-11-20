<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.*" %>
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
        	out.print("<p>로그인 실패 5회.");
        	out.print("<p>" + (Integer)loginFailCount + "까지 로그인이 차단됩니다.");
			}
        	%>
        	</form>
        </div><!-- /div class="login" -->
    </div><!-- /div class="main" -->

</div><!-- /div class="page" -->



</body>
</html>
