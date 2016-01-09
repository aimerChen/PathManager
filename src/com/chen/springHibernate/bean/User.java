package com.chen.springHibernate.bean;

import java.io.Serializable;
import java.util.List;

public class User implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	private int id;
	private String name="";
	private String password="";
	private String birthday="";
	private int locked=0;//0:没有锁定；1：锁定
	private String salt="";
	private List<Role> roles;
	private String createTime;
	
	public String getSalt() {
		return salt;
	}
	public void setSalt(String salt) {
		this.salt = salt;
	}
	public int getLocked() {
		return locked;
	}
	public void setLocked(int locked) {
		this.locked = locked;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getBirthday() {
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	public String getCreateTime() {
		return createTime;
	}
//	public void setCreateTime(String createTime) {
//		this.createTime = createTime;
//	}
	
	public List<Role> getRoles() {
		return roles;
	}
	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}
	
	public int getMaxPriority(){
		
		return 0;
	}
	
	@Override
	public String toString(){
		StringBuilder sp=new StringBuilder();
		sp.append("name=").append(name).append(",password=").append(password);
		return sp.toString();
	}
	
}
