project(SMOKE)

cmake_minimum_required(VERSION 2.6)

add_definitions(-DSMOKE_BUILDING)

add_subdirectory(smokebase)

find_package(Qt4 REQUIRED)
find_package(Smoke)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
set(CMAKE_INSTALL_PREFIX ${SMOKE_INSTALL_PREFIX}
    CACHE PATH "Install prefix" FORCE)
endif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SMOKE_CMAKE_MODULE_DIR}")
include(MacroOptionalFindPackage)
include(MacroOptionalAddBindings)
include(MacroLogFeature)
set(SMOKE_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include ${CMAKE_INSTALL_PREFIX}/include/smoke)

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${SMOKE_INCLUDE_DIR})

# Set LIB_INSTALL_DIR if it's not set already.
if (NOT LIB_INSTALL_DIR)
    set (LIB_INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX})
endif (NOT LIB_INSTALL_DIR)

# disable deprecation warnings
if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-declarations")
endif()

macro_optional_find_package(QImageBlitz)
macro_log_feature(QIMAGEBLITZ_FOUND "QImageBlitz" "QImageBlitz library" "http://www.kde.org" FALSE "" "Needed to compile QImageBlitz bindings")

macro_optional_find_package(Qwt5)
macro_log_feature(Qwt5_Qt4_FOUND "Qwt5 for Qt4" "Qwt5 libraries for Qt4" "http://qwt.sourceforge.net" FALSE "" "Needed to compile Qwt5 bindings")

macro_optional_find_package(Phonon)
macro_log_feature(PHONON_FOUND "Phonon" "Phonon multimedia framework" "http://www.kde.org" FALSE "" "Needed to compile Phonon bindings")

macro_optional_find_package(QScintilla)
macro_log_feature(QSCINTILLA_FOUND "QScintilla2" "QScintilla2 libraries" "http://www.riverbankcomputing.co.uk/software/qscintilla/intro" FALSE "" "Needed to compile QScintilla2 bindings")

set(QTDEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/qtdefines)

#if(WITH_QT3_SUPPORT)
#    add_definitions(-DQT3_SUPPORT)
#endif(WITH_QT3_SUPPORT)

add_subdirectory(qtcore)
add_subdirectory(deptool)
add_subdirectory(smokeapi)

macro_optional_add_bindings(QT_QTNETWORK_FOUND "QtNetwork" qtnetwork)
if (NOT WIN32)
  macro_optional_add_bindings(QT_QTDBUS_FOUND "QtDBus" qtdbus)
endif (NOT WIN32)
macro_optional_add_bindings(QT_QTDECLARATIVE_FOUND "QtDeclarative" qtdeclarative)
macro_optional_add_bindings(QT_QTGUI_FOUND "QtGui" qtgui)
macro_optional_add_bindings(QT_QTSVG_FOUND "QtSvg" qtsvg)
macro_optional_add_bindings(QT_QTSQL_FOUND "QtSql" qtsql)
macro_optional_add_bindings(QT_QTXML_FOUND "QtXml" qtxml)
macro_optional_add_bindings(QT_QTXMLPATTERNS_FOUND "QtXmlPatterns" qtxmlpatterns)
macro_optional_add_bindings(QT_QTOPENGL_FOUND "QtOpenGL" qtopengl)
macro_optional_add_bindings(QT_QTWEBKIT_FOUND "QtWebKit" qtwebkit)
macro_optional_add_bindings(QT_QTSCRIPT_FOUND "QtScript" qtscript)
macro_optional_add_bindings(QT_QTUITOOLS_FOUND "QtUiTools" qtuitools)
macro_optional_add_bindings(QT_QTTEST_FOUND "QtTest" qttest)
macro_optional_add_bindings(QT_QTMULTIMEDIA_FOUND "QtMultimedia" qtmultimedia)
#macro_optional_add_bindings(QT_QT3SUPPORT_FOUND "Qt3Support" qt3support)
macro_optional_add_bindings(QT_QTHELP_FOUND "QtHelp" qthelp)
macro_optional_add_bindings(PHONON_FOUND "Phonon" phonon)
macro_optional_add_bindings(QSCINTILLA_FOUND "QScintilla" qsci)
macro_optional_add_bindings(Qwt5_Qt4_FOUND "Qwt" qwt)
macro_optional_add_bindings(QIMAGEBLITZ_FOUND "QImageBlitz" qimageblitz)

# for qtguess.pl
if (APPLE)
set(qt_test_threshold 15)
else (APPLE)
set(qt_test_threshold 10)
endif (APPLE)

macro_display_bindings_log()
macro_display_feature_log()

########### install files ###############

install( FILES  smoke.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include )
