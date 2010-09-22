
include_directories( ${QT_INCLUDES} ${CMAKE_SOURCE_DIR}/smoke )

configure_file(config.xml.cmake ${CMAKE_CURRENT_BINARY_DIR}/config.xml @ONLY)

########### next target ###############

add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp 
    ${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp 

    COMMAND smokegen
    ARGS -config "${CMAKE_CURRENT_BINARY_DIR}/config.xml" -smokeconfig "${CMAKE_CURRENT_SOURCE_DIR}/smokeconfig.xml"
         -- ${CMAKE_CURRENT_SOURCE_DIR}/qtdeclarative_includes.h
    DEPENDS smokegen generator_smoke WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

macro_add_file_dependencies( ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp ${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp )

include_directories (${CMAKE_SOURCE_DIR}/smoke ${CMAKE_SOURCE_DIR}/smoke/qtdeclarative  )

set(smokeqtdeclarative_LIB_SRCS ${CMAKE_CURRENT_BINARY_DIR}/smokedata.cpp  
                ${CMAKE_CURRENT_BINARY_DIR}/x_1.cpp 
)

IF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")
    ADD_DEFINITIONS(-DGCC_VISIBILITY)
ENDIF(CMAKE_CXX_FLAGS MATCHES "-fvisibility")

# kde4_add_library(smokeqtdeclarative SHARED ${smokeqtdeclarative_LIB_SRCS})
add_library(smokeqtdeclarative SHARED ${smokeqtdeclarative_LIB_SRCS})

target_link_libraries(  smokeqtdeclarative 
                        smokeqtcore 
                        smokeqtgui 
                        ${QT_QTCORE_LIBRARY} 
                        ${QT_QTGUI_LIBRARY} 
                        ${QT_QTNETWORK_LIBRARY} 
                        ${QT_QTSCRIPT_LIBRARY} 
                        ${QT_QTDECLARATIVE_LIBRARY} )

set_target_properties(smokeqtdeclarative PROPERTIES VERSION 3.0.0 SOVERSION 3 )

# Don't use the KDE ${LIB_INSTALL_DIR} macro here as this file is
# for Qt only installs
install(TARGETS smokeqtdeclarative DESTINATION ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX} )
install(FILES ${CMAKE_SOURCE_DIR}/smoke/qtdeclarative_smoke.h DESTINATION include/smoke)
