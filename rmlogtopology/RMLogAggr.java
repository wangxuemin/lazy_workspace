package xiaoju.platform.storm.examples;

import java.io.IOException;
import java.io.ByteArrayInputStream;
import java.io.ObjectInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.net.InetSocketAddress;
import java.net.InetAddress;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.HashMap;
import java.util.Map;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.task.TopologyContext;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.mapred.YarnClientProtocolProvider;
import org.apache.hadoop.mapreduce.MRConfig;
import org.apache.hadoop.mapreduce.protocol.ClientProtocol;
import org.apache.hadoop.mapreduce.protocol.ClientProtocolProvider;
import org.apache.hadoop.mapreduce.JobStatus;
import org.apache.hadoop.mapreduce.TaskType;
import org.apache.hadoop.mapred.JobID;

public class RMLogAggr extends BaseBasicBolt {

    String jobid=new String();
    String flg=new String();

    private ClientProtocol client;
    private ClientProtocolProvider clientProtocolProvider;
    private HashMap<String,String> jobinfo=new HashMap<String,String>();
    private static Pattern pp = Pattern.compile("[\t|\r|\n]*");

    public void prepare(Map stormConf, TopologyContext context) {
        Configuration config = new Configuration();
        config.set( "mapreduce.framework.name", "yarn" );
        config.set( "yarn.resourcemanager.address" ,  "hdp800.qq:18040" );
        config.set( "mapreduce.jobhistory.address" ,  "hdp800.qq:10020" );

        try{
            initialize(null,config);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void cleanup() {
    }

    public void execute(Tuple input, BasicOutputCollector collector) {

        int mapnum,rednum;
        Float mapprogress,redprogress;
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(); 

        try{
            jobid=new String(input.getBinary(0),"UTF-8" );
            flg=new String(input.getBinary(1),"UTF-8" );

            ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream( input.getBinary(2) );   
            ObjectInputStream objectInputStream = new ObjectInputStream(byteArrayInputStream);
            jobinfo=(HashMap<String,String>) objectInputStream.readObject();

            JobID job= JobID.forName(jobid);
            JobStatus jobstatus = null;

            for(int i=0; i<3; i++)
            {
                jobstatus = client.getJobStatus(job);
                if( jobstatus != null )
                    break;
            }

            if( jobstatus==null && ! "finish".equals(flg) && ! "summary".equals(flg) )
                return;

            if( "submit".equals(flg) )
            {
                String jobname = jobstatus.getJobName();
                Matcher mm = pp.matcher(jobname);
                jobname = mm.replaceAll("");
                jobname = jobname.replaceAll("\"","'");

                jobinfo.put( "jobname",jobname );
                jobinfo.put( "host", InetAddress.getByName(jobinfo.get("host")).getHostName()+"/"+jobinfo.get("host") );
                
            }else if( "register".equals(flg) )
            {
                jobinfo.put("jobconf",jobstatus.getJobFile());
                jobinfo.put("state",jobstatus.getState().toString());

                mapnum = client.getTaskReports(job, TaskType.MAP).length;
                rednum = client.getTaskReports(job, TaskType.REDUCE).length;

                jobinfo.put("mapnum", String.valueOf(mapnum) );
                jobinfo.put("rednum", String.valueOf(rednum) );
                if( mapnum > 800 || rednum > 200 || mapnum + rednum > 1000 )
                {
                }
            }else if( "queue".equals(flg) )
            {

            }else if( "release".equals(flg) )
            {
                if( jobstatus != null ){

                    mapprogress = jobstatus.getMapProgress();
                    redprogress = jobstatus.getReduceProgress();

                    mapprogress = mapprogress.isNaN() ? (float) 0.0 :mapprogress;
                    redprogress = redprogress.isNaN() ? (float) 0.0 :redprogress;

                    jobinfo.put("mapprogress", String.valueOf(mapprogress) );
                    jobinfo.put("redprogress", String.valueOf(redprogress) );
                }
            }else if( "finish".equals(flg) || "summary".equals(flg) )
            {
                if( jobstatus==null )
                    jobinfo.put("state","FINISH");
                else{
                    //jobinfo.put("state","FINISH");
                    jobinfo.put("state",jobstatus.getState().toString());
                    jobinfo.put("jobconf", jobstatus.getJobFile());
                }

            }

            ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
            objectOutputStream.writeObject(jobinfo);
        }catch( Exception e )
        {
            e.printStackTrace();
        }

        collector.emit(new Values(jobid.getBytes(),flg.getBytes(),byteArrayOutputStream.toByteArray() ));
//        System.err.println("#########################AGGR "+flg+" # "+jobinfo.toString() );
        jobinfo.clear();
    }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("jobid","FLG","jobinfo"));
    }

    private void initialize(InetSocketAddress jobTrackAddr, Configuration conf)
        throws IOException {

        ClientProtocolProvider provider = new YarnClientProtocolProvider();
        ClientProtocol clientProtocol = null;

        try {
            if (jobTrackAddr == null) {
                clientProtocol = provider.create(conf);
            } else {
                clientProtocol = provider.create(jobTrackAddr, conf);
            }

            if (clientProtocol != null) {
                clientProtocolProvider = provider;
                client = clientProtocol;
                System.out.println("Picked " + provider.getClass().getName()
                        + " as the ClientProtocolProvider");
            } else {
                System.out.println("Cannot pick "
                        + provider.getClass().getName()
                        + " as the ClientProtocolProvider - returned null protocol");
            }
        } catch (Exception e) {
            System.err.println("Failed to use " + provider.getClass().getName()
                    + " due to error: " + e.getMessage());
        }

        if (null == clientProtocolProvider || null == client) {
            throw new IOException(
                    "Cannot initialize Cluster. Please check your configuration for "
                    + MRConfig.FRAMEWORK_NAME
                    + " and the correspond server addresses.");
        }
    }

}
