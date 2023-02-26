set(target_name go-compiler)

add_executable(${target_name})

include(CompileOptions)
set_compile_options(${target_name})

target_sources(${target_name} PRIVATE go-compiler/main.cpp)

target_include_directories(${target_name} PUBLIC ${CMAKE_BINARY_DIR}/src)

target_link_libraries(${target_name} PRIVATE go CLI11 fmt)