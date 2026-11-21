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
<title>로그인 중...</title>
<!-- 스타일태그 분리 main.css-->
<link rel="stylesheet" href="${pageContext.request.contextPath}/stylefile/main.css"> 
</head>
<body>
<div class="page">
    <%@ include file="/header.jsp" %>
    <div class="main">
		<%
			/** 세션에 저장된 로그인 정보 삭제 */
			session.removeAttribute("name");
			session.removeAttribute("id");
			session.removeAttribute("role");
			
			/** 메인 페이지로 이동*/
			response.sendRedirect("./home_page.jsp");
		%>
    </div><!-- /div class="main" -->
</div><!-- /div class="page" -->



</body>
</html>
