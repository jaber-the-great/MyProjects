cmake_minimum_required(VERSION 2.8)
project(fuse)

find_library(layer0 STATIC)
find_library(layer1 STATIC)


add_library(fuse hello.c)

target_link_libraries(fuse layer0)
target_link_libraries(fuse layer1)


# add_executable(helloworld3 helloworld3.c)


add_executable(hello hello.c)
# target_link_libraries(hello layer0)
# target_link_libraries(hello layer1)

