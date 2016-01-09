package com.chen.springHibernate.shiro.filter;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.web.filter.PathMatchingFilter;


public class SysUserFilter extends PathMatchingFilter {


    @Override
    protected boolean onPreHandle(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {

        String username = (String)SecurityUtils.getSubject().getPrincipal();
        return true;
    }
    
    @Override
    protected void postHandle(ServletRequest request, ServletResponse response) throws Exception{

//        System.out.println(":postHandle");
    } 
    
    @Override
	public void afterCompletion(ServletRequest request, ServletResponse response, Exception exception) throws Exception{

//        System.out.println(":afterCompletion");
    	
    }
}