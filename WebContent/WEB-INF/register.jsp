<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/md5.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var path="<%=request.getContextPath()%>";
		$("#login").click(function(){
			window.location.href=path+"/user/login.shtml";
		});
		$("#register").click(function(){
			var name=$("#name").val();
			var password=faultylabs.MD5($("#password").val());
			if(name==""||password==""){
				return false;
			}
			if($("#password").val()==$("#repeatPassword").val()){
				$.post(path+"/user/register.shtml",{name:name,password:password},function(data){
					if(data==="success"){
						window.location.href=path+"/user/login.shtml";
					}else{
						alert("注册失败");
					}
				});
				return true;
			}else{
				alert("密码不一致");				
			}
			return false;
		});
	});
</script>

<title>Register</title>

</head>

<body>

	<shiro:guest>
		<div style="margin:20px;width:300px;height:300px;">
			<form id="registerForm">
				<div class="form-group">
					<label for="name">用户名</label> 
					<input type="text" class="form-control" id="name" placeholder="用户名">
				</div>
				<div class="form-group">
					<label for="password">密码</label> 
					<input type="password" class="form-control" id="password" placeholder="密码">
				</div>
				<div class="form-group">
					<label for="repeatPassword">重复密码</label> 
					<input type="password" id="repeatPassword" class="form-control"   placeholder="重复密码" />
				</div>
				<button type="button" class="btn btn-default" id="login">取消</button>
				<button type="button" class="btn btn-default" id="register" style="float:right;">注册</button>
			</form>
		</div>
	</shiro:guest>
		
	<shiro:authenticated>
		<p>您已经登录</p>
		<p><a href="" id="logoutA"></a></p>
	</shiro:authenticated>
</body>
</html>