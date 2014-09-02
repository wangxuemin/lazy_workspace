package xiaoju.platform.storm.examples;

import java.util.HashMap;
import java.util.Map;

import backtype.storm.task.TopologyContext;
import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Tuple;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import redis.clients.jedis.Jedis;

public class WordCounter extends BaseBasicBolt {

	private static final long serialVersionUID = 5678586644899822142L;
	Integer id;
	String name;

	Connection conn;
	Jedis jedis;
	Statement statement;
	@Override
	public void cleanup() {
	    try {
		if( conn != null )
		    conn.close();
	    } catch (Exception e) {
		e.printStackTrace();
	    }
	}

	@Override
	public void prepare(Map stormConf, TopologyContext context) {
		this.name = context.getThisComponentId();
		this.id = context.getThisTaskId();
		String driver="com.mysql.jdbc.Driver";
		String url="jdbc:mysql://hdp998.jx:3377/data?autoReconnect=true&failOverReadOnly=false";
		String user="data_w";
		String pass="data_w";
		try{
		    Class.forName(driver);
		    conn=DriverManager.getConnection(url,user,pass);

		    if(conn.isClosed())
			throw new Exception("Mysql getConnection ERROR!");
		}catch( Exception e)
		{
		    e.printStackTrace();
		}
		jedis=new Jedis("10.10.10.150", 6379);
	}

	public void declareOutputFields(OutputFieldsDeclarer declarer) {
	}

	public void execute(Tuple input, BasicOutputCollector collector) {

//	    jedis.set("ip", "www.google.com.hk");
	    for( int i =0; i<3;i++ ){
		try {
		    String str = new String( input.getBinary(0),"UTF-8");
		    String sql=String.format("insert into storm_bolt_ret (str) values ('%s')", str+"!");

		statement=conn.createStatement();
		statement.execute(sql);
		statement.close();
	    } catch (Exception e) {
		e.printStackTrace();
		continue;
	    }
	    break;
	    }

	}
}
