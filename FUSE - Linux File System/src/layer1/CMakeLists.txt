cmake_minimum_required(VERSION 2.8)
project(layer1)


find_library(layer0 STATIC)

add_library(layer1 inode_manipulation.c inode_manipulation.h)
target_link_libraries(layer1 layer0)


add_executable(inode_test inode_test.c)
target_link_libraries(inode_test layer0)
target_link_libraries(inode_test layer1)

add_executable(inode_test2 inode_test2.c)
target_link_libraries(inode_test2 layer0)
target_link_libraries(inode_test2 layer1)

add_executable(inode_test3 inode_test3.c)
target_link_libraries(inode_test3 layer0)
target_link_libraries(inode_test3 layer1)

add_executable(inode_test4 inode_test4.c)
target_link_libraries(inode_test4 layer0)
target_link_libraries(inode_test4 layer1)