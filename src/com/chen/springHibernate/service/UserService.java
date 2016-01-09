package com.chen.springHibernate.service;

import java.util.List;

import com.chen.springHibernate.bean.User;

public interface UserService {
	/**
	 * 只创建用户
	 * @param user
	 * @return
	 */
	public boolean create(User user);
	public User findUserByName(String name);
	public List<User> findUsersByLikeName(String name);
	public List<User> findAllUsers();
	public boolean delete(int userId);
	public int updateNameById(User user);
	public int updateRolesofUserById(User user);
}
