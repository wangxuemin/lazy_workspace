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

    public void getTaskDiagnostics( String job )
    {
	LOG.info("getTaskDiagnostics");
	/*
	   JobID jobid=JobID.forName(job);
	   try{
	   for( TaskReport task : jobSubmitClient.getMapTaskReports( jobid ) )
	   {
	   System.out.println( task.getTaskId() );
	   for( String tmp : task.getDiagnostics() )
	   {
	   System.out.println( tmp );
	   }
	   }

	   for( TaskReport task: jobSubmitClient.getReduceTaskReports( jobid ) )
	   {
	   System.out.println( task.getTaskId() );
	   for( String tmp : task.getDiagnostics() )
	   {
	   System.out.println( tmp );
	   }
	   }
	   }catch( IOException e )
	   {
	   System.out.println( e );
	   }*/
    }

    public void listAllJobs() throws Exception
    {
	try{
	    //LOG.info("listAllJobs");
	    JobStatus[] job=client.getAllJobs();

	    for (int i = 0; i < job.length; i++) {

		StringBuilder sb=new StringBuilder();
		java.text.SimpleDateFormat sdf= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
		java.util.Date dt = new java.util.Date( job[i].getStartTime() ); 
		String sDateTime = sdf.format(dt);

		sb.append( sDateTime );
		sb.append( "|"+job[i].getJobID().toString() );
		sb.append( "|"+job[i].getState() );
		sb.append( "|"+job[i].getUsername() );
		sb.append( "|"+job[i].getQueue() );
		//sb.append( "|"+job[i].getSchedulingInfo() );
		sb.append( "|"+job[i].getJobFile() );
		sb.append( "|"+job[i].getTrackingUrl() );
		sb.append( "|"+job[i].getNumUsedSlots() );
		//sb.append( "|"+job[i].getHistoryFile() );
		sb.append( "|"+job[i].getNumReservedSlots() );
		sb.append( "|"+job[i].getUsedMem() );
		sb.append( "|"+job[i].getReservedMem() );
		sb.append( "|"+job[i].getReduceProgress() );
		sb.append( "|"+job[i].getMapProgress() );
		//sb.append( "|"+job[i].getJobName() );
		String jobname=job[i].getJobName() ;

		Pattern p = Pattern.compile("[\t|\r|\n]*");
		Matcher m = p.matcher(jobname);
		jobname = m.replaceAll("");
		sb.append( "|"+jobname );

		//getClusterMetrics()
		//TaskReport[] getTaskReports(JobID jobid, TaskType type);
		//String[] getTaskDiagnostics(TaskAttemptID taskId)
		//displayTasks(cluster.getJob(JobID.forName(jobid)), taskType, taskState);

		//-logs
		/*
		   JobID jobID = JobID.forName(jobid);
		   TaskAttemptID taskAttemptID = TaskAttemptID.forName(taskid);
		   LogParams logParams = cluster.getLogParams(jobID, taskAttemptID); //client.getLogFileParams(jobID, taskAttemptID);
		   LogCLIHelpers logDumper = new LogCLIHelpers();
		   logDumper.setConf(getConf());
		   exitCode = logDumper.dumpAContainersLogs(logParams.getApplicationId(),
		   logParams.getContainerId(), logParams.getNodeId(),
		   logParams.getOwner());
		   */
		//System.out.println( sb.toString() );
		LOG.info( sb.toString() );

		//System.out.println( job[i].getJobName() );


		//getUsername();
		//getQueue();
		//getSchedulingInfo();
		//getJobFile();
		//getTrackingUrl();
		//getFinishTime();
		//getNumUsedSlots();
		//getHistoryFile();
		//getNumReservedSlots();
		//getUsedMem();
		//getReservedMem();
		//getNeededMem();
		//getReduceProgress();
		//getMapProgress();


	    }


	}catch(Exception e)
	{
	    System.out.println(e);
	}/*
	    try{
	    JobStatus[] jobs = jobSubmitClient.getAllJobs();
	    for (JobStatus job : jobs) {
	    JobID jobId=job.getJobID();

	    String state=job.getJobRunState(job.getRunState());

	    String jobname=jobSubmitClient.getJobProfile(jobId).getJobName();
	    Pattern p = Pattern.compile(" +|\t|\r|\n");
	    Matcher m = p.matcher(jobname);
	    jobname = m.replaceAll(" ");

	    String username=job.getUsername();
	    long starttime=job.getStartTime();
	    float mapProgress=job.mapProgress();
	    float reduceProgress=job.reduceProgress();

	    java.text.SimpleDateFormat sdf= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
	    java.util.Date dt = new java.util.Date(starttime); 
	    String sDateTime = sdf.format(dt);
	    int mapnum=jobSubmitClient.getMapTaskReports(jobId).length;
	    int reducenum=jobSubmitClient.getReduceTaskReports(jobId).length;
	    System.out.println( 
	    sDateTime+"|"+
	    job.getJobId()+"|"+
	    state+"|" +
	    username+"|" +
	    mapnum+" "+(mapProgress==1? "100%":String.format("%.2f%%",mapProgress*100))+"|"+
	    reducenum+" "+(reduceProgress==1?"100%":String.format("%.2f%%",reduceProgress*100))+"|"+
	    jobname+"|"+
	    job.getFailureInfo() );
	    }
	    }catch(IOException e)
	    {
	    System.out.println(e);
	    } */
    }

    public static void main(String args[])
    {
	try{
	    Configuration conf=new Configuration();
	    HdpJobClient hdpcli = new HdpJobClient( conf );

	    if( args.length > 0 )
	    {
		hdpcli.getTaskDiagnostics(args[0]);
		return;
	    }

	    hdpcli.listAllJobs();
	}catch(Exception e)
	{
	    System.out.println(e);
	}

    }

}
