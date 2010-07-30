include_directories( ${CMAKE_SOURCE_DIR}/smoke ${RUBY_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/ruby/qtruby/src)
INCLUDE_DIRECTORIES (${QT_INCLUDES} ${KDE4_INCLUDE_DIR})

set(qtscript_LIBRARY_SRC qtscript.cpp qtscripthandlers.cpp)

add_library(qtscript MODULE ${qtscript_LIBRARY_SRC})
target_link_libraries(qtscript
    ${QT_QTSCRIPT_LIBRARY}
    smokeqtscript
    qtruby4shared
)
set_target_properties(qtscript PROPERTIES PREFIX "")
install(TARGETS qtscript DESTINATION ${CUSTOM_RUBY_SITE_ARCH_DIR})
install(FILES qtscript.rb DESTINATION ${CUSTOM_RUBY_SITE_LIB_DIR}/qtscript)

if (Q_WS_MAC)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtscript.so\"  \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtscript.bundle\" )" )
endif (Q_WS_MAC)

