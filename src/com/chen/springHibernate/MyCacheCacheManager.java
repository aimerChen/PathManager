package com.chen.springHibernate;

import java.util.Collection;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;

public class MyCacheCacheManager implements CacheManager {

	private CacheManager cacheManager;

	/**
	 * 设置spring cache manager
	 *
	 * @param cacheManager
	 */
	public void setCacheManager(org.springframework.cache.CacheManager cacheManager) {
		this.cacheManager = cacheManager;
	}

	@Override
	public Cache getCache(String name) {
		Cache springCache = cacheManager.getCache(name);
		System.out.println("走cache:"+springCache.getName());
		return springCache;
	}

	@Override
	public Collection<String> getCacheNames() {
		// TODO Auto-generated method stub
		return cacheManager.getCacheNames();
	}

}
