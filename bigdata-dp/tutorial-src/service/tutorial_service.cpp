#include <thrift/concurrency/ThreadManager.h>
#include <thrift/concurrency/PosixThreadFactory.h>
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TSimpleServer.h>
#include <thrift/server/TThreadPoolServer.h>
#include <thrift/server/TThreadedServer.h>
#include <thrift/transport/TServerSocket.h>
#include <thrift/transport/TTransportUtils.h>
//#include <thrift/TToString.h>

#include <boost/thread/thread.hpp>

#include <iostream>
#include <stdexcept>
#include <sstream>

#include "Calculator.h"

using namespace std;
using namespace apache::thrift;
using namespace apache::thrift::concurrency;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;
using namespace apache::thrift::server;

using namespace tutorial;
using namespace shared;

class CalculatorHandler : public CalculatorIf {
	boost::shared_ptr<boost::thread> monitor_thread;
	public:
		CalculatorHandler() {
			monitor_thread.reset(new boost::thread(&CalculatorHandler::do_monitor_work, this));
		}

		void do_monitor_work()
		{
			while( true )
			{
				sleep(3);
				printf("Call do_monitor_work()\n");
				// if( master is reachable )
				// 转发backup数据,更新标记
				ping();

			}
		}

		//void do_data_rsync_work(request)
		//{
		//	transport.open();
		//	master_client.sendMessage(request);	
		//	transport.close();
		//}

		void ping() { cerr << "ping()" << endl; }

		int32_t add(const int32_t n1, const int32_t n2) {
			//cerr << "add(" << n1 << ", " << n2 << ")" << endl;
			return n1 + n2;
		}

		int32_t calculate(const int32_t logid, const Work& work) {
			//cerr << "calculate(" << logid << ", " << work << ")" << endl;
			int32_t val;

			switch (work.op) {
				case Operation::ADD:
					val = work.num1 + work.num2;
					break;
				case Operation::SUBTRACT:
					val = work.num1 - work.num2;
					break;
				case Operation::MULTIPLY:
					val = work.num1 * work.num2;
					break;
				case Operation::DIVIDE:
					if (work.num2 == 0) {
						InvalidOperation io;
						io.what = work.op;
						io.why = "Cannot divide by 0";
						throw io;
					}
					val = work.num1 / work.num2;
					break;
				default:
					InvalidOperation io;
					io.what = work.op;
					io.why = "Invalid Operation";
					throw io;
			}

			SharedStruct ss;
			ss.key = logid;
			ss.value = to_string(val);

			log[logid] = ss;

			return val;
		}

		void getStruct(SharedStruct& ret, const int32_t logid) {
			//cerr << "getStruct(" << logid << ")" << endl;
			ret = log[logid];
		}

		void zip() { //cerr << "zip()" << endl;
		}

	protected:
		map<int32_t, SharedStruct> log;
};

int main() {
	boost::shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());
	boost::shared_ptr<CalculatorHandler> handler(new CalculatorHandler());
	boost::shared_ptr<TProcessor> processor(new CalculatorProcessor(handler));
	boost::shared_ptr<TServerTransport> serverTransport(new TServerSocket(9090));
	boost::shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());

	TSimpleServer server(processor, serverTransport, transportFactory, protocolFactory);

	/**
	 * Or you could do one of these

	 const int workerCount = 4;

	 boost::shared_ptr<ThreadManager> threadManager =
	 ThreadManager::newSimpleThreadManager(workerCount);
	 boost::shared_ptr<PosixThreadFactory> threadFactory =
	 boost::shared_ptr<PosixThreadFactory>(new PosixThreadFactory());
	 threadManager->threadFactory(threadFactory);
	 threadManager->start();
	 TThreadPoolServer server(processor,
	 serverTransport,
	 transportFactory,
	 protocolFactory,
	 threadManager);

	 TThreadedServer server(processor,
	 serverTransport,
	 transportFactory,
	 protocolFactory);

	 */

	printf("Starting the server...\n");
	server.serve();
	printf("Done...\n");
	return 0;
}
