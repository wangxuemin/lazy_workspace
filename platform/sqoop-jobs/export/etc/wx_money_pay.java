// ORM class for table 'wx_money_pay'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Wed Mar 12 13:56:48 CST 2014
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class wx_money_pay extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private java.sql.Date statDate;
  public java.sql.Date get_statDate() {
    return statDate;
  }
  public void set_statDate(java.sql.Date statDate) {
    this.statDate = statDate;
  }
  public wx_money_pay with_statDate(java.sql.Date statDate) {
    this.statDate = statDate;
    return this;
  }
  private Integer area;
  public Integer get_area() {
    return area;
  }
  public void set_area(Integer area) {
    this.area = area;
  }
  public wx_money_pay with_area(Integer area) {
    this.area = area;
    return this;
  }
  private Integer channel;
  public Integer get_channel() {
    return channel;
  }
  public void set_channel(Integer channel) {
    this.channel = channel;
  }
  public wx_money_pay with_channel(Integer channel) {
    this.channel = channel;
    return this;
  }
  private Float wx_allowance;
  public Float get_wx_allowance() {
    return wx_allowance;
  }
  public void set_wx_allowance(Float wx_allowance) {
    this.wx_allowance = wx_allowance;
  }
  public wx_money_pay with_wx_allowance(Float wx_allowance) {
    this.wx_allowance = wx_allowance;
    return this;
  }
  private Float passenger_pay;
  public Float get_passenger_pay() {
    return passenger_pay;
  }
  public void set_passenger_pay(Float passenger_pay) {
    this.passenger_pay = passenger_pay;
  }
  public wx_money_pay with_passenger_pay(Float passenger_pay) {
    this.passenger_pay = passenger_pay;
    return this;
  }
  private Integer lj_order_num;
  public Integer get_lj_order_num() {
    return lj_order_num;
  }
  public void set_lj_order_num(Integer lj_order_num) {
    this.lj_order_num = lj_order_num;
  }
  public wx_money_pay with_lj_order_num(Integer lj_order_num) {
    this.lj_order_num = lj_order_num;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof wx_money_pay)) {
      return false;
    }
    wx_money_pay that = (wx_money_pay) o;
    boolean equal = true;
    equal = equal && (this.statDate == null ? that.statDate == null : this.statDate.equals(that.statDate));
    equal = equal && (this.area == null ? that.area == null : this.area.equals(that.area));
    equal = equal && (this.channel == null ? that.channel == null : this.channel.equals(that.channel));
    equal = equal && (this.wx_allowance == null ? that.wx_allowance == null : this.wx_allowance.equals(that.wx_allowance));
    equal = equal && (this.passenger_pay == null ? that.passenger_pay == null : this.passenger_pay.equals(that.passenger_pay));
    equal = equal && (this.lj_order_num == null ? that.lj_order_num == null : this.lj_order_num.equals(that.lj_order_num));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.statDate = JdbcWritableBridge.readDate(1, __dbResults);
    this.area = JdbcWritableBridge.readInteger(2, __dbResults);
    this.channel = JdbcWritableBridge.readInteger(3, __dbResults);
    this.wx_allowance = JdbcWritableBridge.readFloat(4, __dbResults);
    this.passenger_pay = JdbcWritableBridge.readFloat(5, __dbResults);
    this.lj_order_num = JdbcWritableBridge.readInteger(6, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeDate(statDate, 1 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeInteger(area, 2 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(channel, 3 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeFloat(wx_allowance, 4 + __off, 7, __dbStmt);
    JdbcWritableBridge.writeFloat(passenger_pay, 5 + __off, 7, __dbStmt);
    JdbcWritableBridge.writeInteger(lj_order_num, 6 + __off, 4, __dbStmt);
    return 6;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.statDate = null;
    } else {
    this.statDate = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.area = null;
    } else {
    this.area = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.channel = null;
    } else {
    this.channel = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.wx_allowance = null;
    } else {
    this.wx_allowance = Float.valueOf(__dataIn.readFloat());
    }
    if (__dataIn.readBoolean()) { 
        this.passenger_pay = null;
    } else {
    this.passenger_pay = Float.valueOf(__dataIn.readFloat());
    }
    if (__dataIn.readBoolean()) { 
        this.lj_order_num = null;
    } else {
    this.lj_order_num = Integer.valueOf(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.statDate) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.statDate.getTime());
    }
    if (null == this.area) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.area);
    }
    if (null == this.channel) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.channel);
    }
    if (null == this.wx_allowance) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeFloat(this.wx_allowance);
    }
    if (null == this.passenger_pay) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeFloat(this.passenger_pay);
    }
    if (null == this.lj_order_num) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.lj_order_num);
    }
  }
  private final DelimiterSet __outputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(statDate==null?"null":"" + statDate, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(area==null?"null":"" + area, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel==null?"null":"" + channel, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(wx_allowance==null?"null":"" + wx_allowance, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(passenger_pay==null?"null":"" + passenger_pay, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(lj_order_num==null?"null":"" + lj_order_num, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  private final DelimiterSet __inputDelimiters = new DelimiterSet((char) 1, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str;
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.statDate = null; } else {
      this.statDate = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.area = null; } else {
      this.area = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.channel = null; } else {
      this.channel = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.wx_allowance = null; } else {
      this.wx_allowance = Float.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.passenger_pay = null; } else {
      this.passenger_pay = Float.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.lj_order_num = null; } else {
      this.lj_order_num = Integer.valueOf(__cur_str);
    }

  }

  public Object clone() throws CloneNotSupportedException {
    wx_money_pay o = (wx_money_pay) super.clone();
    o.statDate = (o.statDate != null) ? (java.sql.Date) o.statDate.clone() : null;
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("statDate", this.statDate);
    __sqoop$field_map.put("area", this.area);
    __sqoop$field_map.put("channel", this.channel);
    __sqoop$field_map.put("wx_allowance", this.wx_allowance);
    __sqoop$field_map.put("passenger_pay", this.passenger_pay);
    __sqoop$field_map.put("lj_order_num", this.lj_order_num);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("statDate".equals(__fieldName)) {
      this.statDate = (java.sql.Date) __fieldVal;
    }
    else    if ("area".equals(__fieldName)) {
      this.area = (Integer) __fieldVal;
    }
    else    if ("channel".equals(__fieldName)) {
      this.channel = (Integer) __fieldVal;
    }
    else    if ("wx_allowance".equals(__fieldName)) {
      this.wx_allowance = (Float) __fieldVal;
    }
    else    if ("passenger_pay".equals(__fieldName)) {
      this.passenger_pay = (Float) __fieldVal;
    }
    else    if ("lj_order_num".equals(__fieldName)) {
      this.lj_order_num = (Integer) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
