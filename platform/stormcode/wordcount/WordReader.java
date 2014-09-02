package xiaoju.platform.storm.examples;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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

public class WordReader extends BaseRichSpout {

    private SpoutOutputCollector collector;
    KafkaStream<byte[], byte[]> stream;
    private ConsumerConnector consumer;
    private String topic;

    private static ConsumerConfig createConsumerConfig() {
	Properties props = new Properties();
	props.put("zookeeper.connect", "10.10.10.150:2181");
	props.put("group.id", "1");
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
	    collector.emit(new Values(it.next().message()));
	}

    }

    public void open(Map conf, TopologyContext context,
	    SpoutOutputCollector collector) {

	this.collector = collector;
	topic = "kafka";
	consumer = kafka.consumer.Consumer
	    .createJavaConsumerConnector(createConsumerConfig());
	Map<String, Integer> topickMap = new HashMap<String, Integer>();
	topickMap.put(topic, 1);
	Map<String, List<KafkaStream<byte[], byte[]>>> streamMap = consumer.createMessageStreams(topickMap);
	stream = streamMap.get(topic).get(0);
    }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
	declarer.declare(new Fields("line"));
    }
}
