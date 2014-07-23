package example;

import java.io.DataInput;
import java.io.DataInputStream;
import java.io.DataOutput;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class SeDeExam implements Writable {

	int value;
	char ch;

	public SeDeExam(int value, char ch) {
		super();
		this.value = value;
		this.ch = ch;
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		this.value = value;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ch;
		result = prime * result + value;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SeDeExam other = (SeDeExam) obj;
		if (ch != other.ch)
			return false;
		if (value != other.value)
			return false;
		return true;
	}

	public char getCh() {
		return ch;
	}

	public void setCh(char ch) {
		this.ch = ch;
	}

	public void write(DataOutput out) throws IOException {
		out.writeChar(value);
		out.writeChar(ch);
		
		byte[] b=new byte[4];
		b[0]=0xa;
		b[1]=0xb;
		b[2]=0xc;
		b[3]=0xd;
		
		out.write(b);
		
	}

	public void readFields(DataInput in) throws IOException {
		value = in.readChar();
		ch = (char) in.readChar();
		
		byte[] b=new byte[4];
		in.readFully(b);
		
	}

	public static void main(String[] args) {

		StringBuilder sb = new StringBuilder();
		SeDeExam sd = new SeDeExam(10, 'a');

		try {
			FileOutputStream os = new FileOutputStream(new File(
					"C:\\Users\\leehan\\workspace\\sede.tmp"));
			DataOutputStream out = new DataOutputStream(os);
			sd.write(out);
			
			FileInputStream is = new FileInputStream(new File(
					"C:\\Users\\leehan\\workspace\\sede.tmp"));
			DataInputStream in = new DataInputStream(is);

			sd.readFields(in);
			System.out.println(sd.getValue() + " " + sd.getCh());
			
			sd.write(out);

			in.close();
			is.close();

			out.close();
			os.close();

		} catch (IOException e) {
			e.printStackTrace();
		}

	}

}


/*
 * for( String timezone : java.util.TimeZone.getAvailableIDs() ) {
 * System.out.println( timezone ); }
 */
