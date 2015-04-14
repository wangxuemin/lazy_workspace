package xiaoju.platform.storm.examples;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.tuple.Fields;
import backtype.storm.StormSubmitter;
import backtype.storm.LocalCluster;

public class RMLogTopologyMain {

    public static void main(String[] args) throws Exception {

        TopologyBuilder builder = new TopologyBuilder();

        builder.setSpout("RMLogReader", new RMLogReader(),1);

        builder.setBolt("RMLogAggr", new RMLogAggr(),1)
            .fieldsGrouping("RMLogReader",new Fields("jobid"));

        builder.setBolt("RMLogToDB", new RMLogToDB(), 1).fieldsGrouping(
                "RMLogAggr", new Fields("jobid"));

        Config conf = new Config();
        conf.setNumWorkers(1);
        conf.setMaxSpoutPending(1);
        conf.setNumAckers(1);
//        conf.put(Config.TOPOLOGY_MAX_SPOUT_PENDING, 1);

        if( args.length == 1 && args[0].equals("online") )
        {
            StormSubmitter.submitTopology( "RMLogTopology", conf,
                    builder.createTopology());
        }else{

            //conf.setDebug(true);
            LocalCluster cluster = new LocalCluster();
            cluster.submitTopology("RMLogTopology", conf,
                    builder.createTopology());
            Thread.sleep(1000*240);
            cluster.shutdown();
        }
    }

}
