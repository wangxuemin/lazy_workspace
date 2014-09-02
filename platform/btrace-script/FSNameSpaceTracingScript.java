/* BTrace Script Template */
package org.apache.hadoop.hdfs.server.namenode;

import com.sun.btrace.annotations.*;
import static com.sun.btrace.BTraceUtils.*;

import java.util.List;
import java.lang.reflect.Field;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FileContext;
import org.apache.hadoop.fs.FileStatus;

import org.apache.hadoop.hdfs.server.namenode.FSPermissionChecker;
import org.apache.hadoop.fs.permission.FsAction;
import org.apache.hadoop.security.UserGroupInformation;
@BTrace
public class FSNameSpaceTracingScript {
    /* put your code here */
    /*指明要查看的方法，类*/
    @OnMethod(
            clazz="org.apache.hadoop.hdfs.server.namenode.FSNamesystem",
            method="checkPermission",
location=@Location(Kind.RETURN)
            )
        /*主要两个参数是对象自己的引用 和 返回值，其它参数都是方法调用时传入的参数*/
public static void  trace (FSPermissionChecker pc,String path, boolean doCheckOwner, FsAction ancestorAccess,FsAction parentAccess, FsAction access, FsAction subAccess,boolean resolveLink){
println("_________________________");
println(str( path ));
Field field = field(classOf(pc),"user");
java.lang.Object user=get(field,pc) ;
println(str( user ));

field = field(classOf(pc),"groups");
java.lang.Object groups=get(field,pc) ;
println(str( groups ));
field = field(classOf(pc),"ugi");
java.lang.Object ugi=get(field,pc) ;
//
//Field f2= field( classOf( obj), "YARN_PREFIX" );
//println(str( get(f2,obj) ));


//printFields(root,false);
//jstack();
        }

    @OnMethod(
            clazz="org.apache.hadoop.security.UserGroupInformation",
            method="getCurrentUser",
location=@Location(Kind.RETURN)
            )
        /*主要两个参数是对象自己的引用 和 返回值，其它参数都是方法调用时传入的参数*/
public static void  trace1 ( @Return UserGroupInformation ugi ){
//println("_________________________");
//printFields( ugi, false );
}
    @OnMethod(
            clazz="org.apache.hadoop.hdfs.server.namenode.FSNamesystem",
            method="getTotal",
location=@Location(Kind.RETURN)
            )
        /*主要两个参数是对象自己的引用 和 返回值，其它参数都是方法调用时传入的参数*/
public static void  trace2 (){
println("_________________________");
}
}
