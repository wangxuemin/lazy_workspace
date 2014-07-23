package xiaoju.platform.storm.examples;

public class kafkaSink {
/*	 public class KafkaSink extends AbstractSinkimplementsConfigurable {  
	       
	      private static final Log logger = LogFactory.getLog(KafkaSink.class);  
	       
	      private Stringtopic;  
	      private Producer<String, String>producer;  
	       
	   
	      @Override  
	      public Status process()throwsEventDeliveryException {  
	            
	            Channel channel =getChannel();  
	         Transaction tx =channel.getTransaction();  
	         try {  
	                 tx.begin();  
	                 Event e = channel.take();  
	                 if(e ==null) {  
	                         tx.rollback();  
	                         return Status.BACKOFF;  
	                 }  
	                 KeyedMessage<String,String> data = new KeyedMessage<String, String>(topic,newString(e.getBody()));  
	                 producer.send(data);  
	                 logger.info("Message: {}"+new String( e.getBody()));  
	                 tx.commit();  
	                 return Status.READY;  
	         } catch(Exceptione) {  
	           logger.error("KafkaSinkException:{}",e);  
	                 tx.rollback();  
	                 return Status.BACKOFF;  
	         } finally {  
	                 tx.close();  
	         }  
	      }  
	   
	      @Override  
	      public void configure(Context context) {  
	           topic = "kafka";  
	            Properties props = newProperties();  
	                props.setProperty("metadata.broker.list","xx.xx.xx.xx:9092");  
	             props.setProperty("serializer.class","kafka.serializer.StringEncoder");  
//	           props.setProperty("producer.type", "async");  
//	           props.setProperty("batch.num.messages", "1");  
	              props.put("request.required.acks","1");  
	              ProducerConfigconfig = new ProducerConfig(props);  
	              producer = newProducer<String, String>(config);  
	      }  
	}  
	 */
}
