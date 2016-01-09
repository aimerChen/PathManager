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
import com.chen.springHibernate.dao.PathDao;
import com.chen.springHibernate.service.PathService;

@Service
@Transactional
public class PathServiceImpl implements PathService{

	@Autowired
	private PathDao pathDao;

	@Override
	public boolean create(Path path) {
		Path dbPath=pathDao.findPathByName(path.getName());
		boolean created=false;
		if(dbPath!=null){
			//角色存在，则更新角色对应的path
			created=false;
		}else{//创建角色和path
			created=pathDao.create(path)==1;//role 创建成功
		}
		if(created&&path.getRoles()!=null){
			Map<String,Integer> map=new HashMap<String,Integer>();
			map.put("pathId", path.getId());
			for(Role role:path.getRoles()){
				if(role.getId()>=0){
					map.put("roleId", role.getId());
					pathDao.addRole(map);
				}
			}
		}
		return created;
	}
	
	@Override
	public List<Path> findPathsByName(String pathName) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Path> findPathsByLikeName(String pathName) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Path> findAllPaths() {
		// TODO Auto-generated method stub
		List<Path> plist=pathDao.findAllPaths();
		if(plist!=null){
			for(Path path:plist){
				path.setRoles(pathDao.findRoles(path.getId()));
			}
		}
		return plist;
	}

	@Override
	public int updateNameById(Path path) {
		// TODO Auto-generated method stub
		int result=-1;
		//改名字
		if(!StringUtils.isEmpty(path.getName())){
			result=pathDao.update(path);
		}
		return result;
	}

	@Override
	public int updateRolesofPathById(Path path) {
		// TODO Auto-generated method stub
		int result=-1;
		result=pathDao.deleteRoles(path.getId());//可能为0
		if(path.getRoles()!=null&&path.getRoles().size()>0){
			//删除所有的role
			List<Role> rList=path.getRoles();
			Map<String,Integer> map=new HashMap<>();
			map.put("pathId", path.getId());
			for(Role role:rList){
				map.put("roleId", role.getId());
				//逐个添加role
				result=pathDao.addRole(map);
			}
		}
		return result;
	}
	
	@Override
	public int delete(int id) {
		// TODO Auto-generated method stub
		int result=0;
		if((result=pathDao.delete(id))==1){
			pathDao.deleteRoles(id);
		}
		return result;
	}

	@Override
	public List<Role> findRoles(int pathId) {
		return pathDao.findRoles(pathId);
	}
//	
//	@Override
//	public int addRoleForPath(Map<String, Integer> map) {
//		return pathDao.addRoleForRole(map);
//	}

}
