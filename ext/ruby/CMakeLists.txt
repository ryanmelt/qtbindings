project(Ruby)

set(COMPILE_RUBY FALSE CACHE INTERNAL "")

macro_optional_find_package(Ruby)

if (RUBY_LIBRARY AND RUBY_INCLUDE_DIRS AND RUBY_EXECUTABLE)
    set(COMPILE_RUBY TRUE CACHE INTERNAL "")
endif (RUBY_LIBRARY AND RUBY_INCLUDE_DIRS AND RUBY_EXECUTABLE)

macro_log_feature(COMPILE_RUBY "Ruby" "Ruby interpreter and libraries" "http://www.ruby-lang.org" FALSE "" "Needed to compile the Ruby bindings")

if (NOT COMPILE_RUBY)
    message(STATUS "Ruby Not Found Successfully")
endif (NOT COMPILE_RUBY)

SET(CUSTOM_RUBY_SITE_ARCH_DIR ${RUBY_SITEARCH_DIR} CACHE DIR "custom installation directory for ruby binary extension" )
SET(CUSTOM_RUBY_SITE_LIB_DIR ${RUBY_SITELIB_DIR} CACHE DIR "custom installation directory for ruby extension" )

# compute an overall version number which can be compared at once
MATH(EXPR RUBY_VERSION_NUMBER "${RUBY_VERSION_MAJOR}*10000 + ${RUBY_VERSION_MINOR}*100 + ${RUBY_VERSION_PATCH}")

macro_optional_add_bindings(QT_QTCORE_FOUND "QtRuby" qtruby)
macro_optional_add_bindings(QT_QTDECLARATIVE_FOUND "QtDeclarative" qtdeclarative)
macro_optional_add_bindings(QT_QTWEBKIT_FOUND "QtWebKit" qtwebkit)
macro_optional_add_bindings(QT_QTUITOOLS_FOUND "QtUiTools" qtuitools)
macro_optional_add_bindings(QT_QTSCRIPT_FOUND "QtScript" qtscript)
macro_optional_add_bindings(QT_QTTEST_FOUND "QtTest" qttest)

if (RUBY_EXECUTABLE AND RUBY_LIBRARY AND RUBY_INCLUDE_DIRS)
    if(WIN32) # Add the -r devkit on Windows to successfully build
      EXECUTE_PROCESS(COMMAND ${RUBY_EXECUTABLE} -r devkit -r mkmf -e "exit(have_func('rb_hash_foreach') ? 0 : 1)" RESULT_VARIABLE RUBY_HASH_FOREACH OUTPUT_QUIET)
    else(WIN32)
      EXECUTE_PROCESS(COMMAND ${RUBY_EXECUTABLE} -r mkmf -e "exit(have_func('rb_hash_foreach') ? 0 : 1)" RESULT_VARIABLE RUBY_HASH_FOREACH OUTPUT_QUIET)
    endif(WIN32)

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
      message(STATUS "Failed to load the Ruby mkmf library. Please install the Ruby developer packages.")
    endif (RUBY_HASH_FOREACH EQUAL 0)

endif (RUBY_EXECUTABLE AND RUBY_LIBRARY AND RUBY_INCLUDE_DIRS)
message(STATUS "Ruby Executable: " ${RUBY_EXECUTABLE})
message(STATUS "Ruby Libraries: " ${RUBY_LIBRARY})
message(STATUS "Ruby Include Directories: " ${RUBY_INCLUDE_DIRS})

macro_display_bindings_log()
