#include <libgo/absolutepath.hpp>
#include <libgo/dump_tokens.hpp>

#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>

namespace go::test {

TEST(Lexer, ValidNumbers) {
    std::stringstream in("0 123456789");
    std::stringstream out;
    dump_tokens(in, out);
    EXPECT_EQ(
        out.str(),
        "Loc=<1:0>\tINTEGER_LIT '0'\nLoc=<1:2>\tINTEGER_LIT '123456789'\n");
}

TEST(Lexer, ValidTokens) {
    std::stringstream in("/* hmmm*))=) */id value // woooah\n15");
    std::stringstream out;
    dump_tokens(in, out);
    EXPECT_EQ(
        out.str(),
        "Loc=<1:15>\tIDENTIFIER 'id'\nLoc=<1:18>\tIDENTIFIER "
        "'value'\nLoc=<2:0>\tINTEGER_LIT '15'\n");
}

TEST(Lexer, HelloWorld) {
    const std::filesystem::path path(c_absolute_path);
    std::ifstream example_file(path / "examples/helloworld.go");
    std::stringstream out;
    dump_tokens(example_file, out);
    EXPECT_EQ(
        out.str(),
        "Loc=<1:0>\tPACKAGE 'package'\nLoc=<1:8>\tIDENTIFIER "
        "'examples'\nLoc=<3:0>\tIMPORT 'import'\nLoc=<3:7>\tSTRING_LIT "
        "'\"fmt\"'\nLoc=<6:0>\tFUNC 'func'\nLoc=<6:5>\tIDENTIFIER "
        "'main'\nLoc=<6:9>\tL_PAREN '('\nLoc=<6:10>\tR_PAREN "
        "')'\nLoc=<6:12>\tL_CURLY '{'\nLoc=<7:1>\tIDENTIFIER "
        "'fmt'\nLoc=<7:4>\tDOT '.'\nLoc=<7:5>\tIDENTIFIER "
        "'Println'\nLoc=<7:12>\tL_PAREN '('\nLoc=<7:13>\tSTRING_LIT '\"hello, "
        "world!!\"'\nLoc=<7:29>\tR_PAREN ')'\nLoc=<8:0>\tR_CURLY '}'\n");
}

} // namespace go::test
