#project name
PROJECT(communication_demo)
#head file path
INCLUDE_DIRECTORIES(
include
)
#source directory
AUX_SOURCE_DIRECTORY(src DIR_SRCS)
AUX_SOURCE_DIRECTORY(src/client CLIENT_SRCS)
AUX_SOURCE_DIRECTORY(src/server SERVER_SRCS)
#set environment variable
SET(ROOT .
)
#set extern libraries
SET(LIBRARIES
)
#add executable file
ADD_EXECUTABLE(${ROOT}/bin/client ${CLIENT_SRCS})
#add link library
TARGET_LINK_LIBRARIES(${ROOT}/bin/client ${LIBRARIES})

#add executable file
ADD_EXECUTABLE(${ROOT}/bin/server ${SERVER_SRCS})
#add link library
TARGET_LINK_LIBRARIES(${ROOT}/bin/server ${LIBRARIES})
