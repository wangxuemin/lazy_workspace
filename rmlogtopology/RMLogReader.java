package xiaoju.platform.storm.examples;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;

import java.net.ServerSocket;
import java.net.Socket;
import java.net.InetAddress;
import java.net.InetSocketAddress;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import kafka.consumer.ConsumerConfig;
import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
import kafka.javaapi.consumer.ConsumerConnector;

import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;

public class RMLogReader extends BaseRichSpout {

    private SpoutOutputCollector collector;
    KafkaStream<byte[], byte[]> stream;
    private ConsumerConnector consumer;
    private String topic;
    private HashMap<String,String> jobinfo=new HashMap<String,String>();

    //ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(); 
    private static Pattern submit_pattern = Pattern.compile( "^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*USER=([a-zA-Z0-9]*)[ \t]*IP=([.0-9]*).*OPERATION=Submit Application Request.*RESULT=([a-zA-Z0-9]*)[ \t]*APPID=([a-zA-Z0-9_]*)" );
    private static Pattern register_pattern = Pattern.compile("^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*USER=([a-zA-Z0-9]*)[ \t]*IP=([.0-9]*).*OPERATION=Register App Master.*RESULT=([a-zA-Z0-9]*)[ \t]*APPID=([a-zA-Z0-9_]*).*" );
    private static Pattern queue_pattern = Pattern.compile("^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.LeafQueue.*Application[ \t]*([a-zA-Z0-9_]*).*activated in queue:[ \t]*([a-zA-Z0-9]*).*");
    private static Pattern release_pattern = Pattern.compile("^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*USER=([a-zA-Z0-9]*)[ \t]*OPERATION=AM Released Container.*RESULT=([a-zA-Z0-9]*)[ \t]*APPID=([a-zA-Z0-9_]*).*" );
    private static Pattern finish_pattern = Pattern.compile("^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*USER=([a-zA-Z0-9]*)[ \t].*OPERATION=Application Finished.*RESULT=([a-zA-Z0-9]*)[ \t]*APPID=([a-zA-Z0-9_]*).*");
    private static Pattern summary_pattern = Pattern.compile("^([0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}).*ApplicationSummary.*appId=([a-zA-Z0-9_]*).*");

    private static ConsumerConfig createConsumerConfig() {
        Properties props = new Properties();
        props.put("zookeeper.connect", "hdp71.qq:2181,hdp72.qq:2181,hdp73.qq:2181");
        props.put("group.id", "stormSpout");
        props.put("zookeeper.session.timeout.ms", "10000");

        return new ConsumerConfig(props);
    }

    public void ack(Object msgId) {
        System.out.println("OK:" + msgId);
    }

    public void close() {
    }


    public void fail(Object msgId) {
        System.out.println("FAIL:" + msgId);
    }

    public void nextTuple() {

        ConsumerIterator<byte[], byte[]> it = stream.iterator();

        while (it.hasNext()) {

            String flg=null;
            String str=new String(it.next().message());
            Matcher submit_matcher,register_matcher,queue_matcher,release_matcher,finish_matcher,summary_matcher = null;
            boolean match=false;

            submit_matcher = submit_pattern.matcher(str);
            if ( !match && submit_matcher.matches()) {
                jobinfo.put("time", submit_matcher.group(1) );
                jobinfo.put("ugi", submit_matcher.group(2) );
                jobinfo.put("host", submit_matcher.group(3) );
                //jobinfo.put("result", submit_matcher.group(4) );
                jobinfo.put("jobid", submit_matcher.group(5).replace("application","job") );
                flg="submit";
                match=true;
            }

            register_matcher = register_pattern.matcher(str);
            if( !match && register_matcher.matches() ){
                jobinfo.put("time", register_matcher.group(1) );
                jobinfo.put("ugi", register_matcher.group(2) );
                jobinfo.put("host", register_matcher.group(3) );
                //jobinfo.put("result", register_matcher.group(4) );
                jobinfo.put("jobid", register_matcher.group(5).replace("application","job") );
                flg="register";
                match=true;
            }

            queue_matcher = queue_pattern.matcher(str);
            if( !match && queue_matcher.matches() ){
                jobinfo.put("time", queue_matcher.group(1) );
                jobinfo.put("jobid", queue_matcher.group(2).replace("application","job") );
                jobinfo.put("queue", queue_matcher.group(3));
                flg="queue";
                match=true;
            }

            release_matcher = release_pattern.matcher(str);
            if( !match && release_matcher.matches() ){
                jobinfo.put("time", release_matcher.group(1) );
                jobinfo.put("ugi", release_matcher.group(2) );
                //jobinfo.put("result", release_matcher.group(3) );
                jobinfo.put("jobid", release_matcher.group(4).replace("application","job") );
                flg="release";
                match=true;
            }

            finish_matcher = finish_pattern.matcher(str);
            if( !match && finish_matcher.matches() ){
                jobinfo.put("time", finish_matcher.group(1) );
                jobinfo.put("ugi", finish_matcher.group(2) );
                //jobinfo.put("result", finish_matcher.group(3) );
                jobinfo.put("jobid", finish_matcher.group(4).replace("application","job") );
                flg="finish";
                match=true;
            }

            summary_matcher = summary_pattern.matcher(str);
            if( !match && summary_matcher.matches() ){
                jobinfo.put("time", summary_matcher.group(1) );
                jobinfo.put("jobid", summary_matcher.group(2).replace("application","job") );
                flg="summary";
                match=true;
            }

            if( !match )
                return;

            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(); 
            try{
                ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
                objectOutputStream.writeObject( jobinfo );
            }catch(Exception e)
            {
                e.printStackTrace();
            }

            collector.emit(new Values(jobinfo.get("jobid").getBytes(),flg.getBytes(),byteArrayOutputStream.toByteArray() ));
//            System.err.println("#########################READER "+flg+" # "+jobinfo.toString() );
            jobinfo.clear();
        }

    }

    public void open(Map conf, TopologyContext context,
            SpoutOutputCollector collector) {

        this.collector = collector;
        topic = "resourcemanager";
        consumer = kafka.consumer.Consumer
            .createJavaConsumerConnector(createConsumerConfig());
        Map<String, Integer> topickMap = new HashMap<String, Integer>();
        topickMap.put(topic, 1);
        Map<String, List<KafkaStream<byte[], byte[]>>> streamMap = consumer.createMessageStreams(topickMap);
        stream = streamMap.get(topic).get(0);

    }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("jobid","FLG","jobinfo"));
    }
}
