cmake_minimum_required(VERSION 2.8)
project(qtbind)

# Recurse into the generator subdirectory first
# This is where the smokegen project lives and is built
add_subdirectory(generator)

# Where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

# See the individual macro files in cmake/modules for descriptions
include(MacroOptionalFindPackage)
include(MacroOptionalAddBindings)
include(MacroLogFeature)
include(CheckCXXSourceCompiles)

# Call cmake/modules/FindQt4.cmake
# We are using the version provided by the Github project Kitware/CMake
# This sets a bunch of QT_XXX variables used throughout the build process
FIND_PACKAGE (Qt4 REQUIRED)

# Add all the -D define flags to the compilation of source files
add_definitions(${QT_DEFINITIONS} -DHAVE_CONFIG_H=1)
# Add directories for the compiler to search for source files
include_directories(${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${QT_INCLUDES})

# Call cmake/modules/FindRuby.cmake
# We are using the version provided by the Github project Kitware/CMake
FIND_PACKAGE(Ruby REQUIRED)
# Call cmake/modules/FindOpenGL.cmake
FIND_PACKAGE(OpenGL REQUIRED)

# Recurse into the smoke subdirectory
# This is where the smokeqt project lives and is built
add_subdirectory(smoke)
# Recurse into the ruby subdirectory
# This is where the qtruby project lives and is built
add_subdirectory(ruby)
