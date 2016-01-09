package com.chen.springHibernate.dao;

import java.util.List;
import java.util.Map;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;

public interface RoleDao {
	
	/**
	 * 创建一个role，不附带path权限
	 * @param role
	 * @return
	 */
	public int create(Role role);
	
	public Role findRoleByName(String roleName);
	public Role findRoleById(int roleId);
	public List<Role> findAllRoles();
	
	/**
	 * 更新role：删除和添加path的工作交给
	 * {@link #addPath(Map)}
	 * {@link #deletePathsById(int)}
	 * @param role
	 * @return
	 */
	public int update(Role role);
	
	/**
	 * 删除role
	 * @param roleId
	 * @return
	 */
	public int delete(int id);


	
	/**
	 * ====================================================================Path=================================================================
	 */
	
	/**
	 * 给role添加path权限
	 * @param map:两个key：(roleId，pathId)
	 * @return
	 */
	public int addPath(Map<String,Integer> map);
	
	/**
	 * 获取role所有path权限
	 * @param roleId
	 * @return
	 */
	public List<Path> findPaths(int id);
	
	/**
	 * 删除role之后，需要所有path的role也需要删除
	 * @param roleId
	 * @return
	 */
	public int deletePaths(int id);
	
	
	
	/**
	 * ====================================================================User=================================================================
	 */
	/**
	 * 删除role之后，需要所有user的role也需要删除
	 * @param roleId
	 * @return
	 */
	public int deleteUsers(int id);
	
}
