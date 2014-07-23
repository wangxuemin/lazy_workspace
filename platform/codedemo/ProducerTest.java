package xiaoju.platform.storm.examples;

import java.util.Properties;

import kafka.javaapi.producer.Producer;
import kafka.producer.KeyedMessage;
import kafka.producer.ProducerConfig;

public class ProducerTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Properties props = new Properties();
		// props.setProperty("metadata.broker.list", "10.10.10.150:9092");
		props.setProperty("metadata.broker.list",
				"10.10.10.150:9092,10.10.10.150:9093,10.10.10.150:9094");
		props.setProperty("serializer.class", "kafka.serializer.StringEncoder");
		props.put("request.required.acks", "1");

		ProducerConfig config = new ProducerConfig(props);
		Producer<String, String> producer = new Producer<String, String>(config);

		try {
			for (int i = 0; i < 10; i++) {
				KeyedMessage<String, String> data = new KeyedMessage<String, String>(
						"kafka", "Hello"+i+"World");
				producer.send(data);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		producer.close();
	}
}
