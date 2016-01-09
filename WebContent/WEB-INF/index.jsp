<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>User Tracking</title>

<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/css/bootstrap.css" />
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/jquery-2.1.4.min.js"></script>
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
	<div style="margin:20px;">
		<shiro:authenticated>
			<a href="<%=request.getContextPath()%>/user/home.shtml">主页</a>
			<a href="#" onclick="logout()">注销</a>
			<center>
				<h1>User Tracking</h1>
			</center>
		</shiro:authenticated>
	</div>
</body>
</html>
