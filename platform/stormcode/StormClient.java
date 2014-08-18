package xiaoju.platform.storm.examples;

import java.util.HashMap;
import java.util.Iterator;

import backtype.storm.Config;
import backtype.storm.generated.ClusterSummary;
import backtype.storm.generated.Nimbus;
import backtype.storm.generated.SupervisorSummary;
import backtype.storm.generated.TopologySummary;
import backtype.storm.utils.NimbusClient;

import xiaoju.util.conf.Configuration;

public class StormClient {

	StormClient() {
	}

	public static String parseIntToimeintval(int intval) {
		int d = intval / (24 * 60 * 60);
		int h = (intval - d * 24 * 60 * 60) / (60 * 60);
		int m = (intval - d * 24 * 60 * 60 - h * 60 * 60) / 60;
		int s = intval - d * 24 * 60 * 60 - h * 60 * 60 - m * 60;

		return String.format("%dd %2dh %2dm %2ds", d, h, m, s);
	}

	public static void main(String args[]) {
		HashMap<String, Object> stormconf = new HashMap<String, Object>();

		Configuration.loadResource("storm.xml");

		stormconf.put(Config.NIMBUS_HOST, Configuration.getValueByProperty("nimbus.host") );
		stormconf.put(Config.NIMBUS_THRIFT_PORT, Integer.parseInt( Configuration.getValueByProperty("nimbus.thrift.port") ));
		stormconf.put(Config.STORM_THRIFT_TRANSPORT_PLUGIN,
				"backtype.storm.security.auth.SimpleTransportPlugin");
		Nimbus.Client cli = NimbusClient.getConfiguredClient(stormconf)
				.getClient();
		try {

			ClusterSummary summary = cli.getClusterInfo();

			StringBuilder sb = new StringBuilder();

			sb.append("Topology summary\n");
			sb.append(String.format("|%15s|%36s|%6s|%16s|%12s|%14s|%10s\n",
					"Name", "Id", "Status", "Uptime", "Num workers",
					"Num executors", "Num tasks"));
			int tasks = 0, executors = 0, ntmp = 0;
			for (Iterator<TopologySummary> itr = summary
					.get_topologies_iterator(); itr.hasNext();) {
				TopologySummary ts = itr.next();

				sb.append("|" + String.format("%15s", ts.get_name()));
				sb.append("|" + String.format("%36s", ts.get_id()));
				sb.append("|" + String.format("%6s", ts.get_status()));
				sb.append("|"
						+ String.format("%16s", StormClient
								.parseIntToimeintval(ts.get_uptime_secs())));
				sb.append("|" + String.format("%12d", ts.get_num_workers()));
				ntmp = ts.get_num_executors();
				executors += ntmp;
				sb.append("|" + String.format("%14d", ntmp));
				ntmp = ts.get_num_tasks();
				tasks += ntmp;
				sb.append("|" + String.format("%10d", ntmp));

				System.out.println(sb.toString());
				sb.setLength(0);
			}

			sb.setLength(0);
			sb.append("\nSupervisor summary\n");
			sb.append(String.format("|%36s|%12s|%16s|%8s|%10s\n", "Id", "Host",
					"Uptime", "Slots", "Used slots"));
			int total_slots = 0, used_slots = 0, slots = 0;
			for (Iterator<SupervisorSummary> itr = summary
					.get_supervisors_iterator(); itr.hasNext();) {
				SupervisorSummary ss = itr.next();

				sb.append("|" + String.format("%36s", ss.get_supervisor_id()));
				sb.append("|" + String.format("%12s", ss.get_host()));
				sb.append("|"
						+ String.format("%16s", StormClient
								.parseIntToimeintval(ss.get_uptime_secs())));
				slots = ss.get_num_workers();
				total_slots += slots;
				sb.append("|" + String.format("%8d", slots));
				slots = ss.get_num_used_workers();
				used_slots += slots;
				sb.append("|" + String.format("%10d", slots));

				System.out.println(sb.toString());
				sb.setLength(0);

			}

			sb.append("\nCluster Summary\n");
			sb.append(String.format("|%16s|%14s|%14s|%14s|%14s|%14s|%10s\n",
					"Nimbus uptime", "Supervisors", "Used slots", "Free slots",
					"Total slots", "Executors", "Tasks"));

			sb.append("|"
					+ String.format("%16s", StormClient
							.parseIntToimeintval(summary
									.get_nimbus_uptime_secs())));

			sb.append("|"
					+ String.format("%14s", summary.get_supervisors_size()));
			sb.append("|" + String.format("%14s", used_slots));
			sb.append("|" + String.format("%14s", total_slots - used_slots));
			sb.append("|" + String.format("%14s", total_slots));
			sb.append("|" + String.format("%14s", executors));
			sb.append("|" + String.format("%10s", tasks));

			System.out.println(sb.toString());

			if (args.length == 1) {
			System.out.println( cli.getTopology(args[0]).toString() );
			System.out.println( cli.getTopologyInfo( args[0]).toString() );
				return;
			} else if (args.length == 2) {
				return;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}

