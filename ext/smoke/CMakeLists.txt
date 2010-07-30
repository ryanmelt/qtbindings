project(SMOKE)

add_definitions(-DSMOKE_BUILDING)

add_subdirectory(smokebase)
add_subdirectory(qtcore)
add_subdirectory(deptool)
add_subdirectory(smokeapi)

macro_optional_add_bindings(QT_QTNETWORK_FOUND "QtNetwork" qtnetwork)
macro_optional_add_bindings(QT_QTDBUS_FOUND "QtDBus" qtdbus)
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

# for qtguess.pl
if (APPLE)
set(qt_test_threshold 15)
else (APPLE)
set(qt_test_threshold 10)
endif (APPLE)

macro_display_bindings_log()

########### install files ###############

install( FILES  smoke.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include )
