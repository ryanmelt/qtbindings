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

macro_optional_add_bindings(PHONON_FOUND "Phonon" phonon)

macro_optional_add_bindings(QSCINTILLA_FOUND "QScintilla" qsci)

macro_optional_add_bindings(Qwt5_Qt4_FOUND "Qwt" qwt)

macro_optional_add_bindings(QIMAGEBLITZ_FOUND "QImageBlitz" qimageblitz)

macro_optional_add_bindings(KDE4_FOUND "KDECore" kdecore)
macro_optional_add_bindings(KDE4_FOUND "KDEUi" kdeui)
macro_optional_add_bindings(KDE4_FOUND "KIO" kio)
macro_optional_add_bindings(KDE4_FOUND "KParts" kparts)
macro_optional_add_bindings(KDE4_FOUND "KFile" kfile)
macro_optional_add_bindings(KDE4_FOUND "KNewStuff2" knewstuff2)
macro_optional_add_bindings(KDE4_FOUND "KNewStuff3" knewstuff3)
macro_optional_add_bindings(KDE4_FOUND "KUtils" kutils)
macro_optional_add_bindings(KDE4_FOUND "KHTML" khtml)
macro_optional_add_bindings(KDE4_FOUND "KTextEditor" ktexteditor)
macro_optional_add_bindings(KDE4_FOUND "Solid" solid)
macro_optional_add_bindings(KDE4_FOUND "Plasma" plasma)

macro_optional_add_bindings(Soprano_FOUND "Soprano" soprano sopranoclient sopranoserver)

if(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
    set(BUILD_Akonadi TRUE)
else(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
    set(BUILD_Akonadi FALSE)
endif(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
macro_optional_add_bindings(BUILD_Akonadi "Akonadi" akonadi)

macro_optional_add_bindings(LIBATTICA_FOUND "Attica" attica)

macro_optional_add_bindings(Nepomuk_FOUND "Nepomuk" nepomuk nepomukquery)

macro_optional_add_bindings(OKULAR_FOUND "Okular" okular)

find_library(KATEINTERFACES_LIBRARY kateinterfaces HINTS ${KDE4_LIB_DIR})
find_path(KATE_INCLUDE_DIR kate/plugin.h HINTS ${KDE4_INCLUDE_DIR})

macro_optional_add_bindings(KATE_INCLUDE_DIR "Kate" kate)

# for qtguess.pl
if (APPLE)
set(qt_test_threshold 15)
else (APPLE)
set(qt_test_threshold 10)
endif (APPLE)

macro_display_bindings_log()

########### install files ###############

# KDE specific
#install( FILES  smoke.h DESTINATION ${INCLUDE_INSTALL_DIR} )

# Qt only
#install( FILES  smoke.h DESTINATION ${INSTALL_DIR}/include )

install( FILES  smoke.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include )
