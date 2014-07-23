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

/**
 * ServerSocket 功能说明： 主要是将文件内容读出来，一行一行
 * 
 * Spout类里面最重要的方法是nextTuple。 要么发射一个新的tuple到topology里面或者简单的返回如果已经没有新的tuple。
 * 要注意的是nextTuple方法不能阻塞，因为storm在同一个线程上面调用所有消息源spout的方法。
 * 另外两个比较重要的spout方法是ack和fail。 storm在检测到一个tuple被整个topology成功处理的时候调用ack，否则调用fail。
 * storm只对可靠的spout调用ack和fail。
 * 
 */
public class WordReader extends BaseRichSpout {

	private SpoutOutputCollector collector;

	private ConsumerConnector consumer;
	private String topic;

	private static ConsumerConfig createConsumerConfig() {
		Properties props = new Properties();
		props.put("zookeeper.connect", "10.10.10.150:2181");
		props.put("group.id", "1");
		props.put("zookeeper.session.timeout.ms", "10000");

		// props.put("zookeeper.sync.time.ms", "200");
		// props.put("auto.commit.interval.ms", "1000");

		return new ConsumerConfig(props);

	}

	// storm在检测到一个tuple被整个topology成功处理的时候调用ack，否则调用fail。
	public void ack(Object msgId) {
		System.out.println("OK:" + msgId);
	}

	public void close() {
	}

	// storm在检测到一个tuple被整个topology成功处理的时候调用ack，否则调用fail。
	public void fail(Object msgId) {
		System.out.println("FAIL:" + msgId);
	}

	/*
	 * 在SpoutTracker类中被调用，每调用一次就可以向storm集群中发射一条数据（一个tuple元组），该方法会被不停的调用
	 */
	public void nextTuple() {

		Map<String, Integer> topickMap = new HashMap<String, Integer>();
		topickMap.put(topic, 1);
		Map<String, List<KafkaStream<byte[], byte[]>>> streamMap = consumer
				.createMessageStreams(topickMap);
		KafkaStream<byte[], byte[]> stream = streamMap.get(topic).get(0);
		ConsumerIterator<byte[], byte[]> it = stream.iterator();
		while (it.hasNext()) {
			collector.emit(new Values(it.next().message().toString()));
		}

	}

	public void open(Map conf, TopologyContext context,
			SpoutOutputCollector collector) {

		this.collector = collector;
		topic = "kafka";
		consumer = kafka.consumer.Consumer
				.createJavaConsumerConnector(createConsumerConfig());
	}

	/**
	 * 定义字段id，该id在简单模式下没有用处，但在按照字段分组的模式下有很大的用处。
	 * 该declarer变量有很大作用，我们还可以调用declarer.
	 * declareStream();来定义stramId，该id可以用来定义更加复杂的流拓扑结构
	 */
	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("line"));
	}
}