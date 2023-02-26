set(grammar_lib_name GolangGrammar)

add_library(${grammar_lib_name} STATIC)

find_package(ANTLR REQUIRED)

set(antlr_grammar_target_name Antlr${grammar_lib_name})
antlr_target(
  ${antlr_grammar_target_name}
  GoLexer.g4
  LEXER
)

set_target_properties(
    ${target_name}
    PROPERTIES
      CXX_STANDARD 20
      CXX_STANDARD_REQUIRED ON
      CXX_EXTENSIONS OFF
)

target_sources(
  ${grammar_lib_name}
  PRIVATE
    ${ANTLR_${antlr_grammar_target_name}_CXX_OUTPUTS}
)

target_include_directories(
  ${grammar_lib_name}
  PUBLIC
    ${ANTLR_${antlr_grammar_target_name}_OUTPUT_DIR}
)

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

target_link_libraries(
  ${grammar_lib_name}
  PUBLIC
    antlr4
    Threads::Threads
)