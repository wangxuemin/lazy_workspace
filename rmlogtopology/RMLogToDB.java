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
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.io.ByteArrayInputStream;
import java.io.ObjectInputStream;

public class RMLogToDB extends BaseBasicBolt {

    String jobid=new String();
    String flg=new String();
    String table;
    private HashMap<String,String> jobinfo=new HashMap<String,String>();
    private HashMap<String,Boolean> mysql_cache=new HashMap<String,Boolean>();

    Connection conn;
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
            //this.name = context.getThisComponentId();
            //this.id = context.getThisTaskId();
            table = "job_audit";
            String driver="com.mysql.jdbc.Driver";
            String url="jdbc:mysql://hdp801.qq:3306/monitor?autoReconnect=true&failOverReadOnly=false";
            String user="root";
            String pass="123456";
            try{
                Class.forName(driver);
                conn=DriverManager.getConnection(url,user,pass);

                if(conn.isClosed())
                    throw new Exception("Mysql getConnection ERROR!");
            }catch( Exception e)
            {
                e.printStackTrace();
            }
        }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
    }

    public void execute(Tuple input, BasicOutputCollector collector) {

        try{
            jobid=new String(input.getBinary(0),"UTF-8");
            flg=new String(input.getBinary(1),"UTF-8");
            ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream( input.getBinary(2) );   
            ObjectInputStream objectInputStream = new ObjectInputStream(byteArrayInputStream);
            jobinfo=(HashMap<String,String>) objectInputStream.readObject();

            updateDB();
        }catch(Exception e)
        {
            e.printStackTrace();
        }


    }

    public void updateDB()
    {
        String sql=null,select_sql=null;
        Boolean exist=true;

        for( int i =0; i<3;i++ ){
        	try {
                if( mysql_cache.get( jobid ) == null )
                {
                    select_sql = String.format("SELECT ugi FROM "+ table +" WHERE jobid='%s'", jobid);
                    PreparedStatement ps=conn.prepareStatement(select_sql);
                    ResultSet rs = ps.executeQuery();
                    exist=rs.next();
                }

                if( "submit".equals(flg) )
                {
                    String jobname=jobinfo.get("jobname");

                    String logger_time=jobinfo.get("time");
                    String ugi=jobinfo.get("ugi");
                    String host=jobinfo.get("host");
//String result=jobinfo.get("result");

                    if( exist )
                    {    
                        sql=String.format("UPDATE "+ table +" SET logger_time='%s', host='%s',jobname=\"%s\" WHERE jobid='%s'",
                            logger_time,host,jobname,jobid);
                    }else
                    {
                        sql=String.format("INSERT INTO "+ table +" (progress,ugi,logger_time,host,jobid,jobname) VALUES ('%s','%s','%s','%s','%s',\"%s\")", 
                            "SUBMIT",ugi,logger_time,host,jobid,jobname);
                        mysql_cache.put(jobid,true);
                    }
                }else if( "register".equals(flg) )
                {
                    //update tasknum
                    int mapnum=Integer.parseInt(jobinfo.get("mapnum"));
                    int rednum=Integer.parseInt(jobinfo.get("rednum"));
                    String jobconf=jobinfo.get("jobconf");
                    String state=jobinfo.get("state");

                        if( exist )
                        {
                            sql=String.format("UPDATE "+ table +" SET state='%s',progress='%s',jobconf='%s',mapnum=%d,rednum=%d WHERE jobid='%s'",
                                state,"REGISTER",jobconf,mapnum,rednum,jobid);
                        }else
                        {
                            sql=String.format("INSERT INTO "+ table +" (state,progress,ugi,jobid,mapnum,rednum) VALUES ('%s','%s','%s','%s','%s',%d,%d)", 
                                state,"REGISTER",jobinfo.get("ugi"),jobid,mapnum,rednum);
                            mysql_cache.put(jobid,true);
                        }
                }else if( "release".equals(flg) )
                {
                    //update progress
                    String progress=jobinfo.get("mapprogress");
                    if( progress == null )
                        return;

                    progress=jobinfo.get("redprogress");
                    if( progress == null )
                        return;

                    double mapprogress=Double.parseDouble(jobinfo.get("mapprogress"));
                    double redprogress=Double.parseDouble(jobinfo.get("redprogress"));

                    if( exist )
                    {
                        sql=String.format("UPDATE "+ table +" SET mapprogress=%.5f,redprogress=%.5f WHERE jobid='%s'",
                                mapprogress,redprogress,jobid);
                    }else
                    {
                        sql=String.format("INSERT INTO "+ table +" (ugi,mapprogress,redprogress,jobid) VALUES ('%s',%.3f,%.3f,'%s')", 
                            jobinfo.get("ugi"),mapprogress,redprogress,jobid);
                        mysql_cache.put(jobid,true);
                    }

                }else if( "queue".equals(flg) )
                {
                    String queue=jobinfo.get("queue");
                        if( exist )
                        {
                            sql=String.format("UPDATE "+ table +" SET queue='%s' WHERE jobid='%s'",
                                queue,jobid);
                        }else
                        {
                            sql=String.format("INSERT INTO "+ table +" (queue,jobid) VALUES ('%s','%s','%s','%s')", 
                                queue,jobid);
                            mysql_cache.put(jobid,true);
                        }

                }else if( "finish".equals(flg) || "summary".equals(flg) )
                {
                    // update flg
                    String state=jobinfo.get("state");

                    sql=String.format("UPDATE "+ table +" SET state='%s',progress='%s',jobconf='%s' WHERE jobid='%s'",
                            state,"FINISH", jobinfo.get("jobconf"), jobid);
                    mysql_cache.remove(jobid);
                }else
                    return;
    
                //System.err.println("#########################DB "+flg+" # "+jobinfo.toString() );
        		statement=conn.createStatement();
        		statement.execute(sql);
        		statement.close();
        	} catch (Exception e) {
        		e.printStackTrace();
                System.err.println("###############################"+sql);
        		continue;
        	}
        	break;
        }
    }
}
