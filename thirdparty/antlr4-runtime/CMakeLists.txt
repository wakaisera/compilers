include(ExternalAntlr4Cpp)

set(target_name antlr4)

add_library(${target_name} INTERFACE)

target_link_libraries(
    ${target_name}
    INTERFACE
    antlr4_static
)

target_include_directories(
    ${target_name}
    SYSTEM
    INTERFACE
    ${ANTLR4_INCLUDE_DIRS}
)