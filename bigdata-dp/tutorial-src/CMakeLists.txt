cmake_minimum_required (VERSION 2.6)
project (tutorial)

set(ROOT /home/didi/github/bigdata-dp/)
set(CMAKE_CXX_FLAGS "-g -pipe -std=c++0x -W -Wall -fPIC")
set(CMAKE_CXX_FLAGS_DEBUG "-O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(PROJECT_DIR /home/didi/CWorkSpace/tutorial-src/) 

file(GLOB_RECURSE CLIENT_SOURCES "client/*.cpp")
file(GLOB_RECURSE SERVICE_SOURCES "service/*.cpp")


set(TUTORIAL_THRIFT_MODULE ${PROJECT_DIR}/../tutorial-thrift/)
set(TUTORIAL_THRIFT_MODULE_INCLUDE ${TUTORIAL_THRIFT_MODULE}/output/include)
file(GLOB_RECURSE TUTORIAL_THRIFT_MODULE_LIB "${TUTORIAL_THRIFT_MODULE}/output/lib/*.a")

set(LIB_THRIFT_MODULE ${ROOT}/third-64/thrift/)
set(LIB_THRIFT_MODULE_INCLUDE ${LIB_THRIFT_MODULE}/include)
file(GLOB_RECURSE LIB_THRIFT_MODULE_LIB "${LIB_THRIFT_MODULE}/lib/*.a")

set(LIBBOOST_MODULE ${ROOT}/third-64/boost)
set(LIBBOOST_MODULE_INCLUDE ${LIBBOOST_MODULE}/include)
file(GLOB_RECURSE LIBBOOST_MODULE_LIB "${LIBBOOST_MODULE}/lib/*.a")

set(LOG4CPLUS_MODULE ${ROOT}/third-64/log4cplus)
set(LOG4CPLUS_MODULE_INCLUDE ${LOG4CPLUS_MODULE}/include)
file(GLOB_RECURSE LOG4CPLUS_MODULE_LIB "${LOG4CPLUS_MODULE}/lib/*.a")

set(LIB_PROTO_BUFF_MODULE ${ROOT}/third-64/protobuf)
set(LIB_PROTO_BUFF_MODULE_INCLUDE ${LIB_PROTO_BUFF_MODULE}/include)
file(GLOB_RECURSE LIB_PROTO_BUFF_MODULE_LIB "${LIB_PROTO_BUFF_MODULE}/lib/*.a")

include_directories(
    ${TUTORIAL_THRIFT_MODULE_INCLUDE}
    ${LIBBOOST_MODULE_INCLUDE}
    ${LOG4CPLUS_MODULE_INCLUDE}
    ${LIB_THRIFT_MODULE_INCLUDE}
    ${LIB_PROTO_BUFF_MODULE_INCLUDE})

add_executable(tutorial-service ${SERVICE_SOURCES})

target_link_libraries(tutorial-service
    ${TUTORIAL_THRIFT_MODULE_LIB}
    ${LIBCONFIG_MODULE_LIB}
    ${LIB_THRIFT_MODULE_LIB}
    ${LIBBOOST_MODULE_LIB}
    ${LOG4CPLUS_MODULE_LIB}
    pthread
    rt)

add_executable(tutorial-client ${CLIENT_SOURCES})

target_link_libraries(tutorial-client
    ${TUTORIAL_THRIFT_MODULE_LIB}
    ${LIBCONFIG_MODULE_LIB}
    ${LIB_THRIFT_MODULE_LIB}
    ${LIBBOOST_MODULE_LIB}
    ${LOG4CPLUS_MODULE_LIB}
    pthread
    rt)

