
include_directories( ${CMAKE_CURRENT_SOURCE_DIR} )
include_directories( ${CMAKE_CURRENT_SOURCE_DIR}/ruby )

########### next target ###############

set(rbuic4_bin_SRCS 
   customwidgetsinfo.cpp 
   databaseinfo.cpp 
   driver.cpp 
   treewalker.cpp 
   ui4.cpp 
   uic.cpp 
   validator.cpp 
   ruby/rbextractimages.cpp 
   ruby/rbwritedeclaration.cpp 
   ruby/rbwriteicondata.cpp 
   ruby/rbwriteicondeclaration.cpp 
   ruby/rbwriteiconinitialization.cpp 
   ruby/rbwriteinitialization.cpp 
   main.cpp )

add_executable(rbuic4_bin ${rbuic4_bin_SRCS})
set_target_properties(rbuic4_bin PROPERTIES OUTPUT_NAME rbuic4)
set_target_properties(rbuic4_bin PROPERTIES COMPILE_FLAGS -DQT_UIC_RB_GENERATOR)

target_link_libraries(rbuic4_bin  ${QT_QTCORE_LIBRARY} ${QT_QTXML_LIBRARY} )

install(TARGETS rbuic4_bin DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)


########### next target ###############


########### install files ###############
