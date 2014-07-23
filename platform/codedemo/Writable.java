package example;

import java.io.DataOutput;
import java.io.DataInput;
import java.io.IOException;

public interface Writable {

	void write(DataOutput out) throws IOException;

	/**
	 * Deserialize the fields of this object from <code>in</code>.
	 * 
	 * <p>
	 * For efficiency, implementations should attempt to re-use storage in the
	 * existing object where possible.
	 * </p>
	 * 
	 * @param in
	 *            <code>DataInput</code> to deseriablize this object from.
	 * @throws IOException
	 */
	void readFields(DataInput in) throws IOException;
}
