include_directories( ${CMAKE_SOURCE_DIR}/smoke ${RUBY_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}/ruby/qtruby/src)
INCLUDE_DIRECTORIES (${QT_INCLUDES})

set(rubyqtuitools_LIBRARY_SRC qtuitools.cpp qtuitoolshandlers.cpp)
add_library(rubyqtuitools MODULE ${rubyqtuitools_LIBRARY_SRC})
target_link_libraries(rubyqtuitools
    smokeqtuitools
    qtruby4shared
)
set_target_properties(rubyqtuitools PROPERTIES PREFIX "" OUTPUT_NAME qtuitools)
install(TARGETS rubyqtuitools DESTINATION ${CUSTOM_RUBY_SITE_ARCH_DIR})
install(FILES qtuitools.rb DESTINATION ${CUSTOM_RUBY_SITE_LIB_DIR}/qtuitools)

if (Q_WS_MAC)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtuitools.so\"  \"${CUSTOM_RUBY_SITE_ARCH_DIR}/qtuitools.bundle\" )" )
endif (Q_WS_MAC)
