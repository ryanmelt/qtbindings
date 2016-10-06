project(qtbind)

if(CMAKE_COMPILER_IS_GNUCXX)
    set(CXXVERSION ${CMAKE_CXX_COMPILER_VERSION}) 
    if((CXXVERSION VERSION_GREATER 4) AND (CXXVERSION VERSION_LESS 6)) 
        message(WARNING "changing compile standard to c++03 due to gcc 5 incompabilities")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++03")
    endif()
endif()

add_subdirectory(generator)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

include(MacroOptionalFindPackage)
include(MacroOptionalAddBindings)
include(MacroLogFeature)
include(CheckCXXSourceCompiles)

# Call cmake/modules/FindQt4.cmake
# We are using the version provided by the Github project Kitware/CMake
# This sets a bunch of QT_XXX variables used throughout the build process
FIND_PACKAGE (Qt4 REQUIRED)

add_definitions (${QT_DEFINITIONS}  -DHAVE_CONFIG_H=1)
include_directories (${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${QT_INCLUDES} )

FIND_PACKAGE (Ruby REQUIRED)
FIND_PACKAGE (OpenGL REQUIRED)

add_subdirectory(smoke)
add_subdirectory(ruby)
