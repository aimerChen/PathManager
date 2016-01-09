package com.chen.springHibernate.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.dao.PathDao;

@Repository
public class PathImpl implements PathDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
	public int create(Path path) {
		return sqlSessionTemplate.insert("savePath", path);
	}
	
	@Override
	public Path findPathByName(String pathName) {
		return sqlSessionTemplate.selectOne("queryPathByName", pathName);
	}

	@Override
	public List<Path> findPathsByLikeName(String pathName) {
		return sqlSessionTemplate.selectList("queryPathsByLikeName", pathName);
	}


	@Override
	public List<Path> findAllPaths() {
		return sqlSessionTemplate.selectList("findAllPaths");
	}

	@Override
	public int update(Path path) {
		return sqlSessionTemplate.update("updatePath", path);
	}

	@Override
	public int delete(int id) {
		return sqlSessionTemplate.delete("deletePathById", id);
	}
	
	/**
	 * ======================================================================Role====================================================================
	 */
	
	@Override
	public int addRole(Map<String,Integer> map) {
		return sqlSessionTemplate.insert("addRoleForPath", map);
	}

	@Override
	public List<Role> findRoles(int pathId) {
		return sqlSessionTemplate.selectList("findRolesofPathById",pathId);
	}

	@Override
	public int deleteRoles(int id) {
		return sqlSessionTemplate.delete("deletePathRolesById", id);
	}

}
