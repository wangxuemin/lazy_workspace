package xiaoju.platform.storm.examples;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;

public class WordNormalizer extends BaseBasicBolt {

	public void cleanup() {
	}

	public void execute(Tuple input, BasicOutputCollector collector) {
		collector.emit(new Values(input.getBinary(0)));
	}

	public void declareOutputFields(OutputFieldsDeclarer declarer) {
		declarer.declare(new Fields("word"));
	}
}
