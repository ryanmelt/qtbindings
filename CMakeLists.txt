# Use this file to build a Qt only version of QtRuby.
#
# 1. Copy this file to ./CMakeLists.txt
#
# 2. Copy files neede by cmake from ../kdelibs/ to ./cmake/modules/:
#
#  cp ../kdelibs/cmake/modules/FindQt4.cmake                  ./cmake/modules/
#  cp ../kdelibs/cmake/modules/FindRUBY.cmake                 ./cmake/modules/
#  cp ../kdelibs/cmake/modules/MacroOptionalFindPackage.cmake ./cmake/modules/
#  cp ../kdelibs/cmake/modules/MacroPushRequiredVars.cmake    ./cmake/modules/
#
# 3. Build kdebindings with a set of commands like:
#
#  test -r Makefile && make clean
#  rm -f CMakeCache.txt CMakeFiles/*log
#  cmake                                                         \
#    -DCMAKE_INSTALL_PREFIX=/usr/local                           \
#    -DRUBY_EXECUTABLE=/usr/local/bin/ruby                       \
#    -DRUBY_INCLUDE_PATH=/usr/local/lib/ruby/1.8/i686-linux/     \
#    -Wno-dev                                                    \
#    -DENABLE_SMOKE=on                                           \
#    -DENABLE_QTRUBY=on                                          \
#    -DENABLE_QTWEBKIT_SMOKE=off                                 \
#    -DENABLE_QTSCRIPT_SMOKE=off                                 \
#    -DENABLE_QTUITOOLS_SMOKE=off                                \
#    -DENABLE_QTTEST_SMOKE=off                                   \
#    -DENABLE_PHONON_SMOKE=off                                   \
#    -DENABLE_QSCI_SMOKE=off                                     \
#    -DENABLE_QWT_SMOKE=off                                      \
#    -DENABLE_KDE_SMOKE=off                                      \
#    -DENABLE_KDEVPLATFORM_SMOKE=off                             \
#    -DENABLE_KHTML_SMOKE=off                                    \
#    -DENABLE_KTEXTEDITOR_SMOKE=off                              \
#    -DENABLE_SOLID_SMOKE=off                                    \
#    -DENABLE_PLASMA_SMOKE=off                                   \
#    -DENABLE_QTWEBKIT_RUBY=off                                  \
#    -DENABLE_QTUITOOLS_RUBY=off                                 \
#    -DENABLE_QTSCRIPT=off                                       \
#    -DENABLE_QTTEST=off                                         \
#    -DENABLE_PHONON_RUBY=off                                    \
#    -DENABLE_QSCINTILLA_RUBY=off                                \
#    -DENABLE_QWT_RUBY=off                                       \
#    -DENABLE_SOPRANO_RUBY=off                                   \
#    -DENABLE_KDEVPLATFORM_RUBY=off                              \
#    -DENABLE_KORUNDUM_RUBY=off                                  \
#    -DENABLE_KHTML_RUBY=off                                     \
#    -DENABLE_KTEXTEDITOR_RUBY=off                               \
#    -DENABLE_SOLID_RUBY=off                                     \
#    -DENABLE_KROSSRUBY=off                                      \
#    -DENABLE_PLASMA_RUBY=off                                    \
#    -DENABLE_QIMAGEBLITZ_SMOKE=off
#  make
#  make install
#

project(kdebindings)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules )

include (MacroOptionalFindPackage)

FIND_PACKAGE(Perl REQUIRED)
FIND_PACKAGE (Qt4 REQUIRED)

add_definitions (${QT_DEFINITIONS}  -DHAVE_CONFIG_H=1)
include_directories (${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} ${QT_INCLUDES} )

FIND_PACKAGE (RUBY REQUIRED)
FIND_PACKAGE (OpenGL REQUIRED)

add_subdirectory(smoke)

if(RUBY_EXECUTABLE)
   add_subdirectory( ruby )
endif(RUBY_EXECUTABLE)

