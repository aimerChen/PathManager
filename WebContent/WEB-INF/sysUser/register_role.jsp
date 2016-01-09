<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
<style type="text/css">
.bg
{
	background-color: #666;
	width: 100%;
	height: 100%;
	left: 0;
	top: 0;
	filter: alpha(opacity=50);
	opacity: 0.5;
	z-index: 1;
	position: fixed !important; /*FF IE7*/
	position: absolute;
	_top: expression(eval(document.compatMode &&document.compatMode=='CSS1Compat') ?
	documentElement.scrollTop + (document.documentElement.clientHeight-this.offsetHeight)/2 :/*IE6*/
	document.body.scrollTop + (document.body.clientHeight - this.clientHeight)/2); /*IE5 IE5.5*/
}
</style>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

	var requestPath="<%=request.getContextPath()%>";
	function changeModel(model,id){
		var object =$("#roleLabelTr_"+id);
		var objectEdit =$("#roleEditTr_"+id);
		var name=$("#roleNameLabel_"+id).text();
		if(model===1){//转换到编辑模式
			$(object).hide();
			$(objectEdit).show();
		}else{//转换到显示模式
			$("#roleEditNameLabel_"+id).val(name);
			$(objectEdit).hide();
			$(object).show();
		}
	}
	
	//提交更新了的Role
	function submitEditRoleById(id){
		var nameBefore=$("#roleNameLabel_"+id).text();
		var nameAfter=$("#roleEditNameLabel_"+id).val();
		//三个需要跟新的tr
		var object =$("#roleLabelTr_"+id);
		var objectEdit =$("#roleEditTr_"+id);
		//名字是否改变
		if(nameBefore!==nameAfter&&nameAfter!=""){
			$.post(requestPath+"/sysUser/updateRoleById.shtml",{id:id,name:nameAfter},function(data){
				if(data===1){
					//更新成功
					$("#roleNameLabel_"+id).text(nameAfter);
					$(objectEdit).hide();
					$(object).show();
				}else{
					alert("更新失败");
					return;
				}
			});
		}else{
			$(objectEdit).hide();
			$(object).show();
		}
	}
	
	//显示一个path所用的role
	function center(obj){
	 	var windowWidth = document.documentElement.clientWidth;  
	 	var windowHeight = document.documentElement.clientHeight;  
	 	var popupHeight = $(obj).height();  
	 	var popupWidth = $(obj).width();   
	 	$(obj).css({
	  		"position": "absolute",  
	  		"top": (windowHeight-popupHeight)/2+$(document).scrollTop(),  
	  		"left": (windowWidth-popupWidth)/2,
	  		"z-index": 99
	 	}); 
	}
	
	//显示一个role所用的path
	function showPathsDiv(id){
		var pathsTable=$("#pathsofRoleTable_"+id).children().length;
		if(pathsTable>0){
			//显示弹出层
			$("#bg").show();
			center($("#popDivShowPaths"));
	        $("#popDivShowPaths").show();
	        $("#pathsofRoleTable_"+id).show();
		}else{
			alert("该角色没有路径权限");
		}
	}
	
	function hidePathsDiv(pathid){
		//隐藏弹出层
		$("#bg").hide();
        $("#popDivShowPaths").hide();
        $("#pathsofRoleTable_"+pathid).hide();
	}
	
	//获取所有的Role
	function getAllRoles(){
		$.post(requestPath + "/sysUser/showAllRoles.shtml", function(data) {
			if (data !== null) {
				var tempStr = eval(data);
				var html="";
				var pathHtml="<div class='panel panel-default' style='vertical-align:middle;text-align:center;'><div class='panel-heading'><h4>角色权限</h4></div>";
				$.each(tempStr, function(index,item){
				   	pathHtml+="<table id='pathsofRoleTable_"+item.id+"' class='table'  style='display:none'>";
					html+="<tr id='roleLabelTr_"+item.id+"' >"
						+"<td width='50%' style='vertical-align:middle;text-align:left;'><label id='roleNameLabel_"+item.id+"'>"+item.name+"</label></td>"
						+"<td width='30%' style='vertical-align:middle;text-align:left;'><label id='roleCreateTimeLabel_"+item.id+"' style='font-size:12px;font-weight:normal;'>"+item.createTime+"</label></td>"
						+"<td width='10%'><input type='button' id='editRole_"+item.id+"' class='btn btn-default' value='编辑' onclick='changeModel(1,"+item.id+")'/>"
						+"</td><td width='10%'><input type='button' id='deleteRole_"+item.id+"' class='btn btn-default' style='margin-right:20px;' onclick='deleteRoleById("+item.id+")' value='删除'/></td>"
						+"</tr>"
					html+="<tr id='roleEditTr_"+item.id+"' style='display:none;'>"
						+"<td width='50%' style='vertical-align:middle;text-align:left;'><input id='roleEditNameLabel_"+item.id+"' class='form-control' type='text' value='"+item.name+"'/></td>"
						+"<td width='30%'><input type='button' id='submitEditRole_"+item.id+"' class='btn btn-default' onclick='showPathsDiv("+item.id+")' value='显示权限'/>"
						+"<td width='10%'><input type='button' id='submitEditRole_"+item.id+"' class='btn btn-default' onclick='submitEditRoleById("+item.id+")' value='提交'/>"
						+"</td><td width='10%' ><input type='button' id='cancelEditRole_"+item.id+"' class='btn btn-default'	style='margin-right:20px;' onclick='changeModel(2,"+item.id+")' value='取消'/></td>"
						+"</tr>";
  					if(item.paths!=null&&item.paths!=""){
						pathHtml+="<tr><td style='vertical-align:middle;text-align:center;border-right:1px solid #DDD;' rowspan='"+(item.paths.length+1)+"' width='20%'>"+item.name+"</td></tr>";
						$.each(item.paths,function(i,path){
							pathHtml+="<tr width='80%'><td><label>"+path.name+"</label>";
							pathHtml+="</td></tr>";
						});
						//添加两个按钮
						pathHtml+="<tr><td><input type='button' value='取消' class='btn btn-default' onclick='hidePathsDiv("+item.id+")'/></td><td><input type='button' value='确定' onclick='hidePathsDiv("+item.id+")' class='btn btn-default' style='float:right;'/></td></tr>";
					}		
 					pathHtml+="</table>";
		        });
				pathHtml+="</div>";
				$("#popDivShowPaths").html(pathHtml);//插入到弹出层
				$("#rolesTableDiv").html(html);//插入到页面显示
			}
		});
	}
	
	//删除Role
	function deleteRoleById(id){
		$.post(requestPath + "/sysUser/deleteRoleById.shtml",{id:id},function(data) {
			if (data ===1) {
				$("#roleLabelTr_"+id).remove();
				$("#roleEditTr_"+id).remove();
			}else{
				alert("删除失败");
			}
		});
	}

	
	$(document).ready(function(){
		getAllRoles();
		$("#register").click(function(){
			var name=$("#name").val();
			if(name==""){
				alert("角色名字不能为空");
				return false;
			}
			$.post(requestPath+"/sysUser/createRole.shtml",{name:name},function(data){
				if(data===1){
					$("#name").val("");
					getAllRoles();
				}else if(data===0){
					alert("名字存在，添加失败");
				}else if(data==2){
					alert("该角色不能被创建");
				}else{
					alert("内部错误，添加失败");
				}
			});
			return false;
		});
	});
</script>

<title>Add Role</title>

</head>

<body>
	<div id="popDivShowPaths" style="vertical-align:middle;display:none;width:300px;">
	</div>
	<div style="margin:20px;">
		<div style="width:400px;" class="panel panel-default">
			<div class="panel-heading">添加角色</div>
			<table class="table">
			    <tr>
			    	<td><input type="text" class="form-control" id="name" name="name" placeholder="角色名字"></td>
			  		<td><button type="button" class="btn btn-default"  id="register">添加</button></td>
				</tr>
			</table>
		</div>
		
		<div class="panel panel-default" style="width: 400px;margin-top:10px;">
		 	<!-- Default panel contents -->
		 	<div class="panel-heading">角色列表</div>
		 	  <table class="table" id="rolesTableDiv">
			  </table>
		</div>
	</div>
	<div id="bg" class="bg" style="display: none;">
	</div>
</body>
</html>