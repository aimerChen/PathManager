package com.chen.springHibernate.service;

import java.util.List;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;

public interface PathService {
	/**
	 * 创建path，并授予一些角色
	 * @param path
	 * @return
	 */
	public boolean create(Path path);
	
	public List<Path> findAllPaths();
	public List<Path> findPathsByName(String pathName);
	public List<Path> findPathsByLikeName(String pathName);
	
	/**
	 * 只更新path
	 * @param path
	 * @return
	 */
	public int updateNameById(Path path);
	public int updateRolesofPathById(Path path);
	
	/**
	 * 删除path和连带的roles
	 * @param id
	 * @return
	 */
	public int delete(int id);


//	/**
//	 * 为path添加role
//	 * @param map
//	 * @return
//	 */
//	public int addRole(Map<String,Integer> map);
//	
	/**
	 * 获取path对应的role
	 * @param pathId
	 * @return
	 */
	public List<Role> findRoles(int pathId);
	

}
