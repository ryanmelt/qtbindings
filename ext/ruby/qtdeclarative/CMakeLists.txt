include_directories( ${CMAKE_SOURCE_DIR}/smoke ${RUBY_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/ruby/qtruby/src)
INCLUDE_DIRECTORIES (${QT_INCLUDES})

set(rubyqtdeclarative_LIBRARY_SRC qtdeclarative.cpp qtdeclarativehandlers.cpp)
add_library(rubyqtdeclarative MODULE ${rubyqtdeclarative_LIBRARY_SRC})
target_link_libraries(rubyqtdeclarative
    ${QT_QTWEBKIT_LIBRARY}
    smokeqtdeclarative
    qtruby4shared
)
set_target_properties(rubyqtdeclarative PROPERTIES PREFIX "" OUTPUT_NAME qtdeclarative)
install(TARGETS rubyqtdeclarative DESTINATION ${CUSTOM_RUBY_SITE_ARCH_DIR})
install(FILES qtdeclarative.rb DESTINATION ${CUSTOM_RUBY_SITE_LIB_DIR}/qtdeclarative)

if (Q_WS_MAC)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtdeclarative.so\"  \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtdeclarative.bundle\" )" )
endif (Q_WS_MAC)
