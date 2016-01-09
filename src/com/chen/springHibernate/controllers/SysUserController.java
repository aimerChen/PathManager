package com.chen.springHibernate.controllers;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.bean.User;
import com.chen.springHibernate.service.PathService;
import com.chen.springHibernate.service.RoleService;
import com.chen.springHibernate.service.UserService;
import com.chen.springHibernate.util.Utils;
import com.google.gson.Gson;

@Controller
@Scope("prototype")
@RequestMapping(value = "/sysUser")
public class SysUserController {

	@Autowired
	private RoleService mRoleService;
	
	@Autowired
	private UserService mUserService;
	
	@Autowired
	private PathService mPathService;
	
	@RequestMapping(value="createRole", method = RequestMethod.GET)
	public String showRole(){
		return "/sysUser/register_role";
	}

	/**
	 * 
	 * @param name
	 * @param path
	 * @return
	 * <p>-1:表示没接收到某些字段
	 * <p>0:表示已经占用
	 * <p>1:创建成功
	 * <p>2：系统预留角色，不能被创建
	 */
	@RequestMapping(value="createRole", method = RequestMethod.POST)
	@ResponseBody
	public int createRole(@RequestParam String name){
		System.out.println("role name:"+name);
		//1.先判断路径不为空
		if(name!=null){
			if(name.equalsIgnoreCase(Utils.DEFAULT_SYSUSER)){
				return 2;
			}
			Role role=new Role();
			role.setName(name);
			//创建角色：如果角色已经存在，则不再创建；
			if(mRoleService.create(role)){
				return 1;
			}else{
				return 0;
			}
		}
		return -1;
	}

	/**
	 * 检查角色是否能被创建
	 * @return
	 * <p>1:能被创建
	 * <p>0:不能被创建
	 */
	@RequestMapping(value="checkRole", method = RequestMethod.POST)
	@ResponseBody
	public int checkRole(){
		return 1;
	}
	
	@RequestMapping(value="findPathsofRole", method = RequestMethod.POST)
	@ResponseBody
	public String findPathsofRole(@RequestParam int id){
		return new Gson().toJson(mRoleService.findPaths(id));
	}
	
	
	/**
	 * 返回所有的角色
	 * @return
	 */
	@RequestMapping(value="showAllRoles", method = RequestMethod.POST)
	@ResponseBody
	public String showAllRoles(){
		return new Gson().toJson(mRoleService.findAllRoles());
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value="deleteRoleById", method = RequestMethod.POST)
	@ResponseBody
	public int deleteRoleById(@RequestParam int id){
		return mRoleService.delete(id);
	}
	
	/**
	 * 
	 * @param path
	 * @return
	 */
	@RequestMapping(value="updateRoleById", method = RequestMethod.POST)
	@ResponseBody
	public int updateRoleById(@ModelAttribute Role role){
		return mRoleService.update(role);
	}

	/**
	 * 返回path jsp页面
	 * @param name
	 * @return
	 */
	@RequestMapping(value="createPath", method = RequestMethod.GET)
	public String showPath(){
		return "/sysUser/register_path";
	}
	
	/**
	 * 
	 * @param name
	 * @return <p>返回添加path的个数
	 */
	@RequestMapping(value="createPath", method = RequestMethod.POST)
	@ResponseBody
	public int createPath(@RequestParam String pathStr){
		int result=0;
		if(pathStr!=null){
			String[] pathArr=pathStr.split(";");
			Path path=null;
			for(int i=0;i<pathArr.length;i++){
				path=new Path();
				path.setName(pathArr[i]);
				if(mPathService.create(path)){
					result++;
				}
			}
		}
		return result;
	}
	
	/**
	 * 
	 * @param name
	 * @return <p>返回添加path的个数
	 */
	@RequestMapping(value="showAllPaths", method = RequestMethod.POST)
	@ResponseBody
	public String showAllPaths(){
		return new Gson().toJson(mPathService.findAllPaths());
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value="deletePathById", method = RequestMethod.POST)
	@ResponseBody
	public int deletePathById(@RequestParam int id){
		return mPathService.delete(id);
	}
	
	/**
	 * 
	 * @param path
	 * @return
	 */
	@RequestMapping(value="updatePathNameById", method = RequestMethod.POST)
	@ResponseBody
	public int updatePathNameById(@RequestParam int pathid,@RequestParam String name){
		Path path=null;
		int result=-1;
		if(pathid>=0){
			path=new Path();
			path.setId(pathid);
			if(name!=null&&name.length()>0){
				path.setName(name);
				result= mPathService.updateNameById(path);
			}
		}
		return result;
	}
	
	/**
	 * 
	 * @param path
	 * @return
	 */
	@RequestMapping(value="updateRolesofPathById", method = RequestMethod.POST)
	@ResponseBody
	public int updateRolesofPathById(@RequestParam int pathid,@RequestParam String roles){
		int result=-1;
		Path path=null;
		if(pathid>=0){
			path=new Path();
			path.setId(pathid);
			if(!StringUtils.isEmpty(roles)){
				List<Role> rList=new ArrayList<>();
				Role role=null;
				String[] rolesArr=roles.split(",");
				for(int i=0;i<rolesArr.length;i++){
					role=new Role();
					role.setId(Integer.parseInt(rolesArr[i]));
					rList.add(role);
				}
				path.setRoles(rList);
			}
			result= mPathService.updateRolesofPathById(path);
		}
		return result;
	}
	
	/**
	 * 返回所有的用户
	 * @return
	 */
	@RequestMapping(value="createUser", method = RequestMethod.GET)
	public String showUser(){
		return "/sysUser/register_user";
	}
	
	/**
	 * 返回所有的用户
	 * @return
	 */
	@RequestMapping(value="findAllUsers", method = RequestMethod.POST)
	@ResponseBody
	public String findAllUsers(){
		return new Gson().toJson(mUserService.findAllUsers());
	}
	
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value="deleteUserById", method = RequestMethod.POST)
	@ResponseBody
	public int deleteUserById(@RequestParam int id){
		return mUserService.delete(id)?1:0;
	}
	
	/**
	 * 
	 * @param path
	 * @return
	 */
	@RequestMapping(value="updateUserNameById", method = RequestMethod.POST)
	@ResponseBody
	public int updateUserNameById(@RequestParam int userId,@RequestParam String name){
		User user=null;
		if(userId>=0){
			user=new User();
			user.setId(userId);
			if(name!=null&&name.length()>0){
				user.setName(name);
			}
			return mUserService.updateNameById(user);
		}else{
			return -1;
		}
	}
	/**
	 * 
	 * @param path
	 * @return
	 */
	@RequestMapping(value="updateRolesofUserById", method = RequestMethod.POST)
	@ResponseBody
	public int updateRolesofUserById(@RequestParam int userid,@RequestParam String roles){
		int result=-1;
		User user=null;
		if(userid>=0){
			user=new User();
			user.setId(userid);
			if(!StringUtils.isEmpty(roles)){
				List<Role> rList=new ArrayList<>();
				Role role=null;
				String[] rolesArr=roles.split(",");
				for(int i=0;i<rolesArr.length;i++){
					role=new Role();
					role.setId(Integer.parseInt(rolesArr[i]));
					rList.add(role);
				}
				user.setRoles(rList);
			}
			result= mUserService.updateRolesofUserById(user);
		}
		return result;
	}
	

}
