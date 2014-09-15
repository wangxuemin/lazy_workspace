package xiaoju.pig.udf;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.InputFormat;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.RecordReader;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.pig.EvalFunc;
import org.apache.pig.LoadFunc;
import org.apache.pig.PigException;
import org.apache.pig.backend.executionengine.ExecException;
import org.apache.pig.backend.hadoop.executionengine.mapReduceLayer.PigSplit;
import org.apache.pig.backend.hadoop.executionengine.mapReduceLayer.PigTextInputFormat;
import org.apache.pig.data.Tuple;
import org.apache.pig.data.TupleFactory;

public class CustomLoader extends LoadFunc {

    protected RecordReader recordReader = null;
    protected String splitToken = "";

    public CustomLoader(String splitToken) {
	if( "||".equals(splitToken) )
		this.splitToken = "\\|\\|";
	else
		this.splitToken = splitToken;
   }

    @Override
        public InputFormat getInputFormat() throws IOException {
            return new PigTextInputFormat();
        }

    @Override
        public Tuple getNext() throws IOException {
            try {
                if (!recordReader.nextKeyValue()) {
                    return null;
                }
                Text line =(Text)recordReader.getCurrentValue();
                String[] strArray = line.toString().split(this.splitToken);
                List lst = new ArrayList<String>();
                int i = 0;
                for (String str:strArray) {

                    lst.add(i++, str);
                }
                return TupleFactory.getInstance().newTuple(lst);
            } catch (InterruptedException e) {
                e.printStackTrace();
                throw new ExecException("Read data error", PigException.REMOTE_ENVIRONMENT, e);
            }
        }

    @Override
        public void prepareToRead(RecordReader recordReader, PigSplit pigSplit)
        throws IOException {
        this.recordReader = recordReader;
        }

    @Override
        public void setLocation(String s, Job job) throws IOException {
            FileInputFormat.setInputPaths(job, s);
        }

}

//UDF的使用
//grunt> REGISTER '/home/grid/loadudf.jar' 
//grunt> D =LOAD 'hdfs://server1:9000/user/grid/in/access_log1.txt' USING cn.gdgz.hadoop.udf.CustomLoader(' - - ') AS (ip,contents);
