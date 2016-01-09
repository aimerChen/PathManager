package com.chen.springHibernate.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.dao.RoleDao;
import com.chen.springHibernate.service.RoleService;

@Service
@Transactional
public class RoleServiceImpl implements RoleService{

	@Autowired
	private RoleDao roleDao;
	
	@Override
	public boolean create(Role role) {
		Role dbRole=roleDao.findRoleByName(role.getName());
		if(dbRole!=null){
			//角色存在，则更新角色对应的path
			return false;
		}else{//创建角色
			if(roleDao.create(role)==1){//role 创建成功
				return true;
			}else{
				//角色创建不成功
				return false;
			}
		}
	}
	
	@Override
	public Role findRoleByName(String roleName) {
		Role role= roleDao.findRoleByName(roleName);
		if(role!=null){
			role.setPaths(roleDao.findPaths(role.getId()));
		}
		return role;
	}

	@Override
	public Role findRoleById(int roleId) {
		Role role= roleDao.findRoleById(roleId);
		if(role!=null){
			role.setPaths(roleDao.findPaths(roleId));
		}
		return role;
	}

	@Override
	public List<Role> findAllRoles() {
		List<Role> roleList=roleDao.findAllRoles();
		if(roleList!=null){
			for(Role role:roleList){
				role.setPaths(roleDao.findPaths(role.getId()));
			}
		}
		return roleList;
	}

	@Override
	public int update(Role role) {
		int result=0;
		//改名字
		if(!StringUtils.isEmpty(role.getName())){
			result=roleDao.update(role);
		}
		if(role.getPaths()!=null&&role.getPaths().size()>0){
			//删除所有的role
			roleDao.deletePaths(role.getId());
			List<Path> pList=role.getPaths();
			Map<String,Integer> map=new HashMap<>();
			map.put("roleId", role.getId());
			for(Path path:pList){
				map.put("pathId", path.getId());
				//逐个添加role
				roleDao.addPath(map);
			}
		}
		return result;
	}

	
	@Override
	public int delete(int roleId) {
		int result=0;
		if((result=roleDao.delete(roleId))==1){
			roleDao.deletePaths(roleId);
			roleDao.deleteUsers(roleId);
		}
		return result;
	}

	@Override
	public List<Path> findPaths(int roleId) {
		return roleDao.findPaths(roleId);
	}

//	@Override
//	public Path findRolePathById(Map<String, Integer> map) {
//		// TODO Auto-generated method stub
//		return roleDao.findRolePathById(map);
//	}
//
//	@Override
//	public int addPathForRole(Map<String, Integer> map) {
//		return roleDao.addPathForRole(map);
//	}

}
