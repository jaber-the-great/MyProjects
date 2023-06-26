cmake_minimum_required(VERSION 2.8)
project(tests)

find_library(layer0 STATIC)
find_library(layer1 STATIC)

add_library(tests test1.c test2.c)


add_executable(test1 test1.c)
target_link_libraries(test1 layer0)
target_link_libraries(test1 layer1)

add_executable(test2 test2.c)
target_link_libraries(test2 layer0)
target_link_libraries(test2 layer1)

add_executable(test3 test3.c)
target_link_libraries(test3 layer0)
target_link_libraries(test3 layer1)