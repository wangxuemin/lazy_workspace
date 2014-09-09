import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.Delete;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.io.compress.Compression;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.HTableInterface;
import org.apache.hadoop.hbase.client.HTablePool;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;

public class HbaseDemo {

    private static Configuration conf = null;

private static HTablePool pool;

    static {
	Configuration HBASE_CONFIG = new Configuration();

	HBASE_CONFIG.set("hbase.zookeeper.quorum", "10.10.10.152,10.10.10.57,10.10.10.58");

	HBASE_CONFIG.set("hbase.zookeeper.property.clientPort", "2181");
	conf = HBaseConfiguration.create(HBASE_CONFIG);
	pool=new HTablePool(conf,100);
    }

    public static void creatTable(String tableName, String[] familys,String[] ssplits) throws Exception {
	HBaseAdmin admin = new HBaseAdmin(conf);
	if (admin.tableExists(tableName)) {
	    System.out.println("table already exists! DELETE");
	deleteTable(tableName);
	}
	    HTableDescriptor tableDesc = new HTableDescriptor(tableName);
	    for(int i=0; i<familys.length; i++){
		tableDesc.addFamily(new HColumnDescriptor(familys[i]).setMaxVersions(3).setTimeToLive(120).setCompactionCompressionType(Compression.Algorithm.LZO).setCompressionType(Compression.Algorithm.LZO));
	    }
            
tableDesc.setCompactionEnabled(true);
tableDesc.setConfiguration("hbase.hregion.majorcompaction","0");
        byte[][] splits=new byte[ssplits.length][];
        
        for(int i=0;i<ssplits.length;i++)
        {
        	splits[i]=new byte[ssplits[i].length()];
        	splits[i]=ssplits[i].getBytes();
        }
	    admin.createTable(tableDesc,splits);
	    System.out.println("create table " + tableName + " ok.");
	 
    }

    public static void deleteTable(String tableName) throws Exception {
	try {
	    HBaseAdmin admin = new HBaseAdmin(conf);
	    admin.disableTable(tableName);
	    admin.deleteTable(tableName);
	    System.out.println("delete table " + tableName + " ok.");
	} catch (MasterNotRunningException e) {
	    e.printStackTrace();
	} catch (ZooKeeperConnectionException e) {
	    e.printStackTrace();
	}
    }

    public static void addRecord (String tableName, String rowKey, String family, String qualifier, String value)
	throws Exception{
        	HTableInterface table = pool.getTable(tableName);
	    try {

//		HTable table = new HTable(conf, tableName);
		Put put = new Put(Bytes.toBytes(rowKey));
		put.add(Bytes.toBytes(family),Bytes.toBytes(qualifier),Bytes.toBytes(value));
		table.put(put);
//		System.out.println("insert recored " + rowKey + " to table " + tableName +" ok.");
	    } catch (IOException e) {
		e.printStackTrace();
pool.putTable(table);
	    }
pool.putTable(table);
	}


    public static void delRecord (String tableName, String rowKey) throws IOException{
	HTable table = new HTable(conf, tableName);
	List list = new ArrayList();
	Delete del = new Delete(rowKey.getBytes());
	list.add(del);
	table.delete(list);
	System.out.println("del recored " + rowKey + " ok.");
    }


    public static void getOneRecord (String tableName, String rowKey) throws IOException{
	HTable table = new HTable(conf, tableName);
	Get get = new Get(rowKey.getBytes());
	Result rs = table.get(get);
	for(KeyValue kv : rs.raw()){
	    System.out.print(new String(kv.getRow()) + " " );
	    System.out.print(new String(kv.getFamily()) + ":" );
	    System.out.print(new String(kv.getQualifier()) + " " );
	    System.out.print(kv.getTimestamp() + " " );
	    System.out.println(new String(kv.getValue()));
	}
    }


    public static void getAllRecord (String tableName) {
	try{
	    HTable table = new HTable(conf, tableName);
	    Scan s = new Scan();
	    ResultScanner ss = table.getScanner(s);
	    for(Result r:ss){
		for(KeyValue kv : r.raw()){
		    System.out.print(new String(kv.getRow()) + " ");
		    System.out.print(new String(kv.getFamily()) + ":");
		    System.out.print(new String(kv.getQualifier()) + " ");
		    System.out.print(kv.getTimestamp() + " ");
		    System.out.println(new String(kv.getValue()));
		}
	    }
	} catch (IOException e){
	    e.printStackTrace();
	}
    }

    public static void  main (String [] agrs) {
	try {
	    String tablename = "scores";
//	    String[] familys = {"grade", "course"};
	    String[] familys = {"course" };
            String[] splits={"row2000","row4000","row6000","row8000"};
	    HbaseDemo.creatTable(tablename, familys,splits);


	    //HbaseDemo.addRecord(tablename,"zkb","grade","","5");
	    //HbaseDemo.addRecord(tablename,"zkb","course","","90");
	    //HbaseDemo.addRecord(tablename,"zkb","course","math","97");
	    //HbaseDemo.addRecord(tablename,"zkb","course","art","87");

	    //HbaseDemo.addRecord(tablename,"baoniu","grade","","4");
	    //HbaseDemo.addRecord(tablename,"baoniu","course","math","89");

	    //System.out.println("===========get one record========");
	    //HbaseDemo.getOneRecord(tablename, "zkb");

	    //System.out.println("===========show all record========");
	    //HbaseDemo.getAllRecord(tablename);

            for( int i =0; i<10000; i++ )
{
		HbaseDemo.addRecord(tablename,"row"+String.format("%04d",i),"course","col","cell"+String.format("%010d",(new java.util.Random()).nextInt(100000000)));
if( i % 1000 ==0)
	System.out.println(i+" items");
}
	    //System.out.println("===========del one record========");
	    //HbaseDemo.delRecord(tablename, "baoniu");
	    //HbaseDemo.getAllRecord(tablename);

	    //System.out.println("===========show all record========");
	    //HbaseDemo.getAllRecord(tablename);
	} catch (Exception e) {
	    e.printStackTrace();
	}
    }
}
