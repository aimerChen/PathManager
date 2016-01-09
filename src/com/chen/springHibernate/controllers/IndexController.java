package com.chen.springHibernate.controllers;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class IndexController {
	@RequestMapping(value="/index", method = RequestMethod.GET)
	public String index(){
		Session session = SecurityUtils.getSubject().getSession();
		System.out.println("login sessionID:"+session.getId());
		// 登陆的信息回传页面
		return "index";
	}
}
