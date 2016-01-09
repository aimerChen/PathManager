package com.chen.springHibernate.service;

import java.util.List;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;

public interface RoleService {
	/**
	 * 注册一个角色：只在表role中创建一条记录
	 * @param role
	 * @return
	 */
	public boolean create(Role role);
	public Role findRoleByName(String roleName);
	public Role findRoleById(int roleId);
	public List<Role> findAllRoles();
	
	/**
	 * 更新role所在表，更新附带的path
	 * @param role
	 * @return
	 */
	public int update(Role role);
	
	/**
	 * 删除一个Role，附带删除role所拥有的path
	 * @param roleId
	 * @return
	 */
	public int delete(int roleId);
	
	/**
	 * ====================================================================Path==========================================================================
	 */
	
	/**
	 * 查看该角色所有的path权限
	 * @param map
	 * @return
	 */
	public List<Path> findPaths(int roleId);
//	
//	/**
//	 * 为role附加一个path权限
//	 * @param map
//	 * @return
//	 */
//	public int addPathForRole(Map<String,Integer> map);
}
