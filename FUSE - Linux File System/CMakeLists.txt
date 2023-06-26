cmake_minimum_required(VERSION 2.8)
project(FileSystemProject)

SET(ORGANIZATION_NAME "UCSB")
SET(CMAKE_CXX_FLAGS "-g -Wall -D_FILE_OFFSET_BITS=64 `pkg-config fuse --cflags --libs`") 

ENABLE_TESTING()

include_directories(src/layer0)
include_directories(src/layer1)
# include_directories(src/layer2)
include_directories(src/fuse)
include_directories(src/tests)

add_subdirectory(src/layer0)
add_subdirectory(src/layer1)
# add_subdirectory(src/layer2)
add_subdirectory(src/fuse)
add_subdirectory(src/tests)
