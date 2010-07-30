project(qtbind)

add_subdirectory(generator)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

include(MacroOptionalFindPackage)
include(MacroOptionalAddBindings)
include(MacroLogFeature)
include(CheckCXXSourceCompiles)

FIND_PACKAGE (Qt4 REQUIRED)

add_definitions (${QT_DEFINITIONS}  -DHAVE_CONFIG_H=1)
include_directories (${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${QT_INCLUDES} )

FIND_PACKAGE (RUBY REQUIRED)
FIND_PACKAGE (OpenGL REQUIRED)

add_subdirectory(smoke)
add_subdirectory(ruby)
