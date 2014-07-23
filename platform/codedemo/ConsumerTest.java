package xiaoju.platform.storm.examples;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import kafka.consumer.ConsumerIterator;
import kafka.consumer.KafkaStream;
import kafka.consumer.ConsumerConfig;
import kafka.javaapi.consumer.ConsumerConnector;

public class ConsumerTest extends Thread {
	private final ConsumerConnector consumer;
	private final String topic;

	public ConsumerTest(String topic) {
		consumer = kafka.consumer.Consumer
				.createJavaConsumerConnector(createConsumerConfig());
		this.topic = topic;
	}

	private static ConsumerConfig createConsumerConfig() {
		Properties props = new Properties();
		props.put("zookeeper.connect", "10.10.10.150:2181");
		props.put("group.id", "1");
		props.put("zookeeper.session.timeout.ms", "10000");
		
		// props.put("zookeeper.sync.time.ms", "200");
		// props.put("auto.commit.interval.ms", "1000");

		return new ConsumerConfig(props);

	}

	public void run() {

		Map<String, Integer> topickMap = new HashMap<String, Integer>();
		topickMap.put(topic, 1);
		Map<String, List<KafkaStream<byte[], byte[]>>> streamMap = consumer
				.createMessageStreams(topickMap);
		KafkaStream<byte[], byte[]> stream = streamMap.get(topic).get(0);
		ConsumerIterator<byte[], byte[]> it = stream.iterator();
		while (it.hasNext()) {
			//
			System.out.println("(consumer)--> "
					+ new String(it.next().message()));
		}

	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ConsumerTest consumerThread = new ConsumerTest("kafka");
		consumerThread.start();
	}

}
