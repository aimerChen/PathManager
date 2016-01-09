package com.chen.springHibernate.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
	
	/**
	 * 字符串转换为日期
	 * @param strDate
	 * @param mask
	 * @return
	 */
	public static Date convert2Date(String strDate, String mask) {
		SimpleDateFormat sdf = new SimpleDateFormat(mask);
		try {
			return sdf.parse(strDate);
		} catch (ParseException e) {
			
		}finally{
			
		}
		return null;
	}
	
	public static String refFormatate(Date nowTime) {
		  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		  return sdf.format(nowTime);
	}
}
