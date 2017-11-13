# 检索指定目录下的源代码文件并存放在src_list中

aux_source_directory(. SRC_LIST)
# aux_source_directory(./dir SRC_DIR_LIST)
# list(append src_list ${SRC_DIR_LIST})
# 添加动态库
add_library(utils SHARED ${SRC_LIST})
#add_library(utils_static static ${SRC_LIST})


# 生成动态库版本号
set_target_properties(utils PROPERTIES VERSION 1.2 SOVERSION 1)
#set_target_properties(utils_static PROPERTIES VERSION 1.2 soversion 1)
#set_target_properties(utils_static properties OUTPUT_NAME "utils")

message(STATUS ${PROJECT_SOURCE_DIR})
#安装静态库及动态库
install(
  TARGETS utils 
  LIBRARY DESTINATION ${PROJECT_SOURCE_DIR}/lib
  ARCHIVE DESTINATION ${PROJECT_SOURCE_DIR}/lib
  )
#安装头文件


