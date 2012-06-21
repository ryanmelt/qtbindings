set(SMOKE_LIBRARY_PREFIX ${CMAKE_INSTALL_PREFIX}/lib${LIB_SUFFIX})
set(SMOKE_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include ${CMAKE_INSTALL_PREFIX}/include/smoke)
set(SMOKE_CMAKE_MODULE_DIR ${CMAKE_INSTALL_PREFIX}/share/smoke/cmake)
set(SMOKE_GEN_BIN ${CMAKE_INSTALL_PREFIX}/bin/smokegen${CMAKE_EXECUTABLE_SUFFIX})
set(SMOKE_GEN_SHARED ${CMAKE_INSTALL_PREFIX}/share/smokegen)
set(SMOKE_API_BIN ${CMAKE_INSTALL_PREFIX}/bin/smokeapi${CMAKE_EXECUTABLE_SUFFIX})
set(SMOKE_GENERATOR_SMOKE_LIB ${LIB_INSTALL_DIR}/smokegen/generator_smoke)
set(SMOKE_GENERATOR_DUMP_LIB ${LIB_INSTALL_DIR}/smokegen/generator_dump)

configure_file(SmokeConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/SmokeConfig.cmake @ONLY)

set(smoke_cmake_files 
        FindLibraryWithDebug.cmake
        FindPhonon.cmake
        FindQImageBlitz.cmake
        FindQScintilla.cmake
        FindQwt5.cmake
        HandleImportedTargetsInCMakeRequiredLibraries.cmake
        MacroLogFeature.cmake
        MacroOptionalAddBindings.cmake
        MacroOptionalFindPackage.cmake
        )

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/SmokeConfig.cmake ${smoke_cmake_files} DESTINATION ${SMOKE_CMAKE_MODULE_DIR})
