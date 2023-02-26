set(target_name go)

configure_file(${PROJECT_SOURCE_DIR}/src/libgo/libgo/absolutepath.hpp.in absolutepath.hpp)

file(GLOB_RECURSE LIBGO_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/libgo/*.cpp)

file(GLOB_RECURSE LIBGO_HEADER_FILES ${CMAKE_CURRENT_SOURCE_DIR}/libgo/*.hpp)

add_library(${target_name} STATIC ${LIBGO_SOURCE_FILES} ${LIBGO_HEADER_FILES})
include(CompileOptions)
set_compile_options(${target_name})
target_include_directories(${target_name} PUBLIC ${PROJECT_SOURCE_DIR}/src/libgo)

target_link_libraries(
  ${target_name}
  PRIVATE
    GolangGrammar
	  fmt
)

set(target_name go_test)

file(GLOB_RECURSE TEST_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp)
set(SOURCES ${TEST_SOURCE_FILES})

add_executable(${target_name} ${TEST_SOURCE_FILES})
set_target_properties(
    ${target_name}
    PROPERTIES
    	CXX_STANDARD 20
    	CXX_STANDARD_REQUIRED ON
    	CXX_EXTENSIONS OFF
)
target_include_directories(${target_name} PUBLIC ${CMAKE_BINARY_DIR}/src)
target_link_libraries(${target_name} PRIVATE go gtest_main)
target_compile_features(${target_name} PUBLIC cxx_std_20)
include(GoogleTest)
gtest_discover_tests(${target_name})