cmake_minimum_required (VERSION 2.6)
project (coord-dispatcher)

set(ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../..)
#set(CMAKE_CXX_FLAGS "-g -O0 -pipe -std=c++0x -W -Wall -fPIC")
#set(CMAKE_CXX_FLAGS "-g -pipe -std=c++0x -W -Wall -fPIC")
IF(NOT CMAKE_BUILD_TYPE)
	SET(CMAKE_BUILD_TYPE  Debug)
ENDIF(NOT CMAKE_BUILD_TYPE)
set(CMAKE_CXX_FLAGS "-pipe -std=c++0x -W -Wall -fPIC -g")
set(CMAKE_CXX_FLAGS_DEBUG "-O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(PROJECT_DIR  ${CMAKE_CURRENT_SOURCE_DIR}) 

set(LOG4CPLUS_MODULE ${ROOT}/third-64/log4cplus)
set(LOG4CPLUS_MODULE_INCLUDE ${LOG4CPLUS_MODULE}/include)
file(GLOB_RECURSE LOG4CPLUS_MODULE_LIB "${LOG4CPLUS_MODULE}/lib/*.a")

set(LIBCONFIG_MODULE ${ROOT}/third-64/libconfig)
set(LIBCONFIG_MODULE_INCLUDE ${LIBCONFIG_MODULE}/include)
file(GLOB_RECURSE LIBCONFIG_MODULE_LIB "${LIBCONFIG_MODULE}/lib/*.a")

set(BOOST_MODULE ${ROOT}/third-64/boost/)
set(BOOST_MODULE_INCLUDE ${BOOST_MODULE}/include)
file(GLOB_RECURSE BOOST_MODULE_LIB "${BOOST_MODULE}/lib/*.a")

#set(JSON_MODULE ${ROOT}/third-64/json-cpp)
#set(JSON_MODULE_INCLUDE ${JSON_MODULE}/include)
#file(GLOB_RECURSE JSON_MODULE_LIB "${JSON_MODULE}/lib/*.a")

#set(GTEST_MODULE ${ROOT}/third-64/gtest)
#set(GTEST_MODULE_INCLUDE ${GTEST_MODULE}/include)
#file(GLOB_RECURSE GTEST_MODULE_LIB "${GTEST_MODULE}/lib/*.a")
#
#set(GMOCK_MODULE ${ROOT}/third-64/gmock)
#set(GMOCK_MODULE_INCLUDE ${GMOCK_MODULE}/include)
#file(GLOB_RECURSE GMOCK_MODULE_LIB "${GMOCK_MODULE}/lib/libgmock.a")

set(GEOS_MODULE ${ROOT}/third-64/geos)
set(GEOS_MODULE_INCLUDE ${GEOS_MODULE}/include)
file(GLOB_RECURSE GEOS_MODULE_LIB "${GEOS_MODULE}/lib/libgeos.a")

set(THRIFT_MODULE ${ROOT}/third-64/thrift)
set(THRIFT_MODULE_INCLUDE ${THRIFT_MODULE}/include)
file(GLOB_RECURSE THRIFT_MODULE_LIB "${THRIFT_MODULE}/lib/*.a")

set(ITS_PROTO_MODULE ${ROOT}/its/its-proto/)
set(ITS_PROTO_MODULE_INCLUDE ${ITS_PROTO_MODULE}/output/include)
file(GLOB_RECURSE ITS_PROTO_MODULE_LIB "${ITS_PROTO_MODULE}/output/lib/*.a") 

set(ITS_THRIFT_MODULE ${ROOT}/its/its-thrift/)
set(ITS_THRIFT_MODULE_INCLUDE ${ITS_THRIFT_MODULE}/output/include)
file(GLOB_RECURSE ITS_THRIFT_MODULE_LIB "${ITS_THRIFT_MODULE}/output/lib/*.a")

set(ITS_LIB_MODULE ${ROOT}/its/its-lib)
set(ITS_LIB_MODULE_INCLUDE ${ITS_LIB_MODULE}/output/include)
file(GLOB_RECURSE ITS_LIB_MODULE_LIB "${ITS_LIB_MODULE}/output/lib/*.a")

set(MUDUO_MODULE ${ROOT}/third-64/muduo)
set(MUDUO_MODULE_INCLUDE ${MUDUO_MODULE}/include)
file(GLOB_RECURSE MUDUO_MODULE_LIB "${MUDUO_MODULE}/lib/*.a")

set(CONHASH_MODULE ${ROOT}/third-64/libconhash)
set(CONHASH_MODULE_INCLUDE ${CONHASH_MODULE}/include)
file(GLOB_RECURSE CONHASH_MODULE_LIB "${CONHASH_MODULE}/lib/*.a")


file(GLOB_RECURSE DD_SOURCES 
    "src/*.cpp" 
    "third/push_sdk/src/*.cc"
    "third/push_sdk/src/*.cpp"
    )
#file(GLOB_RECURSE CORE_HEADERS "src/core/*.h")
#file(GLOB_RECURSE CONSOLE_SOURCES "src/console/*.cpp")
#file(GLOB_RECURSE SERVICE_SOURCES "src/service/*.cpp" "output/gen-cpp/*.cpp")
#file(GLOB_RECURSE CLIENT_SOURCES  "src/client/*.cpp" "output/gen-cpp/*.cpp")
#file(GLOB_RECURSE CONFS "conf/*.conf")

include_directories(
    "src"
    ${BOOST_MODULE_INCLUDE}
    ${THRIFT_MODULE_INCLUDE}
    ${MUDUO_MODULE_INCLUDE}
    ${LIBCONFIG_MODULE_INCLUDE}
    ${LOG4CPLUS_MODULE_INCLUDE}
    ${GEOS_MODULE_INCLUDE}
    ${CONHASH_MODULE_INCLUDE}
    third/push_sdk/src #include .protocol buffer file from loc_proxy
    ${ROOT}/third-64/protobuf/include/
    ${GTEST_MODULE_INCLUDE}
    ${ITS_PROTO_MODULE_INCLUDE}
    ${ITS_THRIFT_MODULE_INCLUDE}
    ${ITS_LIB_MODULE_INCLUDE}
    )

add_executable(coord-dispatcher ${DD_SOURCES})

target_link_libraries(coord-dispatcher
    ${ITS_PROTO_MODULE_LIB}
    ${ITS_LIB_MODULE_LIB}
    ${ITS_THRIFT_MODULE_LIB}
    ${THRIFT_MODULE_LIB}
    ${BOOST_MODULE_LIB}
    ${MUDUO_MODULE}/lib/libmuduo_net_cpp11.a
    ${MUDUO_MODULE}/lib/libmuduo_base_cpp11.a
    ${LIBCONFIG_MODULE_LIB}
    ${LOG4CPLUS_MODULE_LIB}
    ${GEOS_MODULE_LIB}
    ${CONHASH_MODULE_LIB}
    ${ROOT}/third-64/protobuf/lib/libprotobuf.a
    pthread
    crypto
    rt)

add_subdirectory(test)
