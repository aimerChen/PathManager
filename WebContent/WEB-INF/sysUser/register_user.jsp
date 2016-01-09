<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/bootstrap.css"/>
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
	var mAllUser=new Array();
	
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
	
	//显示一个user所用的role
	function showPathsDiv(userid,username){
    	
    	//所有的角色
   		$.post(requestPath+"/sysUser/showAllRoles.shtml",function(data){
   			if (data !== null&&data!="") {
				var tempStr = eval(data);
   				$.post(requestPath + "/sysUser/findAllUsers.shtml", function(allUser) {
   	   				var rolesHtml="<div class='panel panel-default' style='width: 400px;margin-top:10px;'><div class='panel-heading' style='vertical-align:middle;text-align:center;'>角色列表</div>"
   	   				rolesHtml+="<table class='table' id='rolesofUserTable_"+userid+"'>";
   	   				rolesHtml+="<tr><td rowspan='"+(tempStr.length+1)+"' style='vertical-align:middle;text-align:center;border-right:1px solid #DDD'>"+username+"</td></tr>"
					$.each(tempStr, function(ind,item){
   	   		    		var checkedRoll="";
   	   		    		if(allUser!=null&&allUser.length>0){
   	   		    			allUserStr=eval(allUser);
   	   		   				$.each(allUserStr,function(index,user){
   	   		   					if(user.roles!=null&&user.roles!=""&&user.id===userid){
   	   		   	   					$.each(user.roles,function(index,userrole){
   	   		   							if(item.id===userrole.id){
   	   		   								checkedRoll="<tr><td style='vertical-align:middle;text-align:left;padding-left:40px;'>";
   	   		   								checkedRoll+="<input type='checkbox' class='checkboxPathClass' checked='true' style='margin:auto;' id='roleCheckBox_"+item.id+"'/>"
   	   		   								checkedRoll+="<label id='roleNameLabel_"+item.id+"' style='margin-left:10px;padding:0px;'>"+item.name+"</label></td></tr>";
   	   		   							}
   	   		   						});
   	   		   					}
   	   		   				});
   	   		    		}
   	   		    		if(checkedRoll==""){
   							checkedRoll="<tr><td style='vertical-align:middle;text-align:left;padding-left:40px;'><input type='checkbox' class='checkboxPathClass' style='margin:auto;' id='roleCheckBox_"+item.id+"'/>"
   								+"<label id='roleNameLabel_"+item.id+"' style='margin-left:10px;padding:0px;'>"+item.name+"</label></td></tr>";
   	   		    		}
   	   			    	rolesHtml+=checkedRoll;
   	   		        });  
   	   				rolesHtml+="<tr><td><input type='button' value='取消' onclick='hidePathsDiv("+userid+")' class='btn btn-default'/></td><td><input type='button' value='确定' onclick='confirmAddRole("+userid+")' class='btn btn-default' style='float:right'/></td></tr>"
   	   				rolesHtml+="</table></div><div style='clear:both;'></div>";
   	   				$("#popDivShowRoles").html(rolesHtml);

   	   				//显示弹出层
   	   				$("#bg").show();
   	   				center($("#popDivShowRoles"));
   	   		        $("#popDivShowRoles").show();
   				});
   			}
   		});
	}
	
	function hidePathsDiv(userid){
		//隐藏弹出层
		$("#bg").hide();
        $("#popDivShowRoles").hide();
        $("#rolesofUserTable_").hide();
	}
	
	function confirmAddRole(userid){
		//隐藏弹出层
        $('#popDivShowRoles').hide();
		$("#bg").hide();
		var rolesIdArr=new Array();
		$("#rolesofUserTable_"+userid).find("input[type='checkbox']").each(function(index,item){
			if($(item).prop("checked")==true){
				var roleid=$(item).attr("id").split("_")[1];
				rolesIdArr.push(roleid);
			}
		});
		var arrStr=rolesIdArr.toString();
		if(userid>0){
 			$.post(requestPath+"/sysUser/updateRolesofUserById.shtml",{userid:userid,roles:arrStr},function(data){
				if(data<0){
					alert("更新失败");
				}else{
					alert("更新成功");
				}
			}); 
		}
	}
	
	//获取所有的User
	function getAllUsers(){
		$.post(requestPath + "/sysUser/findAllUsers.shtml", function(data) {
			if (data !== null) {
				var tempStr = eval(data);
				var html="";
				mAllUser=tempStr;
			    $.each(tempStr, function(index,item){
			    	console.log(item);
					html+="<tr id='userLabelTr_"+item.id+"'>"
						+"<td width='50%'><label style='vertical-align:middle;text-align:left;' id='userNameLabel_"+item.id+"'>"+item.name+"</label></td>"
						+"<td width='50%'><input type='button' id='submitEditUser_"+item.id+"' class='btn btn-default' onclick='showPathsDiv("+item.id+",\""+item.name+"\")' value='显示角色'/></td>"
						+"</tr>";
		        });
				$("#userListTable").html(html);//插入到页面显示
			}
		});
	}
	
	$(document).ready(function(){
		getAllUsers();
	});
</script>

<title>给用户添加角色</title>

</head>

<body>
	<div id="popDivShowRoles" style="display:none;width:300px;">
	</div>
	
	<div style="margin:20px;">
		<div class="panel panel-default" style="width: 300px;margin-top:10px;">
		 	<!-- Default panel contents -->
		 	<div class="panel-heading">用户列表</div>
		 	  <table class="table" id="userListTable">
			  </table>
		</div>
	</div>
	<div style="display:none;" id="bg" class="bg">

	</div>
</body>
</html>