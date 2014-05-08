package xiaoju.util.conf;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class Configuration {
	public Configuration() {
	}

	static Map<String, String> confmap = new HashMap<String, String>();

	public static void loadResource(String filename) {
		try {
			DocumentBuilderFactory factory = DocumentBuilderFactory
					.newInstance();
			DocumentBuilder db = factory.newDocumentBuilder();
			Document doc = db.parse(new File(filename));
			Element elmtInfo = doc.getDocumentElement();
			NodeList list = doc.getElementsByTagName("property");
			for (int i = 0; i < list.getLength(); i++) {
				try {
					Element element = (Element) list.item(i);
					String name = element.getElementsByTagName("name").item(0)
							.getFirstChild().getNodeValue();
					String value = element.getElementsByTagName("value")
							.item(0).getFirstChild().getNodeValue();
					name = name.trim();
					value = value.trim();

					confmap.put(name, value);
				} catch (NullPointerException ne) {
					continue;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String getValueByProperty(String key) {
		return confmap.get(key);
	}
}
