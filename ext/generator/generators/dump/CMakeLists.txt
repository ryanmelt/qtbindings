include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../..)

set(generator_dump_SRC
    generator_dump.cpp)

add_library(generator_dump MODULE ${generator_dump_SRC})
target_link_libraries(generator_dump ${QT_QTCORE_LIBRARY} smokegen)
set_target_properties(generator_dump PROPERTIES PREFIX "")

if (WIN32)
	# Realign the stack, for compatibility with an older ABI.
	if(CMAKE_COMPILER_IS_GNUCXX)
		set_target_properties(generator_dump PROPERTIES COMPILE_FLAGS -mstackrealign)
	endif()
endif (WIN32)

install(TARGETS generator_dump LIBRARY DESTINATION ${LIB_INSTALL_DIR}/smokegen)
