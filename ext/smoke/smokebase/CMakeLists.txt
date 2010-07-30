IF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")
    ADD_DEFINITIONS(-DGCC_VISIBILITY)
ENDIF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")

include_directories (${CMAKE_CURRENT_SOURCE_DIR}/..)

add_library(smokebase SHARED smokebase.cpp)
target_link_libraries(smokebase)
set_target_properties(smokebase PROPERTIES VERSION 3.0.0 SOVERSION 3)

install(TARGETS smokebase DESTINATION ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX})
