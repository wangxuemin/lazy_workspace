/* BTrace Script Template */
import com.sun.btrace.annotations.*;
import static com.sun.btrace.BTraceUtils.*;

import java.util.List;
import java.lang.reflect.Field;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.FileContext;
import org.apache.hadoop.fs.FileStatus;

@BTrace
public class TracingScript {
    /* put your code here */
    /*指明要查看的方法，类*/
    @OnMethod(
            clazz="org.apache.hadoop.mapreduce.v2.jobhistory.JobHistoryUtils",
            method="localGlobber",
location=@Location(Kind.RETURN)
            )
        /*主要两个参数是对象自己的引用 和 返回值，其它参数都是方法调用时传入的参数*/
public static void  trace (FileContext fc, Path root, String tail, @Return List<FileStatus> ret){
println("_________________________");
Field f1 = field(classOf(fc),"workingDir");
//printFields(f1,false);
//println(str( get(f1,fc) ));
java.lang.Object obj=get(f1,fc) ;

printFields( obj,false );

//Field f2= field( classOf( obj), "YARN_PREFIX" );
//println(str( get(f2,obj) ));


printFields(root,false);
            jstack();
        }

    @OnMethod(
            clazz="com.ddc.mem.CaseObject",
            method="display",
            location=@Location(Kind.RETURN)
            )
        /*主要两个参数是对象自己的引用 和 返回值，其它参数都是方法调用时传入的参数*/
public static void trace1 ( ){

println("_________________________");
            jstack();
        }
}
