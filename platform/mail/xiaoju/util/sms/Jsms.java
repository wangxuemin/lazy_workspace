package xiaoju.util.sms;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class Jsms {
	public static String SMS(String postData, String postUrl) {
		try {
			// 发送POST请求
			URL url = new URL(postUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.setRequestProperty("Connection", "Keep-Alive");
			conn.setUseCaches(false);
			conn.setDoOutput(true);

			conn.setRequestProperty("Content-Length", "" + postData.length());
			OutputStreamWriter out = new OutputStreamWriter(
					conn.getOutputStream(), "UTF-8");
			out.write(postData);
			out.flush();
			out.close();

			// 获取响应状态
			if (conn.getResponseCode() != HttpURLConnection.HTTP_OK) {
				System.out.println("connect failed!");
				return "";
			}
			// 获取响应内容体
			String line, result = "";
			BufferedReader in = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "utf-8"));
			while ((line = in.readLine()) != null) {
				result += line + "\n";
			}
			in.close();
			return result;
		} catch (IOException e) {
			e.printStackTrace(System.out);
		}
		return "";
	}

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		String phone = null, content = null;
		if (args.length == 0) {
			System.err.println("Usage: <phone> <content>");
			System.exit(2);
		} else if (args.length == 1) {
			phone = args[0];
		} else if (args.length == 2) {
			phone = args[0];
			content = args[1];
		}

		String stdinstr = null;
		StringBuilder sb = new StringBuilder();
		DataInputStream in = new DataInputStream(new BufferedInputStream(
				System.in));
		try {
			while (true) {
				try {
					if ((stdinstr = in.readLine()).length() > 0) {
						sb.append(stdinstr + "\n");
					} else
						break;
					// 没有换行符
				} catch (Exception e) {
					int length = 0;
					byte[] bytes = new byte[1024];
					while ((length = in.read(bytes)) > 0) {
						sb.append(new String(bytes, 0, length));
					}
					
					break;
				}
			}
			// An empty line terminates the program
		} catch (IOException e) {
			// e.printStackTrace();
		}

		stdinstr = sb.toString();
		in.close();

		if (!stdinstr.isEmpty()) {
			content = stdinstr;
		}

		if (content == null || content.isEmpty()) {
			System.err.println("content connot be empty!");
			System.exit(2);
		}

		try {

			String str = URLEncoder.encode(content, "gbk");
			String PostData = "OperID=dddacw&OperPass=dididache&SendTime=&ValidTime=&AppendID=&DesMobile="
					+ phone + "&Content=" + str + "&ContentType=8";
			Jsms.SMS(PostData,
					"http://221.179.180.158:9002/QxtSms/QxtFirewall?");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
