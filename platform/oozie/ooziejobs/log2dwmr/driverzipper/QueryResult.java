// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Tue Dec 31 14:38:36 CST 2013
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
  private Long orderId;
  public Long get_orderId() {
    return orderId;
  }
  public void set_orderId(Long orderId) {
    this.orderId = orderId;
  }
  public QueryResult with_orderId(Long orderId) {
    this.orderId = orderId;
    return this;
  }
  private Integer passengerId;
  public Integer get_passengerId() {
    return passengerId;
  }
  public void set_passengerId(Integer passengerId) {
    this.passengerId = passengerId;
  }
  public QueryResult with_passengerId(Integer passengerId) {
    this.passengerId = passengerId;
    return this;
  }
  private String token;
  public String get_token() {
    return token;
  }
  public void set_token(String token) {
    this.token = token;
  }
  public QueryResult with_token(String token) {
    this.token = token;
    return this;
  }
  private Integer driverId;
  public Integer get_driverId() {
    return driverId;
  }
  public void set_driverId(Integer driverId) {
    this.driverId = driverId;
  }
  public QueryResult with_driverId(Integer driverId) {
    this.driverId = driverId;
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
  private Integer type;
  public Integer get_type() {
    return type;
  }
  public void set_type(Integer type) {
    this.type = type;
  }
  public QueryResult with_type(Integer type) {
    this.type = type;
    return this;
  }
  private Double lng;
  public Double get_lng() {
    return lng;
  }
  public void set_lng(Double lng) {
    this.lng = lng;
  }
  public QueryResult with_lng(Double lng) {
    this.lng = lng;
    return this;
  }
  private Double lat;
  public Double get_lat() {
    return lat;
  }
  public void set_lat(Double lat) {
    this.lat = lat;
  }
  public QueryResult with_lat(Double lat) {
    this.lat = lat;
    return this;
  }
  private String address;
  public String get_address() {
    return address;
  }
  public void set_address(String address) {
    this.address = address;
  }
  public QueryResult with_address(String address) {
    this.address = address;
    return this;
  }
  private String destination;
  public String get_destination() {
    return destination;
  }
  public void set_destination(String destination) {
    this.destination = destination;
  }
  public QueryResult with_destination(String destination) {
    this.destination = destination;
    return this;
  }
  private String setuptime;
  public String get_setuptime() {
    return setuptime;
  }
  public void set_setuptime(String setuptime) {
    this.setuptime = setuptime;
  }
  public QueryResult with_setuptime(String setuptime) {
    this.setuptime = setuptime;
    return this;
  }
  private Integer tip;
  public Integer get_tip() {
    return tip;
  }
  public void set_tip(Integer tip) {
    this.tip = tip;
  }
  public QueryResult with_tip(Integer tip) {
    this.tip = tip;
    return this;
  }
  private Integer exp;
  public Integer get_exp() {
    return exp;
  }
  public void set_exp(Integer exp) {
    this.exp = exp;
  }
  public QueryResult with_exp(Integer exp) {
    this.exp = exp;
    return this;
  }
  private Integer waittime;
  public Integer get_waittime() {
    return waittime;
  }
  public void set_waittime(Integer waittime) {
    this.waittime = waittime;
  }
  public QueryResult with_waittime(Integer waittime) {
    this.waittime = waittime;
    return this;
  }
  private Integer callCount;
  public Integer get_callCount() {
    return callCount;
  }
  public void set_callCount(Integer callCount) {
    this.callCount = callCount;
  }
  public QueryResult with_callCount(Integer callCount) {
    this.callCount = callCount;
    return this;
  }
  private Integer distance;
  public Integer get_distance() {
    return distance;
  }
  public void set_distance(Integer distance) {
    this.distance = distance;
  }
  public QueryResult with_distance(Integer distance) {
    this.distance = distance;
    return this;
  }
  private Integer length;
  public Integer get_length() {
    return length;
  }
  public void set_length(Integer length) {
    this.length = length;
  }
  public QueryResult with_length(Integer length) {
    this.length = length;
    return this;
  }
  private String verifyMessage;
  public String get_verifyMessage() {
    return verifyMessage;
  }
  public void set_verifyMessage(String verifyMessage) {
    this.verifyMessage = verifyMessage;
  }
  public QueryResult with_verifyMessage(String verifyMessage) {
    this.verifyMessage = verifyMessage;
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
  private String striveTime;
  public String get_striveTime() {
    return striveTime;
  }
  public void set_striveTime(String striveTime) {
    this.striveTime = striveTime;
  }
  public QueryResult with_striveTime(String striveTime) {
    this.striveTime = striveTime;
    return this;
  }
  private String arriveTime;
  public String get_arriveTime() {
    return arriveTime;
  }
  public void set_arriveTime(String arriveTime) {
    this.arriveTime = arriveTime;
  }
  public QueryResult with_arriveTime(String arriveTime) {
    this.arriveTime = arriveTime;
    return this;
  }
  private String aboardTime;
  public String get_aboardTime() {
    return aboardTime;
  }
  public void set_aboardTime(String aboardTime) {
    this.aboardTime = aboardTime;
  }
  public QueryResult with_aboardTime(String aboardTime) {
    this.aboardTime = aboardTime;
    return this;
  }
  private String cancelTime;
  public String get_cancelTime() {
    return cancelTime;
  }
  public void set_cancelTime(String cancelTime) {
    this.cancelTime = cancelTime;
  }
  public QueryResult with_cancelTime(String cancelTime) {
    this.cancelTime = cancelTime;
    return this;
  }
  private Integer pCommentGread;
  public Integer get_pCommentGread() {
    return pCommentGread;
  }
  public void set_pCommentGread(Integer pCommentGread) {
    this.pCommentGread = pCommentGread;
  }
  public QueryResult with_pCommentGread(Integer pCommentGread) {
    this.pCommentGread = pCommentGread;
    return this;
  }
  private String pCommentText;
  public String get_pCommentText() {
    return pCommentText;
  }
  public void set_pCommentText(String pCommentText) {
    this.pCommentText = pCommentText;
  }
  public QueryResult with_pCommentText(String pCommentText) {
    this.pCommentText = pCommentText;
    return this;
  }
  private String pCommentTime;
  public String get_pCommentTime() {
    return pCommentTime;
  }
  public void set_pCommentTime(String pCommentTime) {
    this.pCommentTime = pCommentTime;
  }
  public QueryResult with_pCommentTime(String pCommentTime) {
    this.pCommentTime = pCommentTime;
    return this;
  }
  private Integer pCommentStatus;
  public Integer get_pCommentStatus() {
    return pCommentStatus;
  }
  public void set_pCommentStatus(Integer pCommentStatus) {
    this.pCommentStatus = pCommentStatus;
  }
  public QueryResult with_pCommentStatus(Integer pCommentStatus) {
    this.pCommentStatus = pCommentStatus;
    return this;
  }
  private Integer dCommentGread;
  public Integer get_dCommentGread() {
    return dCommentGread;
  }
  public void set_dCommentGread(Integer dCommentGread) {
    this.dCommentGread = dCommentGread;
  }
  public QueryResult with_dCommentGread(Integer dCommentGread) {
    this.dCommentGread = dCommentGread;
    return this;
  }
  private String dCommentText;
  public String get_dCommentText() {
    return dCommentText;
  }
  public void set_dCommentText(String dCommentText) {
    this.dCommentText = dCommentText;
  }
  public QueryResult with_dCommentText(String dCommentText) {
    this.dCommentText = dCommentText;
    return this;
  }
  private String dCommentTime;
  public String get_dCommentTime() {
    return dCommentTime;
  }
  public void set_dCommentTime(String dCommentTime) {
    this.dCommentTime = dCommentTime;
  }
  public QueryResult with_dCommentTime(String dCommentTime) {
    this.dCommentTime = dCommentTime;
    return this;
  }
  private Integer dCommentStatus;
  public Integer get_dCommentStatus() {
    return dCommentStatus;
  }
  public void set_dCommentStatus(Integer dCommentStatus) {
    this.dCommentStatus = dCommentStatus;
  }
  public QueryResult with_dCommentStatus(Integer dCommentStatus) {
    this.dCommentStatus = dCommentStatus;
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
  private Integer version;
  public Integer get_version() {
    return version;
  }
  public void set_version(Integer version) {
    this.version = version;
  }
  public QueryResult with_version(Integer version) {
    this.version = version;
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
  private Integer bonus;
  public Integer get_bonus() {
    return bonus;
  }
  public void set_bonus(Integer bonus) {
    this.bonus = bonus;
  }
  public QueryResult with_bonus(Integer bonus) {
    this.bonus = bonus;
    return this;
  }
  private Long voicelength;
  public Long get_voicelength() {
    return voicelength;
  }
  public void set_voicelength(Long voicelength) {
    this.voicelength = voicelength;
  }
  public QueryResult with_voicelength(Long voicelength) {
    this.voicelength = voicelength;
    return this;
  }
  private Integer voiceTime;
  public Integer get_voiceTime() {
    return voiceTime;
  }
  public void set_voiceTime(Integer voiceTime) {
    this.voiceTime = voiceTime;
  }
  public QueryResult with_voiceTime(Integer voiceTime) {
    this.voiceTime = voiceTime;
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
    equal = equal && (this.orderId == null ? that.orderId == null : this.orderId.equals(that.orderId));
    equal = equal && (this.passengerId == null ? that.passengerId == null : this.passengerId.equals(that.passengerId));
    equal = equal && (this.token == null ? that.token == null : this.token.equals(that.token));
    equal = equal && (this.driverId == null ? that.driverId == null : this.driverId.equals(that.driverId));
    equal = equal && (this.status == null ? that.status == null : this.status.equals(that.status));
    equal = equal && (this.type == null ? that.type == null : this.type.equals(that.type));
    equal = equal && (this.lng == null ? that.lng == null : this.lng.equals(that.lng));
    equal = equal && (this.lat == null ? that.lat == null : this.lat.equals(that.lat));
    equal = equal && (this.address == null ? that.address == null : this.address.equals(that.address));
    equal = equal && (this.destination == null ? that.destination == null : this.destination.equals(that.destination));
    equal = equal && (this.setuptime == null ? that.setuptime == null : this.setuptime.equals(that.setuptime));
    equal = equal && (this.tip == null ? that.tip == null : this.tip.equals(that.tip));
    equal = equal && (this.exp == null ? that.exp == null : this.exp.equals(that.exp));
    equal = equal && (this.waittime == null ? that.waittime == null : this.waittime.equals(that.waittime));
    equal = equal && (this.callCount == null ? that.callCount == null : this.callCount.equals(that.callCount));
    equal = equal && (this.distance == null ? that.distance == null : this.distance.equals(that.distance));
    equal = equal && (this.length == null ? that.length == null : this.length.equals(that.length));
    equal = equal && (this.verifyMessage == null ? that.verifyMessage == null : this.verifyMessage.equals(that.verifyMessage));
    equal = equal && (this.createtime == null ? that.createtime == null : this.createtime.equals(that.createtime));
    equal = equal && (this.striveTime == null ? that.striveTime == null : this.striveTime.equals(that.striveTime));
    equal = equal && (this.arriveTime == null ? that.arriveTime == null : this.arriveTime.equals(that.arriveTime));
    equal = equal && (this.aboardTime == null ? that.aboardTime == null : this.aboardTime.equals(that.aboardTime));
    equal = equal && (this.cancelTime == null ? that.cancelTime == null : this.cancelTime.equals(that.cancelTime));
    equal = equal && (this.pCommentGread == null ? that.pCommentGread == null : this.pCommentGread.equals(that.pCommentGread));
    equal = equal && (this.pCommentText == null ? that.pCommentText == null : this.pCommentText.equals(that.pCommentText));
    equal = equal && (this.pCommentTime == null ? that.pCommentTime == null : this.pCommentTime.equals(that.pCommentTime));
    equal = equal && (this.pCommentStatus == null ? that.pCommentStatus == null : this.pCommentStatus.equals(that.pCommentStatus));
    equal = equal && (this.dCommentGread == null ? that.dCommentGread == null : this.dCommentGread.equals(that.dCommentGread));
    equal = equal && (this.dCommentText == null ? that.dCommentText == null : this.dCommentText.equals(that.dCommentText));
    equal = equal && (this.dCommentTime == null ? that.dCommentTime == null : this.dCommentTime.equals(that.dCommentTime));
    equal = equal && (this.dCommentStatus == null ? that.dCommentStatus == null : this.dCommentStatus.equals(that.dCommentStatus));
    equal = equal && (this.channel == null ? that.channel == null : this.channel.equals(that.channel));
    equal = equal && (this.area == null ? that.area == null : this.area.equals(that.area));
    equal = equal && (this.version == null ? that.version == null : this.version.equals(that.version));
    equal = equal && (this.remark == null ? that.remark == null : this.remark.equals(that.remark));
    equal = equal && (this.bonus == null ? that.bonus == null : this.bonus.equals(that.bonus));
    equal = equal && (this.voicelength == null ? that.voicelength == null : this.voicelength.equals(that.voicelength));
    equal = equal && (this.voiceTime == null ? that.voiceTime == null : this.voiceTime.equals(that.voiceTime));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.orderId = JdbcWritableBridge.readLong(1, __dbResults);
    this.passengerId = JdbcWritableBridge.readInteger(2, __dbResults);
    this.token = JdbcWritableBridge.readString(3, __dbResults);
    this.driverId = JdbcWritableBridge.readInteger(4, __dbResults);
    this.status = JdbcWritableBridge.readInteger(5, __dbResults);
    this.type = JdbcWritableBridge.readInteger(6, __dbResults);
    this.lng = JdbcWritableBridge.readDouble(7, __dbResults);
    this.lat = JdbcWritableBridge.readDouble(8, __dbResults);
    this.address = JdbcWritableBridge.readString(9, __dbResults);
    this.destination = JdbcWritableBridge.readString(10, __dbResults);
    this.setuptime = JdbcWritableBridge.readString(11, __dbResults);
    this.tip = JdbcWritableBridge.readInteger(12, __dbResults);
    this.exp = JdbcWritableBridge.readInteger(13, __dbResults);
    this.waittime = JdbcWritableBridge.readInteger(14, __dbResults);
    this.callCount = JdbcWritableBridge.readInteger(15, __dbResults);
    this.distance = JdbcWritableBridge.readInteger(16, __dbResults);
    this.length = JdbcWritableBridge.readInteger(17, __dbResults);
    this.verifyMessage = JdbcWritableBridge.readString(18, __dbResults);
    this.createtime = JdbcWritableBridge.readString(19, __dbResults);
    this.striveTime = JdbcWritableBridge.readString(20, __dbResults);
    this.arriveTime = JdbcWritableBridge.readString(21, __dbResults);
    this.aboardTime = JdbcWritableBridge.readString(22, __dbResults);
    this.cancelTime = JdbcWritableBridge.readString(23, __dbResults);
    this.pCommentGread = JdbcWritableBridge.readInteger(24, __dbResults);
    this.pCommentText = JdbcWritableBridge.readString(25, __dbResults);
    this.pCommentTime = JdbcWritableBridge.readString(26, __dbResults);
    this.pCommentStatus = JdbcWritableBridge.readInteger(27, __dbResults);
    this.dCommentGread = JdbcWritableBridge.readInteger(28, __dbResults);
    this.dCommentText = JdbcWritableBridge.readString(29, __dbResults);
    this.dCommentTime = JdbcWritableBridge.readString(30, __dbResults);
    this.dCommentStatus = JdbcWritableBridge.readInteger(31, __dbResults);
    this.channel = JdbcWritableBridge.readInteger(32, __dbResults);
    this.area = JdbcWritableBridge.readInteger(33, __dbResults);
    this.version = JdbcWritableBridge.readInteger(34, __dbResults);
    this.remark = JdbcWritableBridge.readString(35, __dbResults);
    this.bonus = JdbcWritableBridge.readInteger(36, __dbResults);
    this.voicelength = JdbcWritableBridge.readLong(37, __dbResults);
    this.voiceTime = JdbcWritableBridge.readInteger(38, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(orderId, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeInteger(passengerId, 2 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(token, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(driverId, 4 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(status, 5 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(type, 6 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeDouble(lng, 7 + __off, 8, __dbStmt);
    JdbcWritableBridge.writeDouble(lat, 8 + __off, 8, __dbStmt);
    JdbcWritableBridge.writeString(address, 9 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(destination, 10 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(setuptime, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(tip, 12 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(exp, 13 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(waittime, 14 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(callCount, 15 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(distance, 16 + __off, 5, __dbStmt);
    JdbcWritableBridge.writeInteger(length, 17 + __off, 5, __dbStmt);
    JdbcWritableBridge.writeString(verifyMessage, 18 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(createtime, 19 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(striveTime, 20 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(arriveTime, 21 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(aboardTime, 22 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(cancelTime, 23 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(pCommentGread, 24 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(pCommentText, 25 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(pCommentTime, 26 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(pCommentStatus, 27 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(dCommentGread, 28 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(dCommentText, 29 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(dCommentTime, 30 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(dCommentStatus, 31 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(channel, 32 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeInteger(area, 33 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(version, 34 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(remark, 35 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(bonus, 36 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeLong(voicelength, 37 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeInteger(voiceTime, 38 + __off, -6, __dbStmt);
    return 38;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.orderId = null;
    } else {
    this.orderId = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.passengerId = null;
    } else {
    this.passengerId = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.token = null;
    } else {
    this.token = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.driverId = null;
    } else {
    this.driverId = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.status = null;
    } else {
    this.status = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.type = null;
    } else {
    this.type = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.lng = null;
    } else {
    this.lng = Double.valueOf(__dataIn.readDouble());
    }
    if (__dataIn.readBoolean()) { 
        this.lat = null;
    } else {
    this.lat = Double.valueOf(__dataIn.readDouble());
    }
    if (__dataIn.readBoolean()) { 
        this.address = null;
    } else {
    this.address = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.destination = null;
    } else {
    this.destination = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.setuptime = null;
    } else {
    this.setuptime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.tip = null;
    } else {
    this.tip = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.exp = null;
    } else {
    this.exp = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.waittime = null;
    } else {
    this.waittime = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.callCount = null;
    } else {
    this.callCount = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.distance = null;
    } else {
    this.distance = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.length = null;
    } else {
    this.length = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.verifyMessage = null;
    } else {
    this.verifyMessage = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.createtime = null;
    } else {
    this.createtime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.striveTime = null;
    } else {
    this.striveTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.arriveTime = null;
    } else {
    this.arriveTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.aboardTime = null;
    } else {
    this.aboardTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.cancelTime = null;
    } else {
    this.cancelTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pCommentGread = null;
    } else {
    this.pCommentGread = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.pCommentText = null;
    } else {
    this.pCommentText = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pCommentTime = null;
    } else {
    this.pCommentTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.pCommentStatus = null;
    } else {
    this.pCommentStatus = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.dCommentGread = null;
    } else {
    this.dCommentGread = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.dCommentText = null;
    } else {
    this.dCommentText = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dCommentTime = null;
    } else {
    this.dCommentTime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.dCommentStatus = null;
    } else {
    this.dCommentStatus = Integer.valueOf(__dataIn.readInt());
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
        this.version = null;
    } else {
    this.version = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.remark = null;
    } else {
    this.remark = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.bonus = null;
    } else {
    this.bonus = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.voicelength = null;
    } else {
    this.voicelength = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.voiceTime = null;
    } else {
    this.voiceTime = Integer.valueOf(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.orderId) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.orderId);
    }
    if (null == this.passengerId) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.passengerId);
    }
    if (null == this.token) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, token);
    }
    if (null == this.driverId) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.driverId);
    }
    if (null == this.status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.status);
    }
    if (null == this.type) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.type);
    }
    if (null == this.lng) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeDouble(this.lng);
    }
    if (null == this.lat) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeDouble(this.lat);
    }
    if (null == this.address) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, address);
    }
    if (null == this.destination) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, destination);
    }
    if (null == this.setuptime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, setuptime);
    }
    if (null == this.tip) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.tip);
    }
    if (null == this.exp) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.exp);
    }
    if (null == this.waittime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.waittime);
    }
    if (null == this.callCount) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.callCount);
    }
    if (null == this.distance) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.distance);
    }
    if (null == this.length) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.length);
    }
    if (null == this.verifyMessage) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, verifyMessage);
    }
    if (null == this.createtime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, createtime);
    }
    if (null == this.striveTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, striveTime);
    }
    if (null == this.arriveTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, arriveTime);
    }
    if (null == this.aboardTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, aboardTime);
    }
    if (null == this.cancelTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, cancelTime);
    }
    if (null == this.pCommentGread) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.pCommentGread);
    }
    if (null == this.pCommentText) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pCommentText);
    }
    if (null == this.pCommentTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, pCommentTime);
    }
    if (null == this.pCommentStatus) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.pCommentStatus);
    }
    if (null == this.dCommentGread) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.dCommentGread);
    }
    if (null == this.dCommentText) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dCommentText);
    }
    if (null == this.dCommentTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, dCommentTime);
    }
    if (null == this.dCommentStatus) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.dCommentStatus);
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
    if (null == this.version) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.version);
    }
    if (null == this.remark) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, remark);
    }
    if (null == this.bonus) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.bonus);
    }
    if (null == this.voicelength) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.voicelength);
    }
    if (null == this.voiceTime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.voiceTime);
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
    __sb.append(FieldFormatter.escapeAndEnclose(orderId==null?"":"" + orderId, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(passengerId==null?"":"" + passengerId, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(token==null?"":token, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(driverId==null?"":"" + driverId, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(status==null?"":"" + status, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(type==null?"":"" + type, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(lng==null?"":"" + lng, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(lat==null?"":"" + lat, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(address==null?"":address, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(destination==null?"":destination, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(setuptime==null?"":setuptime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(tip==null?"":"" + tip, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(exp==null?"":"" + exp, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(waittime==null?"":"" + waittime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(callCount==null?"":"" + callCount, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(distance==null?"":"" + distance, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(length==null?"":"" + length, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(verifyMessage==null?"":verifyMessage, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(createtime==null?"":createtime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(striveTime==null?"":striveTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(arriveTime==null?"":arriveTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(aboardTime==null?"":aboardTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cancelTime==null?"":cancelTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pCommentGread==null?"":"" + pCommentGread, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pCommentText==null?"":pCommentText, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pCommentTime==null?"":pCommentTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(pCommentStatus==null?"":"" + pCommentStatus, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dCommentGread==null?"":"" + dCommentGread, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dCommentText==null?"":dCommentText, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dCommentTime==null?"":dCommentTime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(dCommentStatus==null?"":"" + dCommentStatus, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel==null?"":"" + channel, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(area==null?"":"" + area, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(version==null?"":"" + version, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(remark==null?"":remark, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(bonus==null?"":"" + bonus, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(voicelength==null?"":"" + voicelength, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(voiceTime==null?"":"" + voiceTime, delimiters));
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.orderId = null; } else {
      this.orderId = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.passengerId = null; } else {
      this.passengerId = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.token = null; } else {
      this.token = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.driverId = null; } else {
      this.driverId = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.status = null; } else {
      this.status = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.type = null; } else {
      this.type = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.lng = null; } else {
      this.lng = Double.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.lat = null; } else {
      this.lat = Double.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.address = null; } else {
      this.address = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.destination = null; } else {
      this.destination = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.setuptime = null; } else {
      this.setuptime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.tip = null; } else {
      this.tip = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.exp = null; } else {
      this.exp = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.waittime = null; } else {
      this.waittime = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.callCount = null; } else {
      this.callCount = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.distance = null; } else {
      this.distance = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.length = null; } else {
      this.length = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.verifyMessage = null; } else {
      this.verifyMessage = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.createtime = null; } else {
      this.createtime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.striveTime = null; } else {
      this.striveTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.arriveTime = null; } else {
      this.arriveTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.aboardTime = null; } else {
      this.aboardTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.cancelTime = null; } else {
      this.cancelTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pCommentGread = null; } else {
      this.pCommentGread = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pCommentText = null; } else {
      this.pCommentText = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.pCommentTime = null; } else {
      this.pCommentTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pCommentStatus = null; } else {
      this.pCommentStatus = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.dCommentGread = null; } else {
      this.dCommentGread = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dCommentText = null; } else {
      this.dCommentText = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.dCommentTime = null; } else {
      this.dCommentTime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.dCommentStatus = null; } else {
      this.dCommentStatus = Integer.valueOf(__cur_str);
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.version = null; } else {
      this.version = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.remark = null; } else {
      this.remark = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.bonus = null; } else {
      this.bonus = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.voicelength = null; } else {
      this.voicelength = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.voiceTime = null; } else {
      this.voiceTime = Integer.valueOf(__cur_str);
    }

  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("orderId", this.orderId);
    __sqoop$field_map.put("passengerId", this.passengerId);
    __sqoop$field_map.put("token", this.token);
    __sqoop$field_map.put("driverId", this.driverId);
    __sqoop$field_map.put("status", this.status);
    __sqoop$field_map.put("type", this.type);
    __sqoop$field_map.put("lng", this.lng);
    __sqoop$field_map.put("lat", this.lat);
    __sqoop$field_map.put("address", this.address);
    __sqoop$field_map.put("destination", this.destination);
    __sqoop$field_map.put("setuptime", this.setuptime);
    __sqoop$field_map.put("tip", this.tip);
    __sqoop$field_map.put("exp", this.exp);
    __sqoop$field_map.put("waittime", this.waittime);
    __sqoop$field_map.put("callCount", this.callCount);
    __sqoop$field_map.put("distance", this.distance);
    __sqoop$field_map.put("length", this.length);
    __sqoop$field_map.put("verifyMessage", this.verifyMessage);
    __sqoop$field_map.put("createtime", this.createtime);
    __sqoop$field_map.put("striveTime", this.striveTime);
    __sqoop$field_map.put("arriveTime", this.arriveTime);
    __sqoop$field_map.put("aboardTime", this.aboardTime);
    __sqoop$field_map.put("cancelTime", this.cancelTime);
    __sqoop$field_map.put("pCommentGread", this.pCommentGread);
    __sqoop$field_map.put("pCommentText", this.pCommentText);
    __sqoop$field_map.put("pCommentTime", this.pCommentTime);
    __sqoop$field_map.put("pCommentStatus", this.pCommentStatus);
    __sqoop$field_map.put("dCommentGread", this.dCommentGread);
    __sqoop$field_map.put("dCommentText", this.dCommentText);
    __sqoop$field_map.put("dCommentTime", this.dCommentTime);
    __sqoop$field_map.put("dCommentStatus", this.dCommentStatus);
    __sqoop$field_map.put("channel", this.channel);
    __sqoop$field_map.put("area", this.area);
    __sqoop$field_map.put("version", this.version);
    __sqoop$field_map.put("remark", this.remark);
    __sqoop$field_map.put("bonus", this.bonus);
    __sqoop$field_map.put("voicelength", this.voicelength);
    __sqoop$field_map.put("voiceTime", this.voiceTime);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("orderId".equals(__fieldName)) {
      this.orderId = (Long) __fieldVal;
    }
    else    if ("passengerId".equals(__fieldName)) {
      this.passengerId = (Integer) __fieldVal;
    }
    else    if ("token".equals(__fieldName)) {
      this.token = (String) __fieldVal;
    }
    else    if ("driverId".equals(__fieldName)) {
      this.driverId = (Integer) __fieldVal;
    }
    else    if ("status".equals(__fieldName)) {
      this.status = (Integer) __fieldVal;
    }
    else    if ("type".equals(__fieldName)) {
      this.type = (Integer) __fieldVal;
    }
    else    if ("lng".equals(__fieldName)) {
      this.lng = (Double) __fieldVal;
    }
    else    if ("lat".equals(__fieldName)) {
      this.lat = (Double) __fieldVal;
    }
    else    if ("address".equals(__fieldName)) {
      this.address = (String) __fieldVal;
    }
    else    if ("destination".equals(__fieldName)) {
      this.destination = (String) __fieldVal;
    }
    else    if ("setuptime".equals(__fieldName)) {
      this.setuptime = (String) __fieldVal;
    }
    else    if ("tip".equals(__fieldName)) {
      this.tip = (Integer) __fieldVal;
    }
    else    if ("exp".equals(__fieldName)) {
      this.exp = (Integer) __fieldVal;
    }
    else    if ("waittime".equals(__fieldName)) {
      this.waittime = (Integer) __fieldVal;
    }
    else    if ("callCount".equals(__fieldName)) {
      this.callCount = (Integer) __fieldVal;
    }
    else    if ("distance".equals(__fieldName)) {
      this.distance = (Integer) __fieldVal;
    }
    else    if ("length".equals(__fieldName)) {
      this.length = (Integer) __fieldVal;
    }
    else    if ("verifyMessage".equals(__fieldName)) {
      this.verifyMessage = (String) __fieldVal;
    }
    else    if ("createtime".equals(__fieldName)) {
      this.createtime = (String) __fieldVal;
    }
    else    if ("striveTime".equals(__fieldName)) {
      this.striveTime = (String) __fieldVal;
    }
    else    if ("arriveTime".equals(__fieldName)) {
      this.arriveTime = (String) __fieldVal;
    }
    else    if ("aboardTime".equals(__fieldName)) {
      this.aboardTime = (String) __fieldVal;
    }
    else    if ("cancelTime".equals(__fieldName)) {
      this.cancelTime = (String) __fieldVal;
    }
    else    if ("pCommentGread".equals(__fieldName)) {
      this.pCommentGread = (Integer) __fieldVal;
    }
    else    if ("pCommentText".equals(__fieldName)) {
      this.pCommentText = (String) __fieldVal;
    }
    else    if ("pCommentTime".equals(__fieldName)) {
      this.pCommentTime = (String) __fieldVal;
    }
    else    if ("pCommentStatus".equals(__fieldName)) {
      this.pCommentStatus = (Integer) __fieldVal;
    }
    else    if ("dCommentGread".equals(__fieldName)) {
      this.dCommentGread = (Integer) __fieldVal;
    }
    else    if ("dCommentText".equals(__fieldName)) {
      this.dCommentText = (String) __fieldVal;
    }
    else    if ("dCommentTime".equals(__fieldName)) {
      this.dCommentTime = (String) __fieldVal;
    }
    else    if ("dCommentStatus".equals(__fieldName)) {
      this.dCommentStatus = (Integer) __fieldVal;
    }
    else    if ("channel".equals(__fieldName)) {
      this.channel = (Integer) __fieldVal;
    }
    else    if ("area".equals(__fieldName)) {
      this.area = (Integer) __fieldVal;
    }
    else    if ("version".equals(__fieldName)) {
      this.version = (Integer) __fieldVal;
    }
    else    if ("remark".equals(__fieldName)) {
      this.remark = (String) __fieldVal;
    }
    else    if ("bonus".equals(__fieldName)) {
      this.bonus = (Integer) __fieldVal;
    }
    else    if ("voicelength".equals(__fieldName)) {
      this.voicelength = (Long) __fieldVal;
    }
    else    if ("voiceTime".equals(__fieldName)) {
      this.voiceTime = (Integer) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
