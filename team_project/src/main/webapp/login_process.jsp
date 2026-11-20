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
			/** 입력한 id, passwd 가져오기 */
			String id = request.getParameter("id");
			String passwd = request.getParameter("passwd");
			
			/** DB 이용을 위한 준비 */
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = "SELECT * FROM admin WHERE id = ?";
			
			/** 로그인 성공 여부를 저장하는 플래그 */
			boolean logInSuccess = false;
			
			try
			{
				
		        conn = DriverManager.getConnection(url, user, pw);
				pstmt = conn.prepareStatement(sql);
				/** ?에 id를 적용 */
				pstmt.setString(1, id);
				rs = pstmt.executeQuery();

				/** 
				 * 결과가 존재할 경우(즉, 일치하는 ID가 존재할 경우. sql 결과가 없으면 next() 실행 시 false가 반환됩니다.) 
				 */
				if(rs.next())
				{
					/** 비밀번호도 일치하는지 확인 */
					if(passwd.equals(rs.getString("password")))
					{
						/** 로그인 성공 플래그 true로 변경 */
						logInSuccess = true;
					}//if
				}//if
				
				
			}//try
			catch(SQLException e)
			{
				System.out.println("DB 접속 오류");
			}//catch
			finally
			{
				try {
					/** 마지막에 무조건 DB 닫기 */
					if(rs != null)
					{
						rs.close();
					}
					if(pstmt != null)
					{
						pstmt.close();
					}
					if(conn != null)
					{
						conn.close();
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					System.out.println("DB 종료 오류");
					e.printStackTrace();
				}// catch
			}// finally
			
			/** 로그인에 성공했는지 검사. 결과에 맞는 세션 설정 후 페이지 이동 */
			if(logInSuccess)
			{
				/** 로그인 성공 시 세션에 유저 이름, id, 권한 저장 */
				session.setAttribute("name", rs.getString("admin_name"));
				session.setAttribute("id", id);
				session.setAttribute("role", rs.getString("role"));
				
				/** 로그인 실패 횟수, 실패 시간 세션 삭제 */
				session.removeAttribute("loginFailCount");
				session.removeAttribute("loginFailTime");
				
				/** 메인 페이지로 이동*/
				response.sendRedirect("./home_page.jsp");
			}//if (로그인 성공)
			else
			{
				/** 로그인 실패했을 때 횟수를 카운트 */
				Object loginFailCount = session.getAttribute("loginFailCount");
				/** java.time을 이용해 시간 측정 및 처리*/
				LocalDateTime now = LocalDateTime.now();
				
				/** 첫 번쨰 틀렸을 때 */
				if(loginFailCount == null)
				{
					/** 실패 횟수 = 1, 현재 시간 + 10분 저장 */
					session.setAttribute("loginFailCount", 1);
					session.setAttribute("loginFailTime", now.plusMinutes(10));
				}
				else
				{
					/** 이미 실패한 적 있을 경우 실패 횟수를 하나 늘리고 현재 시간 + 10분을 다시 저장 */
					session.setAttribute("loginFailCount", (Integer)loginFailCount + 1);
					session.setAttribute("loginFailTime", now.plusMinutes(10));
				}
				
				/** 로그인 페이지로 다시 이동 */
				response.sendRedirect("./login.jsp");
			}// else (로그인 실패)
		%>

    </div><!-- /div class="main" -->
</div><!-- /div class="page" -->



</body>
</html>
