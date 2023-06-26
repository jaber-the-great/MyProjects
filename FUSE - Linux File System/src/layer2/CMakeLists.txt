cmake_minimum_required(VERSION 2.8)
project(layer2)

#find_library(layer0 STATIC)
find_library(layer1 STATIC)

#target_link_libraries(layer2 layer0)
#target_link_libraries(layer2 layer1)

add_library(layer2 file_abstraction.c file_abstraction.h)

add_executable(helloworld3 helloworld3.c)


