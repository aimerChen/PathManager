<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$("#apply").click(function(){
			alert("apply privileges!");
			window.location.href="#";
		});
	});
</script>
<title>Kickout</title>

</head>

<body>
	<div style="margin:20px;">
		<p>Denied</p>
		<input id="apply" type="button" class="btn btn-default"  value="申请权限"/>
	</div>
</body>
</html>