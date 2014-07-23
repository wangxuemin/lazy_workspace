package example;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class MysqlDemo {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String driver = "com.mysql.jdbc.Driver";
		String url = "jdbc:mysql://10.10.10.153:3377/data?autoReconnect=true&failOverReadOnly=false";
		String user = "data_w";
		String pass = "data_w";
		try {
			Class.forName(driver);

			Connection conn = DriverManager.getConnection(url, user, pass);
			if (conn.isClosed())
				throw new Exception("Mysql getConnection ERROR!");

			Statement statement = conn.createStatement();

			if (statement == null)
				throw new Exception("statement is null");
			String str = "aaaaaaa";
			String sql = String
					.format("insert into storm_bolt_ret (str) values ('%s')",
							str + "!");

			for (int i = 0; i < 3; i++) {
				try {
					statement.execute(sql);
					// Thread.sleep(32*1000);
					// statement.execute(sql);

				} catch (CommunicationsException e) {
					e.printStackTrace();
					Thread.sleep(30);
					continue;
				}

				break;
			}

			Thread.sleep(32*1000);
			for (int i = 0; i < 3; i++) {
				try {
					statement.execute(sql);
					// Thread.sleep(32*1000);
					// statement.execute(sql);

				} catch (CommunicationsException e) {
					e.printStackTrace();
					Thread.sleep(30);
					continue;
				}

				break;
			}
			statement.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
