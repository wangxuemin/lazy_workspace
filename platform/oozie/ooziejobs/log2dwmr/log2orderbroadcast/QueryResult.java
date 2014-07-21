// ORM class for table 'null'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Tue Dec 31 11:33:56 CST 2013
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
  private String sessionKey;
  public String get_sessionKey() {
    return sessionKey;
  }
  public void set_sessionKey(String sessionKey) {
    this.sessionKey = sessionKey;
  }
  public QueryResult with_sessionKey(String sessionKey) {
    this.sessionKey = sessionKey;
    return this;
  }
  private String phone;
  public String get_phone() {
    return phone;
  }
  public void set_phone(String phone) {
    this.phone = phone;
  }
  public QueryResult with_phone(String phone) {
    this.phone = phone;
    return this;
  }
  private String password;
  public String get_password() {
    return password;
  }
  public void set_password(String password) {
    this.password = password;
  }
  public QueryResult with_password(String password) {
    this.password = password;
    return this;
  }
  private String email;
  public String get_email() {
    return email;
  }
  public void set_email(String email) {
    this.email = email;
  }
  public QueryResult with_email(String email) {
    this.email = email;
    return this;
  }
  private String nick;
  public String get_nick() {
    return nick;
  }
  public void set_nick(String nick) {
    this.nick = nick;
  }
  public QueryResult with_nick(String nick) {
    this.nick = nick;
    return this;
  }
  private Boolean gender;
  public Boolean get_gender() {
    return gender;
  }
  public void set_gender(Boolean gender) {
    this.gender = gender;
  }
  public QueryResult with_gender(Boolean gender) {
    this.gender = gender;
    return this;
  }
  private String deviceTocken;
  public String get_deviceTocken() {
    return deviceTocken;
  }
  public void set_deviceTocken(String deviceTocken) {
    this.deviceTocken = deviceTocken;
  }
  public QueryResult with_deviceTocken(String deviceTocken) {
    this.deviceTocken = deviceTocken;
    return this;
  }
  private String regtime;
  public String get_regtime() {
    return regtime;
  }
  public void set_regtime(String regtime) {
    this.regtime = regtime;
  }
  public QueryResult with_regtime(String regtime) {
    this.regtime = regtime;
    return this;
  }
  private String regIP;
  public String get_regIP() {
    return regIP;
  }
  public void set_regIP(String regIP) {
    this.regIP = regIP;
  }
  public QueryResult with_regIP(String regIP) {
    this.regIP = regIP;
    return this;
  }
  private String logintime;
  public String get_logintime() {
    return logintime;
  }
  public void set_logintime(String logintime) {
    this.logintime = logintime;
  }
  public QueryResult with_logintime(String logintime) {
    this.logintime = logintime;
    return this;
  }
  private String loginIP;
  public String get_loginIP() {
    return loginIP;
  }
  public void set_loginIP(String loginIP) {
    this.loginIP = loginIP;
  }
  public QueryResult with_loginIP(String loginIP) {
    this.loginIP = loginIP;
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
  private String unlocktime;
  public String get_unlocktime() {
    return unlocktime;
  }
  public void set_unlocktime(String unlocktime) {
    this.unlocktime = unlocktime;
  }
  public QueryResult with_unlocktime(String unlocktime) {
    this.unlocktime = unlocktime;
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
  private Long cnt_call;
  public Long get_cnt_call() {
    return cnt_call;
  }
  public void set_cnt_call(Long cnt_call) {
    this.cnt_call = cnt_call;
  }
  public QueryResult with_cnt_call(Long cnt_call) {
    this.cnt_call = cnt_call;
    return this;
  }
  private String model;
  public String get_model() {
    return model;
  }
  public void set_model(String model) {
    this.model = model;
  }
  public QueryResult with_model(String model) {
    this.model = model;
    return this;
  }
  private String imei;
  public String get_imei() {
    return imei;
  }
  public void set_imei(String imei) {
    this.imei = imei;
  }
  public QueryResult with_imei(String imei) {
    this.imei = imei;
    return this;
  }
  private Long cnt_order;
  public Long get_cnt_order() {
    return cnt_order;
  }
  public void set_cnt_order(Long cnt_order) {
    this.cnt_order = cnt_order;
  }
  public QueryResult with_cnt_order(Long cnt_order) {
    this.cnt_order = cnt_order;
    return this;
  }
  private Long cnt_badorder;
  public Long get_cnt_badorder() {
    return cnt_badorder;
  }
  public void set_cnt_badorder(Long cnt_badorder) {
    this.cnt_badorder = cnt_badorder;
  }
  public QueryResult with_cnt_badorder(Long cnt_badorder) {
    this.cnt_badorder = cnt_badorder;
    return this;
  }
  private Integer issend;
  public Integer get_issend() {
    return issend;
  }
  public void set_issend(Integer issend) {
    this.issend = issend;
  }
  public QueryResult with_issend(Integer issend) {
    this.issend = issend;
    return this;
  }
  private Integer warn_num;
  public Integer get_warn_num() {
    return warn_num;
  }
  public void set_warn_num(Integer warn_num) {
    this.warn_num = warn_num;
  }
  public QueryResult with_warn_num(Integer warn_num) {
    this.warn_num = warn_num;
    return this;
  }
  private String activedate;
  public String get_activedate() {
    return activedate;
  }
  public void set_activedate(String activedate) {
    this.activedate = activedate;
  }
  public QueryResult with_activedate(String activedate) {
    this.activedate = activedate;
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
    equal = equal && (this.pid == null ? that.pid == null : this.pid.equals(that.pid));
    equal = equal && (this.sessionKey == null ? that.sessionKey == null : this.sessionKey.equals(that.sessionKey));
    equal = equal && (this.phone == null ? that.phone == null : this.phone.equals(that.phone));
    equal = equal && (this.password == null ? that.password == null : this.password.equals(that.password));
    equal = equal && (this.email == null ? that.email == null : this.email.equals(that.email));
    equal = equal && (this.nick == null ? that.nick == null : this.nick.equals(that.nick));
    equal = equal && (this.gender == null ? that.gender == null : this.gender.equals(that.gender));
    equal = equal && (this.deviceTocken == null ? that.deviceTocken == null : this.deviceTocken.equals(that.deviceTocken));
    equal = equal && (this.regtime == null ? that.regtime == null : this.regtime.equals(that.regtime));
    equal = equal && (this.regIP == null ? that.regIP == null : this.regIP.equals(that.regIP));
    equal = equal && (this.logintime == null ? that.logintime == null : this.logintime.equals(that.logintime));
    equal = equal && (this.loginIP == null ? that.loginIP == null : this.loginIP.equals(that.loginIP));
    equal = equal && (this.status == null ? that.status == null : this.status.equals(that.status));
    equal = equal && (this.unlocktime == null ? that.unlocktime == null : this.unlocktime.equals(that.unlocktime));
    equal = equal && (this.channel == null ? that.channel == null : this.channel.equals(that.channel));
    equal = equal && (this.area == null ? that.area == null : this.area.equals(that.area));
    equal = equal && (this.cnt_call == null ? that.cnt_call == null : this.cnt_call.equals(that.cnt_call));
    equal = equal && (this.model == null ? that.model == null : this.model.equals(that.model));
    equal = equal && (this.imei == null ? that.imei == null : this.imei.equals(that.imei));
    equal = equal && (this.cnt_order == null ? that.cnt_order == null : this.cnt_order.equals(that.cnt_order));
    equal = equal && (this.cnt_badorder == null ? that.cnt_badorder == null : this.cnt_badorder.equals(that.cnt_badorder));
    equal = equal && (this.issend == null ? that.issend == null : this.issend.equals(that.issend));
    equal = equal && (this.warn_num == null ? that.warn_num == null : this.warn_num.equals(that.warn_num));
    equal = equal && (this.activedate == null ? that.activedate == null : this.activedate.equals(that.activedate));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.pid = JdbcWritableBridge.readLong(1, __dbResults);
    this.sessionKey = JdbcWritableBridge.readString(2, __dbResults);
    this.phone = JdbcWritableBridge.readString(3, __dbResults);
    this.password = JdbcWritableBridge.readString(4, __dbResults);
    this.email = JdbcWritableBridge.readString(5, __dbResults);
    this.nick = JdbcWritableBridge.readString(6, __dbResults);
    this.gender = JdbcWritableBridge.readBoolean(7, __dbResults);
    this.deviceTocken = JdbcWritableBridge.readString(8, __dbResults);
    this.regtime = JdbcWritableBridge.readString(9, __dbResults);
    this.regIP = JdbcWritableBridge.readString(10, __dbResults);
    this.logintime = JdbcWritableBridge.readString(11, __dbResults);
    this.loginIP = JdbcWritableBridge.readString(12, __dbResults);
    this.status = JdbcWritableBridge.readInteger(13, __dbResults);
    this.unlocktime = JdbcWritableBridge.readString(14, __dbResults);
    this.channel = JdbcWritableBridge.readInteger(15, __dbResults);
    this.area = JdbcWritableBridge.readInteger(16, __dbResults);
    this.cnt_call = JdbcWritableBridge.readLong(17, __dbResults);
    this.model = JdbcWritableBridge.readString(18, __dbResults);
    this.imei = JdbcWritableBridge.readString(19, __dbResults);
    this.cnt_order = JdbcWritableBridge.readLong(20, __dbResults);
    this.cnt_badorder = JdbcWritableBridge.readLong(21, __dbResults);
    this.issend = JdbcWritableBridge.readInteger(22, __dbResults);
    this.warn_num = JdbcWritableBridge.readInteger(23, __dbResults);
    this.activedate = JdbcWritableBridge.readString(24, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeLong(pid, 1 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeString(sessionKey, 2 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(phone, 3 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(password, 4 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(email, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(nick, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeBoolean(gender, 7 + __off, -7, __dbStmt);
    JdbcWritableBridge.writeString(deviceTocken, 8 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(regtime, 9 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(regIP, 10 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(logintime, 11 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(loginIP, 12 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(status, 13 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(unlocktime, 14 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeInteger(channel, 15 + __off, 5, __dbStmt);
    JdbcWritableBridge.writeInteger(area, 16 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeLong(cnt_call, 17 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeString(model, 18 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(imei, 19 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeLong(cnt_order, 20 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeLong(cnt_badorder, 21 + __off, -5, __dbStmt);
    JdbcWritableBridge.writeInteger(issend, 22 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeInteger(warn_num, 23 + __off, -6, __dbStmt);
    JdbcWritableBridge.writeString(activedate, 24 + __off, 12, __dbStmt);
    return 24;
  }
  public void readFields(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.pid = null;
    } else {
    this.pid = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.sessionKey = null;
    } else {
    this.sessionKey = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.phone = null;
    } else {
    this.phone = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.password = null;
    } else {
    this.password = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.email = null;
    } else {
    this.email = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.nick = null;
    } else {
    this.nick = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.gender = null;
    } else {
    this.gender = Boolean.valueOf(__dataIn.readBoolean());
    }
    if (__dataIn.readBoolean()) { 
        this.deviceTocken = null;
    } else {
    this.deviceTocken = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.regtime = null;
    } else {
    this.regtime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.regIP = null;
    } else {
    this.regIP = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.logintime = null;
    } else {
    this.logintime = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.loginIP = null;
    } else {
    this.loginIP = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.status = null;
    } else {
    this.status = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.unlocktime = null;
    } else {
    this.unlocktime = Text.readString(__dataIn);
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
        this.cnt_call = null;
    } else {
    this.cnt_call = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.model = null;
    } else {
    this.model = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.imei = null;
    } else {
    this.imei = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.cnt_order = null;
    } else {
    this.cnt_order = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.cnt_badorder = null;
    } else {
    this.cnt_badorder = Long.valueOf(__dataIn.readLong());
    }
    if (__dataIn.readBoolean()) { 
        this.issend = null;
    } else {
    this.issend = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.warn_num = null;
    } else {
    this.warn_num = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.activedate = null;
    } else {
    this.activedate = Text.readString(__dataIn);
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.pid) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.pid);
    }
    if (null == this.sessionKey) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, sessionKey);
    }
    if (null == this.phone) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, phone);
    }
    if (null == this.password) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, password);
    }
    if (null == this.email) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, email);
    }
    if (null == this.nick) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, nick);
    }
    if (null == this.gender) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeBoolean(this.gender);
    }
    if (null == this.deviceTocken) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, deviceTocken);
    }
    if (null == this.regtime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, regtime);
    }
    if (null == this.regIP) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, regIP);
    }
    if (null == this.logintime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, logintime);
    }
    if (null == this.loginIP) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, loginIP);
    }
    if (null == this.status) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.status);
    }
    if (null == this.unlocktime) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, unlocktime);
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
    if (null == this.cnt_call) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.cnt_call);
    }
    if (null == this.model) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, model);
    }
    if (null == this.imei) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, imei);
    }
    if (null == this.cnt_order) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.cnt_order);
    }
    if (null == this.cnt_badorder) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.cnt_badorder);
    }
    if (null == this.issend) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.issend);
    }
    if (null == this.warn_num) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.warn_num);
    }
    if (null == this.activedate) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, activedate);
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
    __sb.append(FieldFormatter.escapeAndEnclose(pid==null?"":"" + pid, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(sessionKey==null?"":sessionKey, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(phone==null?"":phone, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(password==null?"":password, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(email==null?"":email, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(nick==null?"":nick, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(gender==null?"":"" + gender, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(deviceTocken==null?"":deviceTocken, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(regtime==null?"":regtime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(regIP==null?"":regIP, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(logintime==null?"":logintime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(loginIP==null?"":loginIP, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(status==null?"":"" + status, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(unlocktime==null?"":unlocktime, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(channel==null?"":"" + channel, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(area==null?"":"" + area, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cnt_call==null?"":"" + cnt_call, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(model==null?"":model, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(imei==null?"":imei, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cnt_order==null?"":"" + cnt_order, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(cnt_badorder==null?"":"" + cnt_badorder, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(issend==null?"":"" + issend, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(warn_num==null?"":"" + warn_num, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(activedate==null?"":activedate, delimiters));
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.pid = null; } else {
      this.pid = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.sessionKey = null; } else {
      this.sessionKey = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.phone = null; } else {
      this.phone = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.password = null; } else {
      this.password = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.email = null; } else {
      this.email = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.nick = null; } else {
      this.nick = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.gender = null; } else {
      this.gender = BooleanParser.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.deviceTocken = null; } else {
      this.deviceTocken = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.regtime = null; } else {
      this.regtime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.regIP = null; } else {
      this.regIP = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.logintime = null; } else {
      this.logintime = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.loginIP = null; } else {
      this.loginIP = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.status = null; } else {
      this.status = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.unlocktime = null; } else {
      this.unlocktime = __cur_str;
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
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.cnt_call = null; } else {
      this.cnt_call = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.model = null; } else {
      this.model = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.imei = null; } else {
      this.imei = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.cnt_order = null; } else {
      this.cnt_order = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.cnt_badorder = null; } else {
      this.cnt_badorder = Long.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.issend = null; } else {
      this.issend = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.warn_num = null; } else {
      this.warn_num = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.activedate = null; } else {
      this.activedate = __cur_str;
    }

  }

  public Object clone() throws CloneNotSupportedException {
    QueryResult o = (QueryResult) super.clone();
    return o;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("pid", this.pid);
    __sqoop$field_map.put("sessionKey", this.sessionKey);
    __sqoop$field_map.put("phone", this.phone);
    __sqoop$field_map.put("password", this.password);
    __sqoop$field_map.put("email", this.email);
    __sqoop$field_map.put("nick", this.nick);
    __sqoop$field_map.put("gender", this.gender);
    __sqoop$field_map.put("deviceTocken", this.deviceTocken);
    __sqoop$field_map.put("regtime", this.regtime);
    __sqoop$field_map.put("regIP", this.regIP);
    __sqoop$field_map.put("logintime", this.logintime);
    __sqoop$field_map.put("loginIP", this.loginIP);
    __sqoop$field_map.put("status", this.status);
    __sqoop$field_map.put("unlocktime", this.unlocktime);
    __sqoop$field_map.put("channel", this.channel);
    __sqoop$field_map.put("area", this.area);
    __sqoop$field_map.put("cnt_call", this.cnt_call);
    __sqoop$field_map.put("model", this.model);
    __sqoop$field_map.put("imei", this.imei);
    __sqoop$field_map.put("cnt_order", this.cnt_order);
    __sqoop$field_map.put("cnt_badorder", this.cnt_badorder);
    __sqoop$field_map.put("issend", this.issend);
    __sqoop$field_map.put("warn_num", this.warn_num);
    __sqoop$field_map.put("activedate", this.activedate);
    return __sqoop$field_map;
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("pid".equals(__fieldName)) {
      this.pid = (Long) __fieldVal;
    }
    else    if ("sessionKey".equals(__fieldName)) {
      this.sessionKey = (String) __fieldVal;
    }
    else    if ("phone".equals(__fieldName)) {
      this.phone = (String) __fieldVal;
    }
    else    if ("password".equals(__fieldName)) {
      this.password = (String) __fieldVal;
    }
    else    if ("email".equals(__fieldName)) {
      this.email = (String) __fieldVal;
    }
    else    if ("nick".equals(__fieldName)) {
      this.nick = (String) __fieldVal;
    }
    else    if ("gender".equals(__fieldName)) {
      this.gender = (Boolean) __fieldVal;
    }
    else    if ("deviceTocken".equals(__fieldName)) {
      this.deviceTocken = (String) __fieldVal;
    }
    else    if ("regtime".equals(__fieldName)) {
      this.regtime = (String) __fieldVal;
    }
    else    if ("regIP".equals(__fieldName)) {
      this.regIP = (String) __fieldVal;
    }
    else    if ("logintime".equals(__fieldName)) {
      this.logintime = (String) __fieldVal;
    }
    else    if ("loginIP".equals(__fieldName)) {
      this.loginIP = (String) __fieldVal;
    }
    else    if ("status".equals(__fieldName)) {
      this.status = (Integer) __fieldVal;
    }
    else    if ("unlocktime".equals(__fieldName)) {
      this.unlocktime = (String) __fieldVal;
    }
    else    if ("channel".equals(__fieldName)) {
      this.channel = (Integer) __fieldVal;
    }
    else    if ("area".equals(__fieldName)) {
      this.area = (Integer) __fieldVal;
    }
    else    if ("cnt_call".equals(__fieldName)) {
      this.cnt_call = (Long) __fieldVal;
    }
    else    if ("model".equals(__fieldName)) {
      this.model = (String) __fieldVal;
    }
    else    if ("imei".equals(__fieldName)) {
      this.imei = (String) __fieldVal;
    }
    else    if ("cnt_order".equals(__fieldName)) {
      this.cnt_order = (Long) __fieldVal;
    }
    else    if ("cnt_badorder".equals(__fieldName)) {
      this.cnt_badorder = (Long) __fieldVal;
    }
    else    if ("issend".equals(__fieldName)) {
      this.issend = (Integer) __fieldVal;
    }
    else    if ("warn_num".equals(__fieldName)) {
      this.warn_num = (Integer) __fieldVal;
    }
    else    if ("activedate".equals(__fieldName)) {
      this.activedate = (String) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
}
