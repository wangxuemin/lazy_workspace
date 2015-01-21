cmake_minimum_required (VERSION 2.6)
project (tutorial-thrift)

set(ROOT /home/didi/github/bigdata-dp/)
set(CMAKE_CXX_FLAGS "-g -pipe -std=c++0x -W -Wall -fPIC")
set(CMAKE_CXX_FLAGS_DEBUG "-O0")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")
set(PROJECT_DIR /home/didi/CWorkSpace/tutorial-thrift)

set(BOOST_MODULE ${ROOT}/third-64/boost/)
set(BOOST_MODULE_INCLUDE ${BOOST_MODULE}/include)
file(GLOB_RECURSE BOOST_MODULE_LIB "${BOOST_MODULE}/lib/*.a")

set(THRIFT_MODULE ${ROOT}/third-64/thrift)
set(THRIFT_MODULE_INCLUDE ${THRIFT_MODULE}/include)
file(GLOB_RECURSE THRIFT_MODULE_LIB "${THRIFT_MODULE}/lib/libthrift.a")

set(THRIFT_COMPILER ${THRIFT_MODULE}/bin/thrift)
file(GLOB_RECURSE SERVICE_THRIFT_FILE "*.thrift")
message ("thrift file" ${SERVICE_THRIFT_FILE})


foreach (MY_THRIFT ${SERVICE_THRIFT_FILE})
    file(RELATIVE_PATH file_name ${PROJECT_DIR} ${MY_THRIFT})
    execute_process(COMMAND ${THRIFT_COMPILER} --gen cpp -o ${PROJECT_DIR}/output  ${MY_THRIFT})
    file(GLOB_RECURSE SKELETON_FILE "${PROJECT_DIR}/output/gen-cpp/*.skeleton.cpp")
    file(REMOVE ${SKELETON_FILE})

  
endforeach(MY_THRIFT)

file(GLOB_RECURSE SERVICE_SOURCES "${PROJECT_DIR}/output/*.cpp")

include_directories(
    src
    ${PROJECT_DIR}/output
    ${BOOST_MODULE_INCLUDE}
    ${THRIFT_MODULE_INCLUDE})

add_library(tutorial-thrift ${SERVICE_SOURCES})

target_link_libraries(tutorial-thrift
    ${THRIFT_MODULE_LIB}
    ${BOOST_MODULE_LIB}
    pthread
    crypto
    rt)

file(GLOB_RECURSE LIB_HEADERS "${PROJECT_DIR}/output/*.h")

install(TARGETS tutorial-thrift DESTINATION ${PROJECT_DIR}/output/lib)
install(FILES ${LIB_HEADERS} DESTINATION ${PROJECT_DIR}/output/include)
