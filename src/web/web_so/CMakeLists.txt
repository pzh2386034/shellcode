
aux_source_directory(. HELLO_SRC_LIST)
message(STATUS ${HELLO_SRC_LIST})
add_library(helloworld SHARED ${HELLO_SRC_LIST})
set_target_properties(helloworld PROPERTIES VERSION 1.2 soversion 1)
install(
  TARGETS helloworld 
  LIBRARY DESTINATION ${PROJECT_SOURCE_DIR}/lib
  ARCHIVE DESTINATION ${PROJECT_SOURCE_DIR}/lib
  )
