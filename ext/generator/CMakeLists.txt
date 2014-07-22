project(smokegenerator)
cmake_minimum_required(VERSION 2.6)

find_package(Qt4 REQUIRED)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake )
set(SMOKE_VERSION_MAJOR 3)
set(SMOKE_VERSION_MINOR 0)
set(SMOKE_VERSION_PATCH 0)
set(SMOKE_VERSION ${SMOKE_VERSION_MAJOR}.${SMOKE_VERSION_MINOR}.${SMOKE_VERSION_PATCH})


set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

if (NOT LIB_INSTALL_DIR)
    set (LIB_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX})
endif (NOT LIB_INSTALL_DIR)

include_directories(${QT_INCLUDES} parser ${CMAKE_BINARY_DIR})

add_subdirectory(parser)

set(generator_SRC
    main.cpp
    generatorenvironment.cpp
    generatorvisitor.cpp
    generatorpreprocessor.cpp
    options.cpp
    type_compiler.cpp
    name_compiler.cpp
    type.cpp
)

# force RPATH so that the binary is usable from within the build tree
set (CMAKE_SKIP_BUILD_RPATH FALSE)
set (CMAKE_SKIP_RPATH FALSE)

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/config.h.in config.h @ONLY )

add_executable(smokegen ${generator_SRC})
target_link_libraries(smokegen ${QT_QTCORE_LIBRARY} ${QT_QTXML_LIBRARY} cppparser)
set_target_properties(smokegen PROPERTIES COMPILE_DEFINITIONS __GENERATOR_BUILDING ENABLE_EXPORTS TRUE)

install(TARGETS smokegen LIBRARY DESTINATION ${LIB_INSTALL_DIR}
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
if (WIN32)
	# Realign the stack, for compatibility with an older ABI
	if(CMAKE_COMPILER_IS_GNUCXX)
		set_target_properties(smokegen PROPERTIES COMPILE_FLAGS -mstackrealign)
	endif()

    # Get rid of the "lib" prefix on archives/DLLs in Windows.
    set_target_properties(smokegen PROPERTIES PREFIX "" IMPORT_PREFIX "")
endif (WIN32)
install(FILES generatorenvironment.h  generator_export.h  generatorpreprocessor.h  generatorvisitor.h  name_compiler.h  options.h  type_compiler.h  type.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include/smokegen)
install( FILES  smoke.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include )
install( FILES smokegen_string.h DESTINATION ${CMAKE_INSTALL_PREFIX}/share/smokegen RENAME string.h )

add_subdirectory(cmake)
add_subdirectory(generators)
#add_subdirectory(smokeapi)
#add_subdirectory(smokebase)
#add_subdirectory(deptool)
