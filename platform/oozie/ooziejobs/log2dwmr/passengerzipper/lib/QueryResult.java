// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Sat Jan 11 23:29:05 CST 2014
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

public class QueryResult extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private Long statId;
  public Long get_statId() {
    return statId;
  }
  public void set_statId(Long statId) {
    this.statId = statId;
  }
  public QueryResult with_statId(Long statId) {
    this.statId = statId;
    return this;
  }
  private java.sql.Date beginDate;
  public java.sql.Date get_beginDate() {
    return beginDate;
  }
  public void set_beginDate(java.sql.Date beginDate) {
    this.beginDate = beginDate;
  }
  public QueryResult with_beginDate(java.sql.Date beginDate) {
    this.beginDate = beginDate;
    return this;
  }
  private java.sql.Date endDate;
  public java.sql.Date get_endDate() {
    return endDate;
  }
  public void set_endDate(java.sql.Date endDate) {
    this.endDate = endDate;
  }
  public QueryResult with_endDate(java.sql.Date endDate) {
    this.endDate = endDate;
    return this;
  }
  private Integer channel;
  public Integer get_channel() {
    return channel;
  }
  public void set_channel(Integer channel) {
    this.channel = channel;
  }
  public QueryResult with_channel(Integer channel) {
    this.channel = channel;
    return this;
  }
  private Integer area;
  public Integer get_area() {
    return area;
  }
  public void set_area(Integer area) {
    this.area = area;
  }
  public QueryResult with_area(Integer area) {
    this.area = area;
    return this;
  }
  private Long pid;
  public Long get_pid() {
    return pid;
  }
  public void set_pid(Long pid) {
    this.pid = pid;
  }
  public QueryResult with_pid(Long pid) {
    this.pid = pid;
    return this;
  }
  private Integer status;
  public Integer get_status() {
    return status;
  }
  public void set_status(Integer status) {
    this.status = status;
  }
  public QueryResult with_status(Integer status) {
    this.status = status;
    return this;
  }
  private Integer totalOrderCallCnt;
  public Integer get_totalOrderCallCnt() {
    return totalOrderCallCnt;
  }
  public void set_totalOrderCallCnt(Integer totalOrderCallCnt) {
    this.totalOrderCallCnt = totalOrderCallCnt;
  }
  public QueryResult with_totalOrderCallCnt(Integer totalOrderCallCnt) {
    this.totalOrderCallCnt = totalOrderCallCnt;
    return this;
  }
  private Integer totalOrderCnt;
  public Integer get_totalOrderCnt() {
    return totalOrderCnt;
  }
  public void set_totalOrderCnt(Integer totalOrderCnt) {
    this.totalOrderCnt = totalOrderCnt;
  }
  public QueryResult with_totalOrderCnt(Integer totalOrderCnt) {
    this.totalOrderCnt = totalOrderCnt;
    return this;
  }
  private Integer totalSuccOrderCnt;
  public Integer get_totalSuccOrderCnt() {
    return totalSuccOrderCnt;
  }
  public void set_totalSuccOrderCnt(Integer totalSuccOrderCnt) {
    this.totalSuccOrderCnt = totalSuccOrderCnt;
  }
  public QueryResult with_totalSuccOrderCnt(Integer totalSuccOrderCnt) {
    this.totalSuccOrderCnt = totalSuccOrderCnt;
    return this;
  }
  private Integer totalComplaintCnt;
  public Integer get_totalComplaintCnt() {
    return totalComplaintCnt;
  }
  public void set_totalComplaintCnt(Integer totalComplaintCnt) {
    this.totalComplaintCnt = totalComplaintCnt;
  }
  public QueryResult with_totalComplaintCnt(Integer totalComplaintCnt) {
    this.totalComplaintCnt = totalComplaintCnt;
    return this;
  }
  private Integer totalForbidCnt;
  public Integer get_totalForbidCnt() {
    return totalForbidCnt;
  }
  public void set_totalForbidCnt(Integer totalForbidCnt) {
    this.totalForbidCnt = totalForbidCnt;
  }
  public QueryResult with_totalForbidCnt(Integer totalForbidCnt) {
    this.totalForbidCnt = totalForbidCnt;
    return this;
  }
  private String regTime;
  public String get_regTime() {
    return regTime;
  }
  public void set_regTime(String regTime) {
    this.regTime = regTime;
  }
  public QueryResult with_regTime(String regTime) {
    this.regTime = regTime;
    return this;
  }
  private Integer orderCallCnt;
  public Integer get_orderCallCnt() {
    return orderCallCnt;
  }
  public void set_orderCallCnt(Integer orderCallCnt) {
    this.orderCallCnt = orderCallCnt;
  }
  public QueryResult with_orderCallCnt(Integer orderCallCnt) {
    this.orderCallCnt = orderCallCnt;
    return this;
  }
  private Integer orderCnt;
  public Integer get_orderCnt() {
    return orderCnt;
  }
  public void set_orderCnt(Integer orderCnt) {
    this.orderCnt = orderCnt;
  }
  public QueryResult with_orderCnt(Integer orderCnt) {
    this.orderCnt = orderCnt;
    return this;
  }
  private Integer succOrderCnt;
  public Integer get_succOrderCnt() {
    return succOrderCnt;
  }
  public void set_succOrderCnt(Integer succOrderCnt) {
    this.succOrderCnt = succOrderCnt;
  }
  public QueryResult with_succOrderCnt(Integer succOrderCnt) {
    this.succOrderCnt = succOrderCnt;
    return this;
  }
  private Integer complaintCnt;
  public Integer get_complaintCnt() {
    return complaintCnt;
  }
  public void set_complaintCnt(Integer complaintCnt) {
    this.complaintCnt = complaintCnt;
  }
  public QueryResult with_complaintCnt(Integer complaintCnt) {
    this.complaintCnt = complaintCnt;
    return this;
  }
  private Integer forbidCnt;
  public Integer get_forbidCnt() {
    return forbidCnt;
  }
  public void set_forbidCnt(Integer forbidCnt) {
    this.forbidCnt = forbidCnt;
  }
  public QueryResult with_forbidCnt(Integer forbidCnt) {
    this.forbidCnt = forbidCnt;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof QueryResult)) {
      return false;
    }
    QueryResult that = (QueryResult) o;
    boolean equal = true;
    equal = equal && (this.statId == null ? that.statId == null : this.statId.equals(that.statId));
    equal = equal && (this.beginDate == null ? that.beginDate == null : this.beginDate.equals(that.beginDate));
    equal = equal && (this.endDate == null ? that.endDate == null : this.endDate.equals(that.endDate));
    equal = equal && (this.channel == null ? that.channel == null : this.channel.equals(that.channel));
    equal = equal && (this.area == null ? that.area == null : this.area.equals(that.area));
    equal = equal && (this.pid == null ? that.pid == null : this.pid.equals(that.pid));
    equal = equal && (this.status == null ? that.status == null : this.status.equals(that.status));
    equal = equal && (this.totalOrderCallCnt == null ? that.totalOrderCallCnt == null : this.totalOrderCallCnt.equals(that.totalOrderCallCnt));
    equal = equal && (this.totalOrderCnt == null ? that.totalOrderCnt == null : this.totalOrderCnt.equals(that.totalOrderCnt));
    equal = equal && (this.totalSuccOrderCnt == null ? that.totalSuccOrderCnt == null : this.totalSuccOrderCnt.equals(that.totalSuccOrderCnt));
    equal = equal && (this.totalComplaintCnt == null ? that.totalComplaintCnt == null : this.totalComplaintCnt.equals(that.totalComplaintCnt));
    equal = equal && (this.totalForbidCnt == null ? that.totalForbidCnt == null : this.totalForbidCnt.equals(that.totalForbidCnt));
    equal = equal && (this.regTime == null ? that.regTime == null : this.regTime.equals(that.regTime));
    equal = equal && (this.orderCallCnt == null ? that.orderCallCnt == null : this.orderCallCnt.equals(that.orderCallCnt));
    equal = equal && (this.orderCnt == null ? that.orderCnt == null : this.orderCnt.equals(that.orderCnt));
    equal = equal && (this.succOrderCnt == null ? that.succOrderCnt == null : this.succOrderCnt.equals(that.succOrderCnt));
    equal = equal && (this.complaintCnt == null ? that.complaintCnt == null : this.complaintCnt.equals(that.complaintCnt));
    equal = equal && (this.forbidCnt == null ? that.forbidCnt == null : this.forbidCnt.equals(that.forbidCnt));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.statId = JdbcWritableBridge.readLong(1, __dbResults);
    this.beginDate = JdbcWritableBridge.readDate(2, __dbResults);
    this.endDate = JdbcWritableBridge.readDate(3, __dbResults);
    this.channel = JdbcWritableBridge.readInteger(4, __dbResults);
    this.area = JdbcWritableBridge.readInteger(5, __dbResults);
    this.pid = JdbcWritableBridge.readLong(6, __dbResults);
    this.status = JdbcWritableBridge.readInteger(7, __dbResults);
    this.totalOrderCallCnt = JdbcWritableBridge.readInteger(8, __dbResults);
    this.totalOrderCnt = JdbcWritableBridge.readInteger(9, __dbResults);
    this.totalSuccOrderCnt = JdbcWritableBridge.readInteger(10, __dbResults);
    this.totalComplaintCnt = JdbcWritableBridge.readInteger(11, __dbResults);
    this.totalForbidCnt = JdbcWritableBridge.readInteger(12, __dbResults);
    this.regTime = JdbcWritableBridge.readString(13, __dbResults);
    this.orderCallCnt = JdbcWritableBridge.readInteger(14, __dbResults);
    this.orderCnt = JdbcWritableBridge.readInteger(15, __dbResults);
    this.succOrderCnt = JdbcWritableBridge.readInteger(16, __dbResults);
    this.complaintCnt = JdbcWritableBridge.readInteger(17, __dbResults);
    this.forbidCnt = JdbcWritableBridge.readInteger(18, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(statId, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeDate(beginDate, 2 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeDate(endDate, 3 + __off, 91, __dbStmt);
    JdbcWritableBridge.writeInteger(channel, 4 + __off, 5, __dbStmt);
    JdbcWritableBridge.writeInteger(area, 5 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeLong(pid, 6 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeInteger(status, 7 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(totalOrderCallCnt, 8 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(totalOrderCnt, 9 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(totalSuccOrderCnt, 10 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(totalComplaintCnt, 11 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(totalForbidCnt, 12 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(regTime, 13 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(orderCallCnt, 14 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(orderCnt, 15 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(succOrderCnt, 16 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(complaintCnt, 17 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(forbidCnt, 18 + __off, 4, __dbStmt);
    return 18;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.statId = null;
    } else {
    this.statId = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.beginDate = null;
    } else {
    this.beginDate = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.endDate = null;
    } else {
    this.endDate = new Date(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.channel = null;
    } else {
    this.channel = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.area = null;
    } else {
    this.area = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.pid = null;
    } else {
    this.pid = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.status = null;
    } else {
    this.status = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.totalOrderCallCnt = null;
    } else {
    this.totalOrderCallCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.totalOrderCnt = null;
    } else {
    this.totalOrderCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.totalSuccOrderCnt = null;
    } else {
    this.totalSuccOrderCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.totalComplaintCnt = null;
    } else {
    this.totalComplaintCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.totalForbidCnt = null;
    } else {
    this.totalForbidCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.regTime = null;
    } else {
    this.regTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.orderCallCnt = null;
    } else {
    this.orderCallCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.orderCnt = null;
    } else {
    this.orderCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.succOrderCnt = null;
    } else {
    this.succOrderCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.complaintCnt = null;
    } else {
    this.complaintCnt = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.forbidCnt = null;
    } else {
    this.forbidCnt = Integer.valueOf(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.statId) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.statId);
    }
    if (null == this.beginDate) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.beginDate.getTime());
    }
    if (null == this.endDate) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.endDate.getTime());
    }
    if (null == this.channel) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.channel);
    }
    if (null == this.area) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.area);
    }
    if (null == this.pid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.pid);
    }
    if (null == this.status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.status);
    }
    if (null == this.totalOrderCallCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.totalOrderCallCnt);
    }
    if (null == this.totalOrderCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.totalOrderCnt);
    }
    if (null == this.totalSuccOrderCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.totalSuccOrderCnt);
    }
    if (null == this.totalComplaintCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.totalComplaintCnt);
    }
    if (null == this.totalForbidCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.totalForbidCnt);
    }
    if (null == this.regTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, regTime);
    }
    if (null == this.orderCallCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.orderCallCnt);
    }
    if (null == this.orderCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.orderCnt);
    }
    if (null == this.succOrderCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.succOrderCnt);
    }
    if (null == this.complaintCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.complaintCnt);
    }
    if (null == this.forbidCnt) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.forbidCnt);
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
    __sb.append(FieldFormatter.escapeAndEnclose(statId==null?"":"" + statId, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(beginDate==null?"":"" + beginDate, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(endDate==null?"":"" + endDate, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel==null?"":"" + channel, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(area==null?"":"" + area, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pid==null?"":"" + pid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(status==null?"":"" + status, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(totalOrderCallCnt==null?"":"" + totalOrderCallCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(totalOrderCnt==null?"":"" + totalOrderCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(totalSuccOrderCnt==null?"":"" + totalSuccOrderCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(totalComplaintCnt==null?"":"" + totalComplaintCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(totalForbidCnt==null?"":"" + totalForbidCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(regTime==null?"":regTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(orderCallCnt==null?"":"" + orderCallCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(orderCnt==null?"":"" + orderCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(succOrderCnt==null?"":"" + succOrderCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(complaintCnt==null?"":"" + complaintCnt, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(forbidCnt==null?"":"" + forbidCnt, delimiters));
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.statId = null; } else {
      this.statId = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.beginDate = null; } else {
      this.beginDate = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.endDate = null; } else {
      this.endDate = java.sql.Date.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.channel = null; } else {
      this.channel = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.area = null; } else {
      this.area = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pid = null; } else {
      this.pid = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.status = null; } else {
      this.status = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.totalOrderCallCnt = null; } else {
      this.totalOrderCallCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.totalOrderCnt = null; } else {
      this.totalOrderCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.totalSuccOrderCnt = null; } else {
      this.totalSuccOrderCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.totalComplaintCnt = null; } else {
      this.totalComplaintCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.totalForbidCnt = null; } else {
      this.totalForbidCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.regTime = null; } else {
      this.regTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.orderCallCnt = null; } else {
      this.orderCallCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.orderCnt = null; } else {
      this.orderCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.succOrderCnt = null; } else {
      this.succOrderCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.complaintCnt = null; } else {
      this.complaintCnt = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.forbidCnt = null; } else {
      this.forbidCnt = Integer.valueOf(__cur_str);
    }

  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    o.beginDate = (o.beginDate != null) ? (java.sql.Date) o.beginDate.clone() : null;
    o.endDate = (o.endDate != null) ? (java.sql.Date) o.endDate.clone() : null;
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("statId", this.statId);
    __sqoop$field_map.put("beginDate", this.beginDate);
    __sqoop$field_map.put("endDate", this.endDate);
    __sqoop$field_map.put("channel", this.channel);
    __sqoop$field_map.put("area", this.area);
    __sqoop$field_map.put("pid", this.pid);
    __sqoop$field_map.put("status", this.status);
    __sqoop$field_map.put("totalOrderCallCnt", this.totalOrderCallCnt);
    __sqoop$field_map.put("totalOrderCnt", this.totalOrderCnt);
    __sqoop$field_map.put("totalSuccOrderCnt", this.totalSuccOrderCnt);
    __sqoop$field_map.put("totalComplaintCnt", this.totalComplaintCnt);
    __sqoop$field_map.put("totalForbidCnt", this.totalForbidCnt);
    __sqoop$field_map.put("regTime", this.regTime);
    __sqoop$field_map.put("orderCallCnt", this.orderCallCnt);
    __sqoop$field_map.put("orderCnt", this.orderCnt);
    __sqoop$field_map.put("succOrderCnt", this.succOrderCnt);
    __sqoop$field_map.put("complaintCnt", this.complaintCnt);
    __sqoop$field_map.put("forbidCnt", this.forbidCnt);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("statId".equals(__fieldName)) {
      this.statId = (Long) __fieldVal;
    }
    else    if ("beginDate".equals(__fieldName)) {
      this.beginDate = (java.sql.Date) __fieldVal;
    }
    else    if ("endDate".equals(__fieldName)) {
      this.endDate = (java.sql.Date) __fieldVal;
    }
    else    if ("channel".equals(__fieldName)) {
      this.channel = (Integer) __fieldVal;
    }
    else    if ("area".equals(__fieldName)) {
      this.area = (Integer) __fieldVal;
    }
    else    if ("pid".equals(__fieldName)) {
      this.pid = (Long) __fieldVal;
    }
    else    if ("status".equals(__fieldName)) {
      this.status = (Integer) __fieldVal;
    }
    else    if ("totalOrderCallCnt".equals(__fieldName)) {
      this.totalOrderCallCnt = (Integer) __fieldVal;
    }
    else    if ("totalOrderCnt".equals(__fieldName)) {
      this.totalOrderCnt = (Integer) __fieldVal;
    }
    else    if ("totalSuccOrderCnt".equals(__fieldName)) {
      this.totalSuccOrderCnt = (Integer) __fieldVal;
    }
    else    if ("totalComplaintCnt".equals(__fieldName)) {
      this.totalComplaintCnt = (Integer) __fieldVal;
    }
    else    if ("totalForbidCnt".equals(__fieldName)) {
      this.totalForbidCnt = (Integer) __fieldVal;
    }
    else    if ("regTime".equals(__fieldName)) {
      this.regTime = (String) __fieldVal;
    }
    else    if ("orderCallCnt".equals(__fieldName)) {
      this.orderCallCnt = (Integer) __fieldVal;
    }
    else    if ("orderCnt".equals(__fieldName)) {
      this.orderCnt = (Integer) __fieldVal;
    }
    else    if ("succOrderCnt".equals(__fieldName)) {
      this.succOrderCnt = (Integer) __fieldVal;
    }
    else    if ("complaintCnt".equals(__fieldName)) {
      this.complaintCnt = (Integer) __fieldVal;
    }
    else    if ("forbidCnt".equals(__fieldName)) {
      this.forbidCnt = (Integer) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
