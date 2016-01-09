package com.chen.springHibernate.shiro;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.config.Ini;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.annotation.Autowired;

import com.chen.springHibernate.bean.Path;
import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.service.PathService;
import com.google.gson.Gson;

/**
 * 产生责任链，确定每个url的访问权限
 * 
 */
public class ChainDefinitionSectionMetaSource implements FactoryBean<Ini.Section> {

	// 静态资源访问权限
	private String filterChainDefinitions = null;
	
	@Autowired
	private PathService mPathService;
	
	private String convertListToString(List<Role> rList){
		StringBuilder sb=new StringBuilder();
		for(Role role:rList){
			if(!StringUtils.isEmpty(role.getName())){
				sb.append(role.getName()).append(",");
			}
		}
		if(sb.length()>0){
			//删除最后一个逗号
			sb.deleteCharAt(sb.length()-1);
		}
		return sb.toString();
	}
	
	/**
	 * 从数据库读取Path和Role的关系：path只能允许什么样的role访问
	 */
	public Ini.Section getObject() throws Exception {
		Ini ini = new Ini();
		// 加载默认的url
		ini.load(filterChainDefinitions);
		Ini.Section section = ini.getSection(Ini.DEFAULT_SECTION_NAME);
		// 循环Resource的url,逐个添加到section中。section就是filterChainDefinitionMap,
		// 里面的键就是链接URL,值就是存在什么条件才能访问该链接
		List<Path> pList=mPathService.findAllPaths();
		String roles="";
		for(Path path:pList){
			roles=convertListToString(mPathService.findRoles(path.getId()));
			if(!StringUtils.isEmpty(roles)){
				section.put(path.getName(),"roles["+roles+"]");
			}
		}
		section.put("/**","authc,kickout,sysUser,user");
		System.out.println("section："+new Gson().toJson(section));
		return section;
	}

	/**
	 * 通过filterChainDefinitions对默认的url过滤定义
	 * 
	 * @param filterChainDefinitions
	 *            默认的url过滤定义
	 */
	public void setFilterChainDefinitions(String filterChainDefinitions) {
		this.filterChainDefinitions = filterChainDefinitions;
	}

	public Class<?> getObjectType() {
		return this.getClass();
	}

	public boolean isSingleton() {
		return false;
	}
}
