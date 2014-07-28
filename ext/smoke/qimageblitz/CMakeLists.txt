if (NOT QIMAGEBLITZ_FOUND)
    find_package(QImageBlitz REQUIRED)
endif (NOT QIMAGEBLITZ_FOUND)

########### next target ###############

add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp
	${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp

    COMMAND ${SMOKE_GEN_BIN}
    ARGS -config "${CMAKE_CURRENT_BINARY_DIR}/../qtcore/config.xml" -smokeconfig "${CMAKE_CURRENT_SOURCE_DIR}/smokeconfig.xml"
         -I ${QIMAGEBLITZ_INCLUDES} -L "${CMAKE_BINARY_DIR}" -- ${CMAKE_CURRENT_SOURCE_DIR}/qimageblitz_includes.h
    DEPENDS ${SMOKE_GEN_BIN} "${CMAKE_CURRENT_SOURCE_DIR}/smokeconfig.xml"
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

macro_add_file_dependencies( ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp ${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp )

include_directories( ${QT_INCLUDES} ${QIMAGEBLITZ_INCLUDES} ${CMAKE_CURRENT_SOURCE_DIR} )

set(smokeqimageblitz_LIB_SRCS ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp
	${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp)

IF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")
    ADD_DEFINITIONS(-DGCC_VISIBILITY)
ENDIF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")
add_library(smokeqimageblitz SHARED ${smokeqimageblitz_LIB_SRCS})

target_link_libraries(smokeqimageblitz smokeqtcore ${QT_QTCORE_LIBRARY} ${QT_QTGUI_LIBRARY} ${QIMAGEBLITZ_LIBRARIES})

set_target_properties(smokeqimageblitz PROPERTIES VERSION 3.0.0 SOVERSION 3 )

install(TARGETS smokeqimageblitz
 LIBRARY DESTINATION ${LIB_INSTALL_DIR}
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
    RUNTIME DESTINATION bin)
if (WIN32)
	# Realign the stack, for compatibility with an older ABI.
	if(CMAKE_COMPILER_IS_GNUCXX)
		set_target_properties(smokeqimageblitz PROPERTIES COMPILE_FLAGS -mstackrealign)
	endif()

    # Get rid of the "lib" prefix on archives/DLLs in Windows.
    set_target_properties(smokeqimageblitz PROPERTIES PREFIX "" IMPORT_PREFIX "")
endif (WIN32)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/../qimageblitz_smoke.h DESTINATION include/smoke )
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qimageblitz.argnames.txt DESTINATION share/smoke)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qimageblitz.typedefs.txt DESTINATION share/smoke)
