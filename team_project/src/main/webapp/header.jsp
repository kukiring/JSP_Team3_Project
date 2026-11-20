<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* 헤더 스타일 */
    .header {
        height: 60px;
        background-color: #2c3e50;
        color: #fff;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;
        border-bottom: 1px solid #1a252f;
    }
    .header .logo { font-size: 18px; font-weight: bold;}
    .header .logo a {color: #fff;}
    .header .nav-links a { color: #fff; text-decoration: none; margin-left: 20px; font-size: 14px; }
    .header .nav-links a:hover { color: #3498db; }
</style>
<header class="header">
    <div class="nav-links">
        <a href="./home_page.jsp">지도 보기</a>
        <a href="./list.jsp">신고 게시판</a>
        <a href="./write.jsp">쓰레기 신고하기</a>
    </div>
    <div class="logo">
	    <div > 해안 쓰레기 실시간 지도, 신고 플랫폼 /  
	    <%
	    Object loginName = session.getAttribute("name");

	    if(loginName == null )
	    {
	    	out.print("<a href='./login.jsp'>로그인</a>");
	    }
	    else
	    {
	    	out.print(String.valueOf(loginName) + "님 환영합니다.  ");
	    	out.print("[<a href='./logout.jsp'>로그아웃]</a>");
	    }
	    
	    %>
	     
	     </div>
	</div>
</header>