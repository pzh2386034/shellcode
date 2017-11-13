PROJECT(web_struct)
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

#指定c, cpp编译器
set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")
#设置基本的编译参数
set(CMAKE_C_FLAGS "-g -pthread -o1")
set(CMAKE_CXX_FLAGS "-g -std=c++11 -pthread")
add_definitions("-Wall -ansi")
if(DEBUG_mode)
  add_definitions("-g")
endif()

include_directories(
  ${PROJECT_SOURCE_DIR}/src/include
  /usr/include
  /usr/local/include
  )

#设置依赖库目录
link_directories(
  ${PROJECT_SOURCE_DIR}/lib
  /usr/lib
  /usr/local/lib
  )
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
add_subdirectory(src/utility)
add_subdirectory(src/web/web_so)
