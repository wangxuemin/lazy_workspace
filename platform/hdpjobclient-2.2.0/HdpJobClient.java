package org.apache.hadoop.mapred;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.List;
import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapreduce.MRConfig;
import org.apache.hadoop.mapreduce.protocol.ClientProtocol;
import org.apache.hadoop.mapreduce.protocol.ClientProtocolProvider;
import org.apache.hadoop.mapreduce.util.ConfigUtil;
import org.apache.hadoop.mapreduce.JobStatus;
import org.apache.hadoop.mapreduce.TaskType;
import org.apache.hadoop.mapreduce.TaskReport;
import org.apache.hadoop.mapreduce.TaskAttemptID;
import org.apache.hadoop.mapreduce.v2.LogParams;
import org.apache.hadoop.yarn.logaggregation.LogCLIHelpers;

public class HdpJobClient {

    private static final Log LOG = LogFactory.getLog(HdpJobClient.class);

    private ClientProtocolProvider clientProtocolProvider;
    private ClientProtocol client;
    private Configuration conf;

    static {
	ConfigUtil.loadResources();
    }

    public HdpJobClient() throws IOException {
    }

    public HdpJobClient(Configuration conf) throws IOException {
	this(null, conf);

    }

    public HdpJobClient(InetSocketAddress jobTrackAddr, Configuration conf) 
	throws IOException {

	    this.conf = conf;
	    initialize(jobTrackAddr, conf);
	}

    private void initialize(InetSocketAddress jobTrackAddr, Configuration conf)
	throws IOException {

	    ClientProtocolProvider provider=new YarnClientProtocolProvider();
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
		    LOG.debug("Picked " + provider.getClass().getName()
			    + " as the ClientProtocolProvider");
		}
		else {
		    LOG.debug("Cannot pick " + provider.getClass().getName()
			    + " as the ClientProtocolProvider - returned null protocol");
		}
	    } 
	    catch (Exception e) {
		LOG.info("Failed to use " + provider.getClass().getName()
			+ " due to error: " + e.getMessage());
	    }

	    if (null == clientProtocolProvider || null == client)
	    {
		throw new IOException(
			"Cannot initialize Cluster. Please check your configuration for "
			+ MRConfig.FRAMEWORK_NAME
			+ " and the correspond server addresses.");
	    }
	}

    public void getTaskAttempt( String job, String taskid )
    {
	//-logs
	try{
	    JobID jobid=JobID.forName(job);
	    TaskAttemptID taskAttemptID = TaskAttemptID.forName(taskid);

	    StringBuilder sb=new StringBuilder();

	    LogParams logParams = client.getLogFileParams(jobid, taskAttemptID);
	    LogCLIHelpers logDumper = new LogCLIHelpers();
	    logDumper.setConf( conf );

	    sb.append( logParams.getApplicationId() );
	    sb.append( "|"+logParams.getContainerId() );
	    sb.append( "|"+logParams.getNodeId() );
	    sb.append( "|"+logParams.getOwner() );
	    System.out.println( sb.toString() );

	    logDumper.dumpAContainersLogs(logParams.getApplicationId(),
		    logParams.getContainerId(), logParams.getNodeId(),
		    logParams.getOwner());
	}catch( Exception e )
	{
	    System.out.println( e );
	}
    }

    public void getTaskDiagnostics( String job )
    {

	try{
	    String errinfo[];
        StringBuilder sb=new StringBuilder();

	    JobID jobid=JobID.forName(job);
	    JobStatus status=client.getJobStatus(jobid);
	    System.out.println( status.getTrackingUrl() );
	    System.out.println( status.getJobFile() );
	    System.out.println( status.getHistoryFile() );

	    int mapnum=client.getTaskReports( jobid, TaskType.MAP ).length;
	    int rednum=client.getTaskReports( jobid, TaskType.REDUCE ).length;
        float progress=status.getMapProgress();
		sb.append( String.format("m %4d %6s", mapnum, progress==1? "100%":String.format("%.2f%%",progress*100)) );
        sb.append("|");
        progress=status.getReduceProgress();
		sb.append( String.format("r %4d %6s", rednum, progress==1? "100%":String.format("%.2f%%",progress*100)) );

        System.out.println( sb.toString() );
	    printTaskAttempt( client.getTaskReports( jobid, TaskType.MAP ) );
	    printTaskAttempt( client.getTaskReports( jobid, TaskType.REDUCE ) );
        System.out.println( sb.toString() );

	}catch( Exception e ){
	    System.out.println( e );
	}

    }

    private void printTaskAttempt( TaskReport[] tasks )
    {
	String errinfo[];

	for( TaskReport task: tasks )
	{
	    StringBuilder sb=new StringBuilder();
	    StringBuilder attempt=new StringBuilder();

	    float progress = task.getProgress();

	    java.text.SimpleDateFormat sdf= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
	    java.util.Date dt = new java.util.Date( task.getStartTime() ); 
	    String sDateTime = sdf.format(dt);
	    dt = new java.util.Date( task.getFinishTime() ); 
	    String eDateTime = sdf.format(dt);

	    sb.append( task.getTaskId() );

        if (task.getCurrentStatus() == TIPStatus.COMPLETE) {
            attempt.append(task.getSuccessfulTaskAttemptId());
        } else if (task.getCurrentStatus() == TIPStatus.RUNNING) {
            for (TaskAttemptID t : 
                    task.getRunningTaskAttemptIds()) {
                if( attempt == null || attempt.length() == 0)
                    attempt.append( t );
                else
                    attempt.append( ","+t );
            }
        }

	    sb.append( "|"+attempt.toString() );
	    sb.append( "|"+(progress==1? "100%":String.format("%.2f%%",progress*100)) );
	    sb.append( "|"+sDateTime);
	    sb.append( "|"+eDateTime);
	    sb.append( "|"+String.format("% 8.3fs",(task.getFinishTime()-task.getStartTime())/1000.0 ) );

	    System.out.println(sb.toString());

	    errinfo=task.getDiagnostics();
	    if( errinfo.length > 0 && ! errinfo[0].isEmpty() )
	    {
		for( String info : errinfo )
		    System.out.println( info );
	    }
	}
    }

    public void displayAllJobs() throws Exception
    {
	try{

	    JobStatus[] job=client.getAllJobs();

	    for (int i = 0; i < job.length; i++) {

		StringBuilder sb=new StringBuilder();
		java.text.SimpleDateFormat sdf= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		java.util.Date dt = new java.util.Date( job[i].getStartTime() ); 
		String sDateTime = sdf.format(dt);

		sb.append( sDateTime );
		sb.append( "|"+job[i].getJobID().toString() );
		sb.append( "|"+String.format("%-10s",job[i].getState()) );
		sb.append( "|"+String.format("%-8s",job[i].getUsername()) );
		sb.append( "|"+String.format("%-8s",job[i].getQueue()) );
        //JobStatus status=client.getJobStatus( job[i].getJobID() );
		//sb.append( "|"+String.format("m %.2f",status.getMapProgress()) );
		//sb.append( "|"+String.format("r %.2f",status.getReduceProgress()) );
		String jobname=job[i].getJobName() ;

		Pattern p = Pattern.compile("[\t|\r|\n]*");
		Matcher m = p.matcher(jobname);
		jobname = m.replaceAll("");
		sb.append( "|"+jobname );
        String failInfo=job[i].getFailureInfo() ;
        if( !failInfo.isEmpty() )
            sb.append( "|"+failInfo );

		//getClusterMetrics()

		System.out.println( sb.toString() );
		//LOG.info( sb.toString() );
	    }

	}catch(Exception e)
	{
	    System.out.println(e);
	}
    }

    public static void main(String args[])
    {
	try{
	    Configuration conf=new Configuration();
	    HdpJobClient hdpcli = new HdpJobClient( conf );

	    if( args.length == 1 )
	    {
		hdpcli.getTaskDiagnostics(args[0]);
		return;
	    }else if( args.length == 2 )
	    {
		hdpcli.getTaskAttempt(args[0],args[1]);
		return;
	    }

	    hdpcli.displayAllJobs();
	}catch(Exception e)
	{
	    System.out.println(e);
	}

    }

}
