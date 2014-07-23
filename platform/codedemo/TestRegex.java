package example;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class TestRegex {
	// private static final String parttern_FSAudit="";
	private static Pattern parttern_FSAudit = Pattern
			.compile("([\\w :,.-]{23}).*allowed=(\\w*).*ugi=(\\w*).*?\\(auth:(\\w*)\\).*ip=/([0-9.]*).*cmd=(\\w*).*src=([^ \t]*).*dst=([^ \t]*).*perm=([\\w:-]*).*");
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			FileInputStream is = new FileInputStream(new File(
					"C:\\Users\\leehan\\workspace\\TestRegex.tmp"));
			DataInputStream in = new DataInputStream(is);
			String str = null;

			while ((str = in.readLine()).length() > 0) {
				System.out.println(str);
				Matcher m = parttern_FSAudit.matcher(str);
				m = parttern_FSAudit.matcher(str);
				if (m.matches()) {
					for (int i = 1; i <= m.groupCount(); i++)
						System.out.println(m.group(i));
				}
			}

			in.close();

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
