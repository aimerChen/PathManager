<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>User Tracking</title>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
<script type="text/javascript"
	src="<%=request.getContextPath() %>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

function logout(){
	var path="<%=request.getContextPath()%>";
		$.post(path + "/user/logout.shtml", function(data) {
			if (data === "success") {
				alert("退出成功");
				window.location.href = path + "/user/login.shtml";
			}
		});
	}
</script>
</head>
<body>
	<shiro:notAuthenticated>
		<p>
			请您<a href="<%=request.getContextPath()%>/user/login.shtml">登录</a>
		</p>
	</shiro:notAuthenticated>
<!--	<shiro:user>
		<p>认证通过或已记住的用户显示</p>
	</shiro:user>-->

	<shiro:authenticated>
<!--		<shiro:hasAnyRoles name="user,admin,sysUser">
			<a href="<%=request.getContextPath()%>/user/login.shtml">有权限</a>
		</shiro:hasAnyRoles>
		<shiro:hasRole name="admin">
			<p>是管理员</p>
		</shiro:hasRole>-->
		<a href="<%=request.getContextPath()%>/user/home.shtml">主页</a>
		<center>
			<h1>User Tracking</h1>
		</center>

		<table border="1" align="center">
			<tr bgcolor="#949494">
				<th>User info</th>
				<th>Value</th>
			</tr>
			<tr>
				<td>id</td>
				<td></td>
			</tr>
			<tr>
				<td>Creation Time</td>
				<td><%=session.getCreationTime()%></td>
			</tr>
			<tr>
				<td>Time of Last Access</td>
				<td><%=session.getLastAccessedTime()%></td>
			</tr>
			<tr>
				<td>session ID</td>
				<td><%=session.getId()%></td>
			</tr>
			<tr>
				<td>Number of visits</td>
				<td></td>
			</tr>
			<tr>
				<td>Attribute</td>
				<td></td>
			</tr>
		</table>
		<a href="#" onclick="logout()">注销</a>
	</shiro:authenticated>
</body>
</html>
