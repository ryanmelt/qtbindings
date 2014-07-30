project(smokegenerator)

find_package(Qt4 REQUIRED)

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)

if (NOT LIB_INSTALL_DIR)
    set (LIB_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX})
endif (NOT LIB_INSTALL_DIR)

include_directories(${QT_INCLUDES} parser)

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

add_executable(smokegen ${generator_SRC})
target_link_libraries(smokegen ${QT_QTCORE_LIBRARY} ${QT_QTXML_LIBRARY} cppparser)
set_target_properties(smokegen PROPERTIES COMPILE_DEFINITIONS __GENERATOR_BUILDING ENABLE_EXPORTS TRUE)

install(TARGETS smokegen DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
install(FILES generatorenvironment.h  generator_export.h  generatorpreprocessor.h  generatorvisitor.h  name_compiler.h  options.h  type_compiler.h  type.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include/smokegen)

add_subdirectory(generators)
