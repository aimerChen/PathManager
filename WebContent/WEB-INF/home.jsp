<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>User Home</title>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

function logout(){
	var path="<%=request.getContextPath()%>";
	$.post(path+"/user/logout.shtml",function(data){
		if(data==="success"){
			alert("退出成功");
			window.location.href=path+"/user/login.shtml";
		}
	});
}
</script>
</head>
<body>
<shiro:notAuthenticated>
	<p>	请您<a href="<%=request.getContextPath()%>/user/login.shtml">登录</a></p>
</shiro:notAuthenticated>

<shiro:authenticated>
	<shiro:hasRole name="sysUser">
		<ul>
			<li><a href="<%=request.getContextPath()%>/sysUser/createRole.shtml">管理角色</a></li>
			<li><a href="<%=request.getContextPath()%>/sysUser/createPath.shtml">管理路径</a></li>
			<li><a href="<%=request.getContextPath()%>/sysUser/createUser.shtml">管理用户</a></li>
		</ul>
	</shiro:hasRole>
	<shiro:hasRole name="admin">
		<p>管理员</p>
	</shiro:hasRole>
	<center>
		<h1>User Home</h1>
	</center>
	<div>
		<p><a href="<%=request.getContextPath()%>/test/test.jsp">Test</a></p>
		<p><a href="<%=request.getContextPath()%>/Manager/manager.jsp">Manager</a></p>
		<p><a href="<%=request.getContextPath()%>/Guests/guest.jsp">Guest</a></p>
		<p><a href="<%=request.getContextPath()%>/Admin/admin.jsp">Admin</a></p>
	</div>
	<table border="1" align="center">
		<tr bgcolor="#949494">
			<th>User info</th>
			<th>Value</th>
		</tr>
		<tr>
			<td>id</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>Creation Time</td>
			<td><%=session.getCreationTime() %>
			</td>
		</tr>
		<tr>
			<td>Time of Last Access</td>
			<td><%=session.getLastAccessedTime()%>
			</td>
		</tr>
		<tr>
			<td>session ID</td>
			<td><%=session.getId() %>
			</td>
		</tr>
		<tr>
			<td>Number of visits</td>
			<td>
			</td>
		</tr>
		<tr>
			<td>Attribute</td>
			<td>
			</td>
		</tr>
	</table>
	<a href="#" onclick="logout()">注销</a>
</shiro:authenticated>
</body>
</html>
