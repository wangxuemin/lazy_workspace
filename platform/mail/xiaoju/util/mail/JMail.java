package xiaoju.util.mail;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import com.diditaxi.monitor.mail.*;

import xiaoju.util.conf.Configuration;

import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.ParseException;

public class JMail {

	@SuppressWarnings("static-access")
	private static Options buildGeneralOptions(Options opts) {

		Option h = OptionBuilder.withArgName("ip|hostname").hasArg()
				.withDescription("specify a server name").create("h");

		Option P = OptionBuilder.withArgName("port").hasArg()
				.withDescription("specify a server port").create("P");

		Option u = OptionBuilder.withArgName("username").hasArg()
				.withDescription("specify a server username").create("u");

		Option p = OptionBuilder.withArgName("password").hasArg()
				.withDescription("specify a server password").create("p");

		Option d = OptionBuilder.withArgName("reciver1,reciver2").hasArg()
				.withDescription("specify recivers").create("d");

		Option c = OptionBuilder.withArgName("ccuser1,ccuser2").hasArg()
				.withDescription("specify cc usernames").create("c");

		Option s = OptionBuilder.withArgName("subject").hasArg()
				.withDescription("specify a subject").create("s");

		Option t = OptionBuilder.withArgName("content").hasArg()
				.withDescription("specify content").create("t");

		Option f = OptionBuilder.withArgName("filename1,filename2").hasArg()
				.withDescription("specify attach files").create("f");

		Option conf = OptionBuilder.withArgName("conf").hasArg()
				.withDescription("specify conf xml file").create("conf");

		opts.addOption(h);
		opts.addOption(P);
		opts.addOption(u);
		opts.addOption(p);
		opts.addOption(d);
		opts.addOption(c);
		opts.addOption(s);
		opts.addOption(t);
		opts.addOption(f);
		opts.addOption(conf);

		return opts;
	}

	@SuppressWarnings("deprecation")
	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub

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

		String confxml = null;
		String mailServerHost = null, mailServerPort = null, username = null, password = null;
		String fromAddress = null, toAddress = null, ccAddress = null, subject = null, content = null, attach = null;

		// 读取命令行参数
		Options opts = new Options();
		opts = buildGeneralOptions(opts);
		CommandLineParser parser = new GnuParser();
		try {
			CommandLine commandLine = parser.parse(opts, args, true);
			if (commandLine.hasOption("conf")) {
				confxml = commandLine.getOptionValue("conf");
				// 读取xml配置
				Configuration.loadResource(confxml);

			} else if (confxml == null || confxml.isEmpty()) {
				Configuration.loadResource("jmail.xml");
			}
			mailServerHost = Configuration
					.getValueByProperty("mail.server.host");
			mailServerPort = Configuration
					.getValueByProperty("mail.server.port");
			username = Configuration.getValueByProperty("mail.user.name");
			password = Configuration.getValueByProperty("mail.user.pass");
			toAddress = Configuration.getValueByProperty("mail.address.to");
			ccAddress = Configuration.getValueByProperty("mail.address.cc");
			subject = Configuration.getValueByProperty("mail.app.subject");
			content = Configuration.getValueByProperty("mail.app.content");
			attach = Configuration.getValueByProperty("mail.app.attach");
			fromAddress = username;

			if (commandLine.hasOption("h")) {
				mailServerHost = commandLine.getOptionValue("h");
			}
			if (commandLine.hasOption("P")) {
				mailServerPort = commandLine.getOptionValue("P");
			}
			if (commandLine.hasOption("u")) {
				username = commandLine.getOptionValue("u");
				fromAddress = username;
			}
			if (commandLine.hasOption("p")) {
				password = commandLine.getOptionValue("p");
			}
			if (commandLine.hasOption("d")) {
				toAddress = commandLine.getOptionValue("d");
			}
			if (commandLine.hasOption("c")) {
				ccAddress = commandLine.getOptionValue("c");
			}
			if (commandLine.hasOption("s")) {
				subject = commandLine.getOptionValue("s");
			}
			if (commandLine.hasOption("t")) {
				content = commandLine.getOptionValue("t");
			}
			if (commandLine.hasOption("f")) {
				attach = commandLine.getOptionValue("f");
			}

		} catch (ParseException e) {
			e.printStackTrace();
		}

		// 标准输入
		if (!(stdinstr == null || stdinstr.isEmpty()))
			content = stdinstr;
		// System.out.println(mailServerHost);
		// System.out.println(mailServerPort);
		// System.out.println(username);
		// System.out.println(password);
		// System.out.println(toAddress);
		// System.out.println(ccAddress);
		// System.out.println(subject);
		// System.out.println(content);
		// System.out.println(attach);
		if (mailServerHost.isEmpty() || mailServerPort.isEmpty()
				|| username.isEmpty() || password.isEmpty()
				|| fromAddress.isEmpty() || toAddress.isEmpty()
				|| subject.isEmpty() || content.isEmpty()) {
			throw new Exception(
					"mailServerHost,mailServerPort,username,password,fromAddress,toAddress,subject,content");
		}

		MailSenderInfo mailInfo = new MailSenderInfo();
		mailInfo.setValidate(true);

		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);

		mailInfo.setUserName(username);
		mailInfo.setPassword(password);

		mailInfo.setFromAddress(fromAddress);
		mailInfo.setToAddress(toAddress);
		mailInfo.setCcAddress(ccAddress);
		mailInfo.setSubject(subject);
		mailInfo.setContent(content);

		// 发送邮件
		// SimpleMailSender.sendTextMail(mailInfo);// 发送文体格式
		SimpleMailSender.sendHtmlMail(mailInfo);// 发送html格式
	}

}
