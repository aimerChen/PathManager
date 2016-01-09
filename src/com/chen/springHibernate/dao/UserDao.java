package com.chen.springHibernate.dao;

import java.util.List;
import java.util.Map;

import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.bean.User;

public interface UserDao {
	
	/**
	 * 只创建用户
	 * @param user
	 * @return
	 */
	public int create(User user);
	
	public User findUserByName(String userName);
	/**
	 * 根据输入的字符搜索
	 * @param name
	 * @return
	 */
	public List<User> findUsersByLikeName(String name);

	public List<User> findAllUsers();
	
	/**
	 *	更新用户，更新其对应的角色 
	 * @param user
	 * @return
	 */
	public int update(User user);
	
	/**
	 * 删除用户
	 * @param userId
	 * @return
	 */
	public int delete(int userId);
	
	/**
	 * ====================================================================Role==========================================================================
	 */
	
	/**
	 * 添加一个角色
	 * @param map
	 * @return
	 */
	public int addRole(Map<String,Integer> map);
	
	/**
	 * 
	 * @param userId
	 * @return
	 */
	public List<Role> findRoles(int userId);

	/**
	 * 删除用户对应的所有role记录
	 * @param userId
	 * @return
	 */
	public int deleteRoles(int userId);

}
