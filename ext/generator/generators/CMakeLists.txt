string(REPLACE "-Wl,--no-undefined" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

add_subdirectory(smoke)
add_subdirectory(dump)
