include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../..)

set(generator_dump_SRC
    generator_dump.cpp)

add_library(generator_dump MODULE ${generator_dump_SRC})
target_link_libraries(generator_dump ${QT_QTCORE_LIBRARY} smokegen)
set_target_properties(generator_dump PROPERTIES PREFIX "")

install(TARGETS generator_dump LIBRARY DESTINATION ${LIB_INSTALL_DIR}/smokegen)
