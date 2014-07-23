package example;

import redis.clients.jedis.Jedis;


public class JedisDemo {

	public static void main(String[] args) {

		Jedis jedis=new Jedis("10.10.10.150", 6379);
		jedis.set("ip3", "www.google.com.hk");
		System.out.println( jedis.get("ip3"));
	}
}
