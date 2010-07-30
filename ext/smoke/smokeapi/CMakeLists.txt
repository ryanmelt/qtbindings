project(smokeapi)

find_package(Qt4 REQUIRED)
include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/.. ${QT_INCLUDES} )

add_executable(smokeapi main.cpp)
target_link_libraries(smokeapi smokeqtcore smokebase ${QT_QTCORE_LIBRARY})
install(    TARGETS smokeapi 
            DESTINATION ${CMAKE_INSTALL_PREFIX}/bin )
