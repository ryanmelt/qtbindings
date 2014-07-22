
set( EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR} )
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/testconfig.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/testconfig.h)


########### next target ###############

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR}/../rpp ${QT_INCLUDES} ${CMAKE_CURRENT_BINARY_DIR})

set(parsertest_SRCS test_parser.cpp)

QT4_GENERATE_MOC(${parsertest_SRCS} test_parser.moc)
add_executable(parsertest ${parsertest_SRCS} test_parser.moc)

if (WIN32)
	# Realign the stack, for compatibility with an older ABI.
	if(CMAKE_COMPILER_IS_GNUCXX)
		set_target_properties(parsertest PROPERTIES COMPILE_FLAGS -mstackrealign)
	endif()
endif (WIN32)

target_link_libraries(parsertest ${QT_QTCORE_LIBRARY} ${QT_QTTEST_LIBRARY} cppparser)

########### next target ###############

set(generatortest_SRCS test_generator.cpp)

QT4_GENERATE_MOC(${generatortest_SRCS} test_generator.moc)
add_executable(generatortest ${generatortest_SRCS} test_generator.moc)
if (WIN32)
	# Realign the stack, for compatibility with an older ABI.
	set_target_properties (generatortest PROPERTIES COMPILE_FLAGS -mstackrealign)
endif (WIN32)

target_link_libraries(generatortest ${QT_QTCORE_LIBRARY} ${QT_QTTEST_LIBRARY} cppparser)

########### next target ###############

set(pooltest_SRCS test_pool.cpp)

QT4_GENERATE_MOC(test_pool.h test_pool.moc)
add_executable(pooltest ${pooltest_SRCS} test_pool.moc)
if (WIN32)
	if(CMAKE_COMPILER_IS_GNUCXX)
		set_target_properties(pooltest PROPERTIES COMPILE_FLAGS -mstackrealign)
	endif()
endif (WIN32)

target_link_libraries(pooltest ${QT_QTCORE_LIBRARY} ${QT_QTTEST_LIBRARY} cppparser)
