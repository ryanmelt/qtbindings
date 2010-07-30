include_directories( ${CMAKE_SOURCE_DIR}/smoke ${RUBY_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/ruby/qtruby/src)
INCLUDE_DIRECTORIES (${QT_INCLUDES} ${KDE4_INCLUDE_DIR})

set(qttest_LIBRARY_SRC qttest.cpp qttesthandlers.cpp)

add_library(qttest MODULE ${qttest_LIBRARY_SRC})
target_link_libraries(qttest
    smokeqttest
    qtruby4shared
)
set_target_properties(qttest PROPERTIES PREFIX "")
install(TARGETS qttest DESTINATION ${CUSTOM_RUBY_SITE_ARCH_DIR})
install(FILES qttest.rb DESTINATION ${CUSTOM_RUBY_SITE_LIB_DIR}/qttest)

if (Q_WS_MAC)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qttest.so\"  \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qttest.bundle\" )" )
endif (Q_WS_MAC)

