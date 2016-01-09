package com.chen.springHibernate.shiro.credentials;

import java.util.ArrayList;
import java.util.List;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.chen.springHibernate.bean.Role;
import com.chen.springHibernate.bean.User;
import com.chen.springHibernate.service.RoleService;
import com.chen.springHibernate.service.UserService;
import com.google.gson.Gson;

/**
 * doGetAuthenticationInfo:认证用户，即是否存在该用户<br/>
 * doGetAuthorizationInfo:授权用户，即满足条件的用户可以得到授权<br/>
 * @author Administrator
 *
 */
@Service("MyRealm")
public class MyRealm extends AuthorizingRealm {

	@Autowired
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	/**
	 * 为当前登录的Subject授予角色和权限
	 * 
	 * @see 经测试:本例中该方法的调用时机为需授权资源被访问时
	 * @see 经测试:并且每次访问需授权资源时都会执行该方法中的逻辑,这表明本例中默认并未启用AuthorizationCache
	 * @see 个人感觉若使用了Spring3.1开始提供的ConcurrentMapCache支持,
	 *      则可灵活决定是否启用AuthorizationCache
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		String currentUsername = (String) super.getAvailablePrincipal(principals);
		List<String> roleList = new ArrayList<String>();
		User user=userService.findUserByName(currentUsername);
		if (null != user) {
			if (null != user.getRoles() && user.getRoles().size() > 0) {
				List<Role> roles=user.getRoles();
				for (Role role : roles) {
					roleList.add(role.getName());
				}
			}
		}			
		// 为当前用户设置角色和权限
		SimpleAuthorizationInfo simpleAuthorInfo = new SimpleAuthorizationInfo();
		simpleAuthorInfo.addRoles(roleList);
		
		if (null != currentUsername && "chen".equals(currentUsername)) {
			simpleAuthorInfo.addRole("sysUser");
//			simpleAuthorInfo.addStringPermission("sysUser:manage");
			System.out.println("已为用户[chen]赋予了[sysUser]角色和[sysUser:manage]权限");
//			给系统管理员添加所有角色
			List<Role> allRoles=roleService.findAllRoles();
			if (null != allRoles && allRoles.size() > 0) {
				for (Role role : allRoles) {
					simpleAuthorInfo.addRole(role.getName());
				}
			}
		}
		return simpleAuthorInfo;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		/* 这里编写登陆认证代码 */
		String username = (String) token.getPrincipal();
		User user = userService.findUserByName(username);
		System.out.println("gson:" + new Gson().toJson(user));
		if (null!=user) {
			if (1==user.getLocked()) {
				throw new LockedAccountException(); // 帐号锁定
			}
			// 从数据库查询出来的账号名和密码,与用户输入的账号和密码对比
			// 当用户执行登录时,在方法处理上要实现user.login(token);
			// 然后会自动进入这个类进行认证
			// 交给AuthenticatingRealm使用CredentialsMatcher进行密码匹配，如果觉得人家的不好可以自定义实现

			SimpleAuthenticationInfo authenticationInfo = 
					new SimpleAuthenticationInfo(username,user.getPassword(), getName()); // realm name
			authenticationInfo.setCredentialsSalt(ByteSource.Util.bytes(user.getSalt())); // salt=username+salt
			// 当验证都通过后，把用户信息放在session里
			return authenticationInfo;
		} else {
			throw new UnknownAccountException();// 没找到帐号
		}
	}

}
