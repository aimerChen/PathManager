package com.chen.springHibernate.dao;

import java.util.List;
import java.util.Map;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;

public interface PathDao {
	/**
	 * 创建path，并授予一些角色
	 * @param path
	 * @return
	 */
	public int create(Path path);

	public Path findPathByName(String pathName);
	public List<Path> findPathsByLikeName(String pathName);
	public List<Path> findAllPaths();
	/**
	 * 只更新path，不更新连带的roles
	 * @param path
	 * @return
	 */
	public int update(Path path);
	/**
	 * 删除path，不删除连带的roles
	 * @param id
	 * @return
	 */
	public int delete(int id);
	
	/**
	 * ======================================================================Role====================================================================
	 */
	
	/**
	 * 给path添加role
	 * @param map:两个key：roleId和pathId
	 * @return
	 */
	public int addRole(Map<String,Integer> map);
	
	/**
	 * 获取path对应的role
	 * @param pathId
	 * @return
	 */
	public List<Role> findRoles(int pathId);
	

	/**
	 * 删除rolepath表中path对应的所有role 
	 * @param id
	 * @return
	 */
	public int deleteRoles(int id);
}
