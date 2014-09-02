package xiaoju.platform.storm.examples;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.tuple.Fields;
import backtype.storm.StormSubmitter;

public class TopologyMain {

	public static void main(String[] args) throws Exception {

		TopologyBuilder builder = new TopologyBuilder();
		builder.setSpout("word-reader", new WordReader(),5);
		builder.setBolt("word-normalizer", new WordNormalizer(),2)
				.shuffleGrouping("word-reader");
		builder.setBolt("word-counter", new WordCounter(), 2).fieldsGrouping(
				"word-normalizer", new Fields("word"));

		Config conf = new Config();
		conf.setNumWorkers(6);
		conf.setMaxSpoutPending(1);
		conf.setNumAckers(2);
		//conf.setDebug(true);
		conf.put(Config.TOPOLOGY_MAX_SPOUT_PENDING, 1);

		StormSubmitter.submitTopology( "wordCounterTopology", conf,
                              builder.createTopology());
	}

}
