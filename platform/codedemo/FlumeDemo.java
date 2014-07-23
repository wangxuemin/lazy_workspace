package example;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class FlumeDemo {
	long errortime;
	Process process = null;

	public void start() {
		try {
			process = Runtime.getRuntime().exec("tail -F txt");
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					process.getInputStream()));
			String line = null;

			final BufferedReader errreader = new BufferedReader(
					new InputStreamReader(process.getErrorStream()));

			new Thread(new Runnable() {
				public void run() {
					String tmp = null;
					try {
						while ((tmp = errreader.readLine()) != null) {
							errortime = System.currentTimeMillis();
							System.out.println(tmp+errortime);
						}

					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}).start();

			while ((line = reader.readLine()) != null) {
				System.out.println(line+"|"+System.currentTimeMillis()+"|"+System.nanoTime());
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		new FlumeDemo().start();
		
	}
}