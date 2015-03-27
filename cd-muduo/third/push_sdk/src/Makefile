CPP = g++
CPPFLAGS = -g -Wall -Wunused-parameter \
		   -I$(HOME)/Code/protobuf/include/ \
		   -I$(HOME)/Code/libevent/include \
		   -I$(HOME)/Code/libtomcrypt/include
LDFLAGS =  -L$(HOME)/Code/protobuf/staticlib/ \
		   -L$(HOME)/Code/libevent/staticlib/ \
		   -L$(HOME)/Code/libtomcrypt/staticlib/ \
		   -lprotobuf -levent -ltomcrypt -lpthread -lrt

all : libPushConnector.a testserver testcli

testserver : didi_protocol_helper.o didi_protocol.pb.o didi_protocol_common.pb.o \
	didi_protocol_pushsvr.pb.o didi_protocol_collectsvr.pb.o \
	didi_protocol_dispatchsvr.pb.o testserver.o
	g++ -o $@ testserver.o didi_protocol_common.pb.o didi_protocol_helper.o didi_protocol.pb.o \
		didi_protocol_pushsvr.pb.o didi_protocol_dispatchsvr.pb.o \
		didi_protocol_collectsvr.pb.o $(LDFLAGS)

testcli : testcli.o didi_protocol_common.pb.o didi_protocol_pushsvr.pb.o \
	didi_protocol_dispatchsvr.pb.o didi_protocol_collectsvr.pb.o \
	libPushConnector.a
	g++ -o $@ testcli.o didi_protocol_common.pb.o didi_protocol_pushsvr.pb.o \
		didi_protocol_dispatchsvr.pb.o didi_protocol_collectsvr.pb.o \
		libPushConnector.a $(LDFLAGS)

testcli.o : testcli.cpp
	$(CPP) $(CPPFLAGS) -o $@ -c $<

testserver.o : testserver.cpp
	$(CPP) $(CPPFLAGS) -o $@ -c $<

libPushConnector.a : didi_protocol_helper.o didi_protocol.pb.o push_connector.o crypto.o
	ar -r $@ $^

didi_protocol.pb.h : didi_protocol.proto
	$(HOME)/Code/protobuf/bin/protoc --cpp_out=./ -I./ $<

didi_protocol_common.pb.h : didi_protocol_common.proto
	$(HOME)/Code/protobuf/bin/protoc --cpp_out=./ -I./ $<

didi_protocol_pushsvr.pb.h : didi_protocol_pushsvr.proto
	$(HOME)/Code/protobuf/bin/protoc --cpp_out=./ -I./ $<

didi_protocol_dispatchsvr.pb.h : didi_protocol_dispatchsvr.proto
	$(HOME)/Code/protobuf/bin/protoc --cpp_out=./ -I./ $<

didi_protocol_collectsvr.pb.h : didi_protocol_collectsvr.proto
	$(HOME)/Code/protobuf/bin/protoc --cpp_out=./ -I./ $<

didi_protocol_helper.o : didi_protocol_helper.cpp didi_protocol.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c $<

didi_protocol.pb.o : didi_protocol.pb.cc didi_protocol.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c $<

didi_protocol_common.pb.o : didi_protocol_common.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c didi_protocol_common.pb.cc

didi_protocol_pushsvr.pb.o : didi_protocol_pushsvr.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c didi_protocol_pushsvr.pb.cc

didi_protocol_dispatchsvr.pb.o : didi_protocol_dispatchsvr.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c didi_protocol_dispatchsvr.pb.cc

didi_protocol_collectsvr.pb.o : didi_protocol_collectsvr.pb.h
	$(CPP) $(CPPFLAGS) -o $@ -c didi_protocol_collectsvr.pb.cc

push_connector.o : push_connector.cpp
	$(CPP) $(CPPFLAGS) -o $@ -c $<

crypto.o : crypto.cpp
	$(CPP) $(CPPFLAGS) -o $@ -c $<

clean :
	rm -fr *.o libPushConnector.a testserver testcli \
		didi_protocol_pushsvr.pb.* didi_protocol_dispatchsvr.pb.* \
		didi_protocol_collectsvr.pb.* didi_protocol_common.pb.*
