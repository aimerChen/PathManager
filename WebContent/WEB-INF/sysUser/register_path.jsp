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
<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	var requestPath="<%=request.getContextPath()%>";
	var allPaths=new Array();//拥有某一个path的所有roles
	
	//删除Path
	function deletePathById(id){
		$.post(requestPath + "/sysUser/deletePathById.shtml",{id:id},function(data) {
			if (data ===1) {
				$("#deletePath_"+id).closest("tr").remove();
			}else{
				alert("删除失败");
			}
		});
	}
	//提交更新了的Path
	function submitEditPathById(id){
		var nameBefore=$("#pathNameLabel_"+id).text().trim();
		var nameAfter=$("#pathEditNameLabel_"+id).val().trim();
		var object =$("#pathLabelTr_"+id);
		var objectEdit =$("#pathEditTr_"+id);
		if(nameBefore!==nameAfter&&nameAfter!=""){
			$.post(requestPath+"/sysUser/updatePathNameById.shtml",{pathid:id,name:nameAfter},function(data){
				if(data===1){
					$("#pathNameLabel_"+id).text(nameAfter);
					$(objectEdit).hide();
					$(object).show();
				}else{
					alert("更新失败");
					return;
				}
			});
		}else{
			$("#pathEditNameLabel_"+id).val(nameBefore);
			$(objectEdit).hide();
			$(object).show();
		}
	}
	
	function changeModel(model,id){
		var object =$("#pathLabelTr_"+id);
		var objectEdit =$("#pathEditTr_"+id);
		var name=$("#pathNameLabel_"+id).text();
		if(model===1){//转换到编辑模式
			$(object).hide();
			$(objectEdit).show();
		}else{//转换到显示模式
			$("#pathEditNameLabel_"+id).val(name);
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
	
	function confirmAddRole(pathid){
		//隐藏弹出层
        $('#popDivShowRoles').hide();
		$("#bg").hide();
		var rolesIdArr=new Array();
		$("#rolesofPathTable_"+pathid).find("input[type='checkbox']").each(function(index,item){
			if($(item).prop("checked")==true){
				var roleid=$(item).attr("id").split("_")[2];
				rolesIdArr.push(roleid);
			}
		});
		var arrStr=rolesIdArr.toString();
		if(pathid>0){
			$.post(requestPath+"/sysUser/updateRolesofPathById.shtml",{pathid:pathid,roles:arrStr},function(data){
				if(data<0){
					alert("更新失败");
				}else{
					alert("更新成功");
				}
			});
		}
		$("#pathLabelTr_"+pathid).show();
		$("#pathEditTr_"+pathid).hide();
	}
	
	function popRolesDiv(id,pathName){
		$("#bg").show();
		//显示弹出层
        center($('#popDivShowRoles'));
      	$('#popDivShowRoles').show();
      	//如果已经下载所有的roles，则添加;否则，先下载roles
		$.post(requestPath + "/sysUser/showAllRoles.shtml",function(data) {
			$.post(requestPath + "/sysUser/showAllPaths.shtml", function(paths) {
				if (paths !== null) {
					var tempStr = eval(paths);
					allPaths.length=0;
					allPaths=tempStr;//缓存到全局变量
				}
				if (data!=null&&data!="") {
					var allRoles=eval(data);
					var pathHtml="<div class='panel panel-default' style='vertical-align:middle;text-align:center;'><div class='panel-heading'><h4>添加角色</h4></div>";
					pathHtml+="<table id='rolesofPathTable_"+id+"' class='table'>";
					pathHtml+="<tr><td style='vertical-align:middle;text-align:center;border-right:1px solid #DDD;' width='10%;' rowspan='"+(allRoles.length+1)+"'>"+pathName+"</td>";
					$.each(allRoles,function(index,role){
						pathHtml+="<tr>";
						var checkedHtml="";
						$.each(allPaths,function(index,path){
							if(path.roles!=null&&path.roles!=""&&path.id==id){
								$.each(path.roles,function(index,innerrole){
									if(role.id===innerrole.id){
										checkedHtml="<td align='left' ><input type='checkbox' id='AddRoleCheckbox_"+id+"_"+role.id+"' style='margin-left:30%;' checked='true' /><label style='font-weight:normal;margin-left:10px;'>"+role.name+"</label></td>";
									}
								});
							}
						});
						if(checkedHtml===""){
							checkedHtml="<td align='left' ><input type='checkbox' id='AddRoleCheckbox_"+id+"_"+role.id+"' style='margin-left:30%;' /><label style='font-weight:normal;margin-left:10px;'>"+role.name+"</label></td>";
						}
						pathHtml+=checkedHtml;
						pathHtml+="</tr>";
					});		
					//添加两个按钮
					pathHtml+="</td></tr>";
					pathHtml+="<tr><td><input type='button' value='取消' class='btn btn-default' onclick='hideRolesDiv("+id+")'/></td><td><input type='button' value='确定' onclick='confirmAddRole("+id+")' class='btn btn-default' style='float:right;'/></td></tr>";
					pathHtml+="</table></div>";
					$("#popDivShowRoles").html(pathHtml);//插入到弹出层
				}
			});
		});
	}
	
	function hideRolesDiv(id){
		//隐藏弹出层
        $('#popDivShowRoles').hide();
		$("#bg").hide();
		changeModel(2,id);
	}
	
	//获取所有的list
	function getPathList(){
		$.post(requestPath + "/sysUser/showAllPaths.shtml", function(data) {
			if (data !== null) {
				var tempStr = eval(data);
				allPaths.length=0;
				allPaths=tempStr;//缓存到全局变量
				addPathIntoTable();
			}
		});
	};
	
	//显示下载下来的path
	function addPathIntoTable(){
		var html="";
		var pathObject;
	    $.each(allPaths, function(index,item){
	    	pathObject=new Object();
	    	pathObject.id=item.id;
			html+="<tr id='pathLabelTr_"+item.id+"'>"
				+"<td width='50%' style='vertical-align:middle;text-align:left;'><label id='pathNameLabel_"+item.id+"'>"+item.name+"</label></td>"
				//+"<td><input id='pathNameLabel_"+item.id+"' type='text' value='"+item.name+"'/></td>"
				+"<td width='30%'  style='vertical-align:middle;text-align:left;'><label  style='font-size:12px;font-weight:normal;' id='pathCreateTimeLabel_"+item.id+"'>"+item.createTime+"</label></td>"
				+"<td width='10%'><input type='button' id='editPath_"+item.id+"' class='btn btn-default' value='编辑' onclick='changeModel(1,"+item.id+")'/></td>"
				+"<td width='10%'><input type='button' id='deletePath_"+item.id+"' class='btn btn-default' onclick='deletePathById("+item.id+")' value='删除'/></td>"
				+"</tr>";
			html+="<tr id='pathEditTr_"+item.id+"' style='display:none;'>"
			+"<td width='50%' style='vertical-align:middle;text-align:left;'><input id='pathEditNameLabel_"+item.id+"' class='form-control' type='text' value='"+item.name+"'/></td>"
			+"<td width='30%'><input type='button' id='submitEditPath_"+item.id+"' class='btn btn-default' onclick='popRolesDiv("+item.id+",\""+item.name+"\")' value='显示权限'/>"
			+"<td width='10%'><input type='button' id='submitEditPath_"+item.id+"' class='btn btn-default' onclick='submitEditPathById("+item.id+")' value='提交'/></td>"
			+"<td width='10%'><input type='button' id='cancelEditPath_"+item.id+"' class='btn btn-default' onclick='changeModel(2,"+item.id+")' value='取消'/></td>"
			+"</tr>";
        });
		$("#pathTable").html(html);
	}
	
	$(document).ready(function(){
		getPathList();
		
		$("#register").click(function() {
			var pathStr = $("#name").val();
			if (pathStr == "") {
				alert("路径不能为空");
				return false;
			}
			$.post(requestPath + "/sysUser/createPath.shtml", {pathStr : pathStr}, function(data) {
				if (data >= 1) {
					$("#name").val("");
					getPathList();
				} else if (data === 0) {
					alert("名字存在，添加失败");
				} else {
					alert("内部错误，添加失败");
				}
			});
			return false;
		});
		
	});
</script>

<title>添加路径</title>

</head>

<body>		
	<div id="popDivShowRoles" style="display:none;width:300px;height:300px;float:center;">
	</div>
	<div style="margin:20px;">
		<div style="width:400px;" class="panel panel-default">
			<div class="panel-heading">添加路径</div>
			<table class="table">
			    <tr>
			    	<td><input type="text" class="form-control" id="name" name="name" placeholder="路径名字"></td>
			  		<td><button type="button" class="btn btn-default"  id="register">添加</button></td>
				</tr>
			</table>
		</div>
		
		<div class="panel panel-default" style="width: 400px;margin-top:10px;">
		 	<!-- Default panel contents -->
		 	<div class="panel-heading">路径列表</div>
			<table id="pathTable" class="table">
			</table>
		</div>
	</div>
	<div id="bg" class="bg" style="display: none;">
	</div>
</body>
</html>