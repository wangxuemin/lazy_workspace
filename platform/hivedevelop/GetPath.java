package xiaoju.hive.udf;

import org.apache.hadoop.hive.ql.exec.UDF;

public class GetPath extends UDF {

	public static boolean isNumeric(String str) {
		for (int i = 0; i < str.length(); i++) {
			if (!Character.isDigit(str.charAt(i))) {
				return false;
			}
		}
		return true;
	}

	public String evaluate(String str) {

		try {
			String src = str.replace("/user/xiaoju/data/bi/","");
			String ret[] = src.split("/");
			String path = new String();
			String partition = new String();
	//		String result[]=new String[2];

			for (int i = 0; i < ret.length - 1; i++) {
				if (!isNumeric(ret[i])) {
					path += ret[i] + "/";
				} else {
					partition += ret[i];
				}
			}
	//		result[0]=path;
	//		result[1]=partition;
			return path;

		} catch (Exception e) {

			return null;

		}

	}
} 
