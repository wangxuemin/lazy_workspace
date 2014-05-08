package com.diditaxi.monitor.mail;

/**
 * @author haitao.feng
 * @Description 
 * @date 2013-11-28 обнГ08:40:06
 */
import javax.mail.*;

public class MyAuthenticator extends Authenticator {
	String userName = null;
	String password = null;

	public MyAuthenticator() {
	}

	public MyAuthenticator(String username, String password) {
		this.userName = username;
		this.password = password;
	}

	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(userName, password);
	}
}