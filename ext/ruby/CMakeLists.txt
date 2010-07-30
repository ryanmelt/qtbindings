project(Ruby)

set(COMPILE_RUBY FALSE CACHE INTERNAL "")

macro_optional_find_package(Ruby)

if (RUBY_LIBRARY AND RUBY_INCLUDE_DIRS AND RUBY_EXECUTABLE)
    set(COMPILE_RUBY TRUE CACHE INTERNAL "")
endif (RUBY_LIBRARY AND RUBY_INCLUDE_DIRS AND RUBY_EXECUTABLE)

macro_log_feature(COMPILE_RUBY "Ruby" "Ruby interpreter and libraries" "http://www.ruby-lang.org" FALSE "" "Needed to compile the Ruby bindings")

if (NOT COMPILE_RUBY)
    return()
endif (NOT COMPILE_RUBY)

SET(CUSTOM_RUBY_SITE_ARCH_DIR ${RUBY_SITEARCH_DIR} CACHE DIR "custom installation directory for ruby binary extension" )
SET(CUSTOM_RUBY_SITE_LIB_DIR ${RUBY_SITELIB_DIR} CACHE DIR "custom installation directory for ruby extension" )

# compute an overall version number which can be compared at once
MATH(EXPR RUBY_VERSION_NUMBER "${RUBY_VERSION_MAJOR}*10000 + ${RUBY_VERSION_MINOR}*100 + ${RUBY_VERSION_PATCH}")

macro_optional_add_bindings(QT_QTCORE_FOUND "QtRuby" qtruby)
macro_optional_add_bindings(QT_QTWEBKIT_FOUND "QtWebKit" qtwebkit)
macro_optional_add_bindings(QT_QTUITOOLS_FOUND "QtUiTools" qtuitools)
macro_optional_add_bindings(QT_QTSCRIPT_FOUND "QtScript" qtscript)
macro_optional_add_bindings(QT_QTTEST_FOUND "QtTest" qttest)

macro_optional_add_bindings(PHONON_FOUND "Phonon" phonon)

macro_optional_add_bindings(QSCINTILLA_FOUND "QScintilla" qscintilla)

macro_optional_add_bindings(Qwt5_Qt4_FOUND "Qwt" qwt)

macro_optional_add_bindings(Soprano_FOUND "Soprano" soprano)

if(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
    set(BUILD_Akonadi TRUE)
else(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
    set(BUILD_Akonadi FALSE)
endif(KDEPIMLIBS_FOUND AND Akonadi_FOUND)
macro_optional_add_bindings(BUILD_Akonadi "Akonadi" akonadi)

macro_optional_add_bindings(KDE4_FOUND "Korundum" korundum)
macro_optional_add_bindings(KDE4_FOUND "KIO" kio)
macro_optional_add_bindings(KDE4_FOUND "KHTML" khtml)
macro_optional_add_bindings(KDE4_FOUND "KTextEditor" ktexteditor)
macro_optional_add_bindings(KDE4_FOUND "Solid" solid)
macro_optional_add_bindings(KDE4_FOUND "Plasma" plasma)

# For nepomuk, we also must have found soprano, since soprano headers are used:
if(Soprano_FOUND AND Nepomuk_FOUND)
    set(BUILD_Nepomuk TRUE)
else(Soprano_FOUND AND Nepomuk_FOUND)
    set(BUILD_Nepomuk FALSE)
endif(Soprano_FOUND AND Nepomuk_FOUND)
macro_optional_add_bindings(BUILD_Nepomuk "Nepomuk" nepomuk)

macro_optional_add_bindings(OKULAR_FOUND "Okular" okular)

find_library(KATEINTERFACES_LIBRARY kateinterfaces HINTS ${KDE4_LIB_DIR})
find_path(KATE_INCLUDE_DIR kate/plugin.h HINTS ${KDE4_INCLUDE_DIR})

macro_optional_add_bindings(KATE_INCLUDE_DIR "Kate" kate)

#####################################################################
# Kross Ruby

OPTION(ENABLE_KROSSRUBY "build Kross Ruby scripting library" ON)
#OPTION(ENABLE_KROSSRUBY "build Kross Ruby scripting library" OFF)

if (RUBY_EXECUTABLE AND RUBY_LIBRARY AND RUBY_INCLUDE_DIRS)
    EXECUTE_PROCESS(COMMAND ${RUBY_EXECUTABLE} -r mkmf -e "exit(have_func('rb_hash_foreach') ? 0 : 1)" RESULT_VARIABLE RUBY_HASH_FOREACH OUTPUT_QUIET)
    if (RUBY_HASH_FOREACH EQUAL 0)

        set(CMAKE_REQUIRED_INCLUDES ${RUBY_INCLUDE_DIRS})
        set(CMAKE_REQUIRED_LIBRARIES ${RUBY_LIBRARY})
        CHECK_CXX_SOURCE_COMPILES("
            #include <ruby.h>
            int main() { ruby_init(); return 0; }" RubyCompiles)
        if(RubyCompiles)
            if(ENABLE_KROSSRUBY)
                set(BUILD_KrossRuby TRUE)
            endif(ENABLE_KROSSRUBY)
        else(RubyCompiles)
            message(STATUS "Failed to compile a C++ program that embeds ruby.")
        endif(RubyCompiles)

    else (RUBY_HASH_FOREACH EQUAL 0)

        # 2007-02-12 sebsauer; this is a workaround for the case we failed to load
        # the "mkmf" library what is the case e.g. on some debian distributions.
        #EXECUTE_PROCESS(COMMAND ${RUBY_EXECUTABLE} -r mkmf -e "exit(0)" RESULT_VARIABLE RUBY_HASH_FOREACH OUTPUT_QUIET ERROR_QUIET)
        #if (${RUBY_HASH_FOREACH} EQUAL 0)
        message(STATUS "The detected Ruby is too old for kross. A Ruby which has rb_hash_foreach is required. Upgrade to 1.8.2 or later")
        #else (${RUBY_HASH_FOREACH} EQUAL 0)
        #    message(STATUS "Failed to load the Ruby mkmf library. Please install the Ruby developer packages.")
        #endif (${RUBY_HASH_FOREACH} EQUAL 0)

    endif (RUBY_HASH_FOREACH EQUAL 0)
endif (RUBY_EXECUTABLE AND RUBY_LIBRARY AND RUBY_INCLUDE_DIRS)
message(STATUS "Ruby Executable: " ${RUBY_EXECUTABLE})
message(STATUS "Ruby Libraries: " ${RUBY_LIBRARY})
message(STATUS "Ruby Include Directories: " ${RUBY_INCLUDE_DIRS})

macro_optional_add_bindings(BUILD_KrossRuby "KrossRuby" krossruby)

macro_display_bindings_log()
