// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Tue Jan 07 17:21:27 CST 2014
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
  private Long cmtid;
  public Long get_cmtid() {
    return cmtid;
  }
  public void set_cmtid(Long cmtid) {
    this.cmtid = cmtid;
  }
  public QueryResult with_cmtid(Long cmtid) {
    this.cmtid = cmtid;
    return this;
  }
  private Long oid;
  public Long get_oid() {
    return oid;
  }
  public void set_oid(Long oid) {
    this.oid = oid;
  }
  public QueryResult with_oid(Long oid) {
    this.oid = oid;
    return this;
  }
  private Integer ordertype;
  public Integer get_ordertype() {
    return ordertype;
  }
  public void set_ordertype(Integer ordertype) {
    this.ordertype = ordertype;
  }
  public QueryResult with_ordertype(Integer ordertype) {
    this.ordertype = ordertype;
    return this;
  }
  private String pphone;
  public String get_pphone() {
    return pphone;
  }
  public void set_pphone(String pphone) {
    this.pphone = pphone;
  }
  public QueryResult with_pphone(String pphone) {
    this.pphone = pphone;
    return this;
  }
  private String dphone;
  public String get_dphone() {
    return dphone;
  }
  public void set_dphone(String dphone) {
    this.dphone = dphone;
  }
  public QueryResult with_dphone(String dphone) {
    this.dphone = dphone;
    return this;
  }
  private String pcontent;
  public String get_pcontent() {
    return pcontent;
  }
  public void set_pcontent(String pcontent) {
    this.pcontent = pcontent;
  }
  public QueryResult with_pcontent(String pcontent) {
    this.pcontent = pcontent;
    return this;
  }
  private Integer pcommenttype;
  public Integer get_pcommenttype() {
    return pcommenttype;
  }
  public void set_pcommenttype(Integer pcommenttype) {
    this.pcommenttype = pcommenttype;
  }
  public QueryResult with_pcommenttype(Integer pcommenttype) {
    this.pcommenttype = pcommenttype;
    return this;
  }
  private String pctime;
  public String get_pctime() {
    return pctime;
  }
  public void set_pctime(String pctime) {
    this.pctime = pctime;
  }
  public QueryResult with_pctime(String pctime) {
    this.pctime = pctime;
    return this;
  }
  private String pcomplaint;
  public String get_pcomplaint() {
    return pcomplaint;
  }
  public void set_pcomplaint(String pcomplaint) {
    this.pcomplaint = pcomplaint;
  }
  public QueryResult with_pcomplaint(String pcomplaint) {
    this.pcomplaint = pcomplaint;
    return this;
  }
  private Integer pcomplainttype;
  public Integer get_pcomplainttype() {
    return pcomplainttype;
  }
  public void set_pcomplainttype(Integer pcomplainttype) {
    this.pcomplainttype = pcomplainttype;
  }
  public QueryResult with_pcomplainttype(Integer pcomplainttype) {
    this.pcomplainttype = pcomplainttype;
    return this;
  }
  private String ptime;
  public String get_ptime() {
    return ptime;
  }
  public void set_ptime(String ptime) {
    this.ptime = ptime;
  }
  public QueryResult with_ptime(String ptime) {
    this.ptime = ptime;
    return this;
  }
  private Integer pstatus;
  public Integer get_pstatus() {
    return pstatus;
  }
  public void set_pstatus(Integer pstatus) {
    this.pstatus = pstatus;
  }
  public QueryResult with_pstatus(Integer pstatus) {
    this.pstatus = pstatus;
    return this;
  }
  private Integer dcommenttype;
  public Integer get_dcommenttype() {
    return dcommenttype;
  }
  public void set_dcommenttype(Integer dcommenttype) {
    this.dcommenttype = dcommenttype;
  }
  public QueryResult with_dcommenttype(Integer dcommenttype) {
    this.dcommenttype = dcommenttype;
    return this;
  }
  private String dcontent;
  public String get_dcontent() {
    return dcontent;
  }
  public void set_dcontent(String dcontent) {
    this.dcontent = dcontent;
  }
  public QueryResult with_dcontent(String dcontent) {
    this.dcontent = dcontent;
    return this;
  }
  private String dcomplaint;
  public String get_dcomplaint() {
    return dcomplaint;
  }
  public void set_dcomplaint(String dcomplaint) {
    this.dcomplaint = dcomplaint;
  }
  public QueryResult with_dcomplaint(String dcomplaint) {
    this.dcomplaint = dcomplaint;
    return this;
  }
  private Integer dcomplainttype;
  public Integer get_dcomplainttype() {
    return dcomplainttype;
  }
  public void set_dcomplainttype(Integer dcomplainttype) {
    this.dcomplainttype = dcomplainttype;
  }
  public QueryResult with_dcomplainttype(Integer dcomplainttype) {
    this.dcomplainttype = dcomplainttype;
    return this;
  }
  private String dtime;
  public String get_dtime() {
    return dtime;
  }
  public void set_dtime(String dtime) {
    this.dtime = dtime;
  }
  public QueryResult with_dtime(String dtime) {
    this.dtime = dtime;
    return this;
  }
  private Integer dstatus;
  public Integer get_dstatus() {
    return dstatus;
  }
  public void set_dstatus(Integer dstatus) {
    this.dstatus = dstatus;
  }
  public QueryResult with_dstatus(Integer dstatus) {
    this.dstatus = dstatus;
    return this;
  }
  private Integer credibility;
  public Integer get_credibility() {
    return credibility;
  }
  public void set_credibility(Integer credibility) {
    this.credibility = credibility;
  }
  public QueryResult with_credibility(Integer credibility) {
    this.credibility = credibility;
    return this;
  }
  private Integer neatness;
  public Integer get_neatness() {
    return neatness;
  }
  public void set_neatness(Integer neatness) {
    this.neatness = neatness;
  }
  public QueryResult with_neatness(Integer neatness) {
    this.neatness = neatness;
    return this;
  }
  private Integer punctual;
  public Integer get_punctual() {
    return punctual;
  }
  public void set_punctual(Integer punctual) {
    this.punctual = punctual;
  }
  public QueryResult with_punctual(Integer punctual) {
    this.punctual = punctual;
    return this;
  }
  private String remark;
  public String get_remark() {
    return remark;
  }
  public void set_remark(String remark) {
    this.remark = remark;
  }
  public QueryResult with_remark(String remark) {
    this.remark = remark;
    return this;
  }
  private String opname;
  public String get_opname() {
    return opname;
  }
  public void set_opname(String opname) {
    this.opname = opname;
  }
  public QueryResult with_opname(String opname) {
    this.opname = opname;
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
  private String createtime;
  public String get_createtime() {
    return createtime;
  }
  public void set_createtime(String createtime) {
    this.createtime = createtime;
  }
  public QueryResult with_createtime(String createtime) {
    this.createtime = createtime;
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
    equal = equal && (this.cmtid == null ? that.cmtid == null : this.cmtid.equals(that.cmtid));
    equal = equal && (this.oid == null ? that.oid == null : this.oid.equals(that.oid));
    equal = equal && (this.ordertype == null ? that.ordertype == null : this.ordertype.equals(that.ordertype));
    equal = equal && (this.pphone == null ? that.pphone == null : this.pphone.equals(that.pphone));
    equal = equal && (this.dphone == null ? that.dphone == null : this.dphone.equals(that.dphone));
    equal = equal && (this.pcontent == null ? that.pcontent == null : this.pcontent.equals(that.pcontent));
    equal = equal && (this.pcommenttype == null ? that.pcommenttype == null : this.pcommenttype.equals(that.pcommenttype));
    equal = equal && (this.pctime == null ? that.pctime == null : this.pctime.equals(that.pctime));
    equal = equal && (this.pcomplaint == null ? that.pcomplaint == null : this.pcomplaint.equals(that.pcomplaint));
    equal = equal && (this.pcomplainttype == null ? that.pcomplainttype == null : this.pcomplainttype.equals(that.pcomplainttype));
    equal = equal && (this.ptime == null ? that.ptime == null : this.ptime.equals(that.ptime));
    equal = equal && (this.pstatus == null ? that.pstatus == null : this.pstatus.equals(that.pstatus));
    equal = equal && (this.dcommenttype == null ? that.dcommenttype == null : this.dcommenttype.equals(that.dcommenttype));
    equal = equal && (this.dcontent == null ? that.dcontent == null : this.dcontent.equals(that.dcontent));
    equal = equal && (this.dcomplaint == null ? that.dcomplaint == null : this.dcomplaint.equals(that.dcomplaint));
    equal = equal && (this.dcomplainttype == null ? that.dcomplainttype == null : this.dcomplainttype.equals(that.dcomplainttype));
    equal = equal && (this.dtime == null ? that.dtime == null : this.dtime.equals(that.dtime));
    equal = equal && (this.dstatus == null ? that.dstatus == null : this.dstatus.equals(that.dstatus));
    equal = equal && (this.credibility == null ? that.credibility == null : this.credibility.equals(that.credibility));
    equal = equal && (this.neatness == null ? that.neatness == null : this.neatness.equals(that.neatness));
    equal = equal && (this.punctual == null ? that.punctual == null : this.punctual.equals(that.punctual));
    equal = equal && (this.remark == null ? that.remark == null : this.remark.equals(that.remark));
    equal = equal && (this.opname == null ? that.opname == null : this.opname.equals(that.opname));
    equal = equal && (this.channel == null ? that.channel == null : this.channel.equals(that.channel));
    equal = equal && (this.area == null ? that.area == null : this.area.equals(that.area));
    equal = equal && (this.createtime == null ? that.createtime == null : this.createtime.equals(that.createtime));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.cmtid = JdbcWritableBridge.readLong(1, __dbResults);
    this.oid = JdbcWritableBridge.readLong(2, __dbResults);
    this.ordertype = JdbcWritableBridge.readInteger(3, __dbResults);
    this.pphone = JdbcWritableBridge.readString(4, __dbResults);
    this.dphone = JdbcWritableBridge.readString(5, __dbResults);
    this.pcontent = JdbcWritableBridge.readString(6, __dbResults);
    this.pcommenttype = JdbcWritableBridge.readInteger(7, __dbResults);
    this.pctime = JdbcWritableBridge.readString(8, __dbResults);
    this.pcomplaint = JdbcWritableBridge.readString(9, __dbResults);
    this.pcomplainttype = JdbcWritableBridge.readInteger(10, __dbResults);
    this.ptime = JdbcWritableBridge.readString(11, __dbResults);
    this.pstatus = JdbcWritableBridge.readInteger(12, __dbResults);
    this.dcommenttype = JdbcWritableBridge.readInteger(13, __dbResults);
    this.dcontent = JdbcWritableBridge.readString(14, __dbResults);
    this.dcomplaint = JdbcWritableBridge.readString(15, __dbResults);
    this.dcomplainttype = JdbcWritableBridge.readInteger(16, __dbResults);
    this.dtime = JdbcWritableBridge.readString(17, __dbResults);
    this.dstatus = JdbcWritableBridge.readInteger(18, __dbResults);
    this.credibility = JdbcWritableBridge.readInteger(19, __dbResults);
    this.neatness = JdbcWritableBridge.readInteger(20, __dbResults);
    this.punctual = JdbcWritableBridge.readInteger(21, __dbResults);
    this.remark = JdbcWritableBridge.readString(22, __dbResults);
    this.opname = JdbcWritableBridge.readString(23, __dbResults);
    this.channel = JdbcWritableBridge.readInteger(24, __dbResults);
    this.area = JdbcWritableBridge.readInteger(25, __dbResults);
    this.createtime = JdbcWritableBridge.readString(26, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(cmtid, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeLong(oid, 2 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeInteger(ordertype, 3 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(pphone, 4 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(dphone, 5 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(pcontent, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(pcommenttype, 7 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(pctime, 8 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(pcomplaint, 9 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(pcomplainttype, 10 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(ptime, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(pstatus, 12 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(dcommenttype, 13 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(dcontent, 14 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(dcomplaint, 15 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(dcomplainttype, 16 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(dtime, 17 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(dstatus, 18 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(credibility, 19 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(neatness, 20 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(punctual, 21 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(remark, 22 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(opname, 23 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(channel, 24 + __off, 5, __dbStmt);
    JdbcWritableBridge.writeInteger(area, 25 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(createtime, 26 + __off, 12, __dbStmt);
    return 26;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.cmtid = null;
    } else {
    this.cmtid = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.oid = null;
    } else {
    this.oid = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.ordertype = null;
    } else {
    this.ordertype = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.pphone = null;
    } else {
    this.pphone = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dphone = null;
    } else {
    this.dphone = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pcontent = null;
    } else {
    this.pcontent = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pcommenttype = null;
    } else {
    this.pcommenttype = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.pctime = null;
    } else {
    this.pctime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pcomplaint = null;
    } else {
    this.pcomplaint = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pcomplainttype = null;
    } else {
    this.pcomplainttype = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.ptime = null;
    } else {
    this.ptime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pstatus = null;
    } else {
    this.pstatus = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.dcommenttype = null;
    } else {
    this.dcommenttype = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.dcontent = null;
    } else {
    this.dcontent = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dcomplaint = null;
    } else {
    this.dcomplaint = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dcomplainttype = null;
    } else {
    this.dcomplainttype = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.dtime = null;
    } else {
    this.dtime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dstatus = null;
    } else {
    this.dstatus = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.credibility = null;
    } else {
    this.credibility = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.neatness = null;
    } else {
    this.neatness = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.punctual = null;
    } else {
    this.punctual = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.remark = null;
    } else {
    this.remark = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.opname = null;
    } else {
    this.opname = Text.readString(__dataIn);
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
        this.createtime = null;
    } else {
    this.createtime = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.cmtid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.cmtid);
    }
    if (null == this.oid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.oid);
    }
    if (null == this.ordertype) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.ordertype);
    }
    if (null == this.pphone) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pphone);
    }
    if (null == this.dphone) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dphone);
    }
    if (null == this.pcontent) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pcontent);
    }
    if (null == this.pcommenttype) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.pcommenttype);
    }
    if (null == this.pctime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pctime);
    }
    if (null == this.pcomplaint) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pcomplaint);
    }
    if (null == this.pcomplainttype) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.pcomplainttype);
    }
    if (null == this.ptime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, ptime);
    }
    if (null == this.pstatus) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.pstatus);
    }
    if (null == this.dcommenttype) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.dcommenttype);
    }
    if (null == this.dcontent) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dcontent);
    }
    if (null == this.dcomplaint) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dcomplaint);
    }
    if (null == this.dcomplainttype) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.dcomplainttype);
    }
    if (null == this.dtime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dtime);
    }
    if (null == this.dstatus) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.dstatus);
    }
    if (null == this.credibility) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.credibility);
    }
    if (null == this.neatness) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.neatness);
    }
    if (null == this.punctual) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.punctual);
    }
    if (null == this.remark) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, remark);
    }
    if (null == this.opname) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, opname);
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
    if (null == this.createtime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, createtime);
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
    __sb.append(FieldFormatter.escapeAndEnclose(cmtid==null?"":"" + cmtid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(oid==null?"":"" + oid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(ordertype==null?"":"" + ordertype, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pphone==null?"":pphone, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dphone==null?"":dphone, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pcontent==null?"":pcontent, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pcommenttype==null?"":"" + pcommenttype, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pctime==null?"":pctime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pcomplaint==null?"":pcomplaint, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pcomplainttype==null?"":"" + pcomplainttype, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(ptime==null?"":ptime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pstatus==null?"":"" + pstatus, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dcommenttype==null?"":"" + dcommenttype, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dcontent==null?"":dcontent, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dcomplaint==null?"":dcomplaint, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dcomplainttype==null?"":"" + dcomplainttype, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dtime==null?"":dtime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dstatus==null?"":"" + dstatus, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(credibility==null?"":"" + credibility, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(neatness==null?"":"" + neatness, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(punctual==null?"":"" + punctual, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(remark==null?"":remark, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(opname==null?"":opname, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel==null?"":"" + channel, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(area==null?"":"" + area, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(createtime==null?"":createtime, delimiters));
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.cmtid = null; } else {
      this.cmtid = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.oid = null; } else {
      this.oid = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.ordertype = null; } else {
      this.ordertype = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pphone = null; } else {
      this.pphone = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dphone = null; } else {
      this.dphone = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pcontent = null; } else {
      this.pcontent = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pcommenttype = null; } else {
      this.pcommenttype = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pctime = null; } else {
      this.pctime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pcomplaint = null; } else {
      this.pcomplaint = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pcomplainttype = null; } else {
      this.pcomplainttype = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.ptime = null; } else {
      this.ptime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pstatus = null; } else {
      this.pstatus = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.dcommenttype = null; } else {
      this.dcommenttype = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dcontent = null; } else {
      this.dcontent = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dcomplaint = null; } else {
      this.dcomplaint = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.dcomplainttype = null; } else {
      this.dcomplainttype = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dtime = null; } else {
      this.dtime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.dstatus = null; } else {
      this.dstatus = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.credibility = null; } else {
      this.credibility = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.neatness = null; } else {
      this.neatness = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.punctual = null; } else {
      this.punctual = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.remark = null; } else {
      this.remark = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.opname = null; } else {
      this.opname = __cur_str;
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
    if (__cur_str.equals("null")) { this.createtime = null; } else {
      this.createtime = __cur_str;
    }

  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("cmtid", this.cmtid);
    __sqoop$field_map.put("oid", this.oid);
    __sqoop$field_map.put("ordertype", this.ordertype);
    __sqoop$field_map.put("pphone", this.pphone);
    __sqoop$field_map.put("dphone", this.dphone);
    __sqoop$field_map.put("pcontent", this.pcontent);
    __sqoop$field_map.put("pcommenttype", this.pcommenttype);
    __sqoop$field_map.put("pctime", this.pctime);
    __sqoop$field_map.put("pcomplaint", this.pcomplaint);
    __sqoop$field_map.put("pcomplainttype", this.pcomplainttype);
    __sqoop$field_map.put("ptime", this.ptime);
    __sqoop$field_map.put("pstatus", this.pstatus);
    __sqoop$field_map.put("dcommenttype", this.dcommenttype);
    __sqoop$field_map.put("dcontent", this.dcontent);
    __sqoop$field_map.put("dcomplaint", this.dcomplaint);
    __sqoop$field_map.put("dcomplainttype", this.dcomplainttype);
    __sqoop$field_map.put("dtime", this.dtime);
    __sqoop$field_map.put("dstatus", this.dstatus);
    __sqoop$field_map.put("credibility", this.credibility);
    __sqoop$field_map.put("neatness", this.neatness);
    __sqoop$field_map.put("punctual", this.punctual);
    __sqoop$field_map.put("remark", this.remark);
    __sqoop$field_map.put("opname", this.opname);
    __sqoop$field_map.put("channel", this.channel);
    __sqoop$field_map.put("area", this.area);
    __sqoop$field_map.put("createtime", this.createtime);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("cmtid".equals(__fieldName)) {
      this.cmtid = (Long) __fieldVal;
    }
    else    if ("oid".equals(__fieldName)) {
      this.oid = (Long) __fieldVal;
    }
    else    if ("ordertype".equals(__fieldName)) {
      this.ordertype = (Integer) __fieldVal;
    }
    else    if ("pphone".equals(__fieldName)) {
      this.pphone = (String) __fieldVal;
    }
    else    if ("dphone".equals(__fieldName)) {
      this.dphone = (String) __fieldVal;
    }
    else    if ("pcontent".equals(__fieldName)) {
      this.pcontent = (String) __fieldVal;
    }
    else    if ("pcommenttype".equals(__fieldName)) {
      this.pcommenttype = (Integer) __fieldVal;
    }
    else    if ("pctime".equals(__fieldName)) {
      this.pctime = (String) __fieldVal;
    }
    else    if ("pcomplaint".equals(__fieldName)) {
      this.pcomplaint = (String) __fieldVal;
    }
    else    if ("pcomplainttype".equals(__fieldName)) {
      this.pcomplainttype = (Integer) __fieldVal;
    }
    else    if ("ptime".equals(__fieldName)) {
      this.ptime = (String) __fieldVal;
    }
    else    if ("pstatus".equals(__fieldName)) {
      this.pstatus = (Integer) __fieldVal;
    }
    else    if ("dcommenttype".equals(__fieldName)) {
      this.dcommenttype = (Integer) __fieldVal;
    }
    else    if ("dcontent".equals(__fieldName)) {
      this.dcontent = (String) __fieldVal;
    }
    else    if ("dcomplaint".equals(__fieldName)) {
      this.dcomplaint = (String) __fieldVal;
    }
    else    if ("dcomplainttype".equals(__fieldName)) {
      this.dcomplainttype = (Integer) __fieldVal;
    }
    else    if ("dtime".equals(__fieldName)) {
      this.dtime = (String) __fieldVal;
    }
    else    if ("dstatus".equals(__fieldName)) {
      this.dstatus = (Integer) __fieldVal;
    }
    else    if ("credibility".equals(__fieldName)) {
      this.credibility = (Integer) __fieldVal;
    }
    else    if ("neatness".equals(__fieldName)) {
      this.neatness = (Integer) __fieldVal;
    }
    else    if ("punctual".equals(__fieldName)) {
      this.punctual = (Integer) __fieldVal;
    }
    else    if ("remark".equals(__fieldName)) {
      this.remark = (String) __fieldVal;
    }
    else    if ("opname".equals(__fieldName)) {
      this.opname = (String) __fieldVal;
    }
    else    if ("channel".equals(__fieldName)) {
      this.channel = (Integer) __fieldVal;
    }
    else    if ("area".equals(__fieldName)) {
      this.area = (Integer) __fieldVal;
    }
    else    if ("createtime".equals(__fieldName)) {
      this.createtime = (String) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
