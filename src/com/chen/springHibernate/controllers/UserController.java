package com.chen.springHibernate.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.ExcessiveAttemptsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.SecureRandomNumberGenerator;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.chen.springHibernate.bean.User;
import com.chen.springHibernate.service.UserService;

@Controller
@Scope("prototype")
@RequestMapping(value = "/user")
public class UserController {

	@Autowired
	private UserService mUserService;

	@RequestMapping(value = "register", method = RequestMethod.GET)
	public String register() {
		Subject currentUser = SecurityUtils.getSubject();
		System.out.println("register sessionID get:"+currentUser.getSession().getId());
		return "/register";
	}

	@RequestMapping(value = "register", method = RequestMethod.POST)
	@ResponseBody
	public String registerUser(@ModelAttribute User user, HttpServletRequest request) {
		// 和shiro.xml中配置一致
		String salt = new SecureRandomNumberGenerator().nextBytes().toHex();// 生成盐
		SimpleHash hash = new SimpleHash(Md5Hash.ALGORITHM_NAME, user.getPassword(), salt, 2);
		user.setPassword(hash.toHex());
		user.setSalt(salt);
		if (mUserService.create(user)) {
			System.out.println("注册成功");
			return "success";
		} else {
			return "fail";
		}
	}

	@RequestMapping(value = "login", method = RequestMethod.GET)
	public String login(HttpServletRequest request, HttpServletResponse response) throws IOException {
		request.removeAttribute("error");
		Session session = SecurityUtils.getSubject().getSession();
		System.out.println("login sessionID get:"+session.getId());
		return "/login";
	}

	@RequestMapping(value = "login", method = RequestMethod.POST)
	@ResponseBody
	public String login(String username, String password, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		System.out.println("login sessionID post:"+request.getSession().getId());
		try {
			Subject currentUser = SecurityUtils.getSubject();
			UsernamePasswordToken token = new UsernamePasswordToken(username, password);
			try {
				currentUser.login(token);
			} catch (LockedAccountException lae) {
				token.clear();
				return "用户已经被锁定不能登录，请与管理员联系！";
			} catch (ExcessiveAttemptsException e) {
				token.clear();
				return "登录失败次数过多,锁定10分钟!";
			} catch (AuthenticationException e) {
				token.clear();
				return "用户或密码不正确！";
			}
			// 但是，“已记住”和“已认证”是有区别的：
			// 已记住的用户仅仅是非匿名用户，你可以通过subject.getPrincipals()获取用户信息。但是它并非是完全认证通过的用户，当你访问需要认证用户的功能时，你仍然需要重新提交认证信息。
			System.out.println(request.getSession().getId());
			request.removeAttribute("error");
		} catch (Exception e) {
			e.printStackTrace();
			return "登录异常，请联系管理员";
		}
		return "success";
	}
	
	@RequestMapping(value="logout", method = RequestMethod.POST)
	@ResponseBody
	public String logout(){
		Subject currentUser = SecurityUtils.getSubject();
		if(currentUser!=null){
			currentUser.logout();
		}
		return "success";
	}
	
	@RequestMapping(value="home")
	public String home(){
		return "/home";
	}
	
	@RequestMapping(value="denied")
	public String denied(){
		return "/denied";
	}
	
	@RequestMapping(value="ever")
	public String ever(){
		return "/ever";
	}
	
	@RequestMapping(value="/kickout", method = RequestMethod.GET)
	public String index(){
		Session session = SecurityUtils.getSubject().getSession();
		System.out.println("kickout sessionID:"+session.getId());
		// 登陆的信息回传页面
		return "/denied";
	}
}
