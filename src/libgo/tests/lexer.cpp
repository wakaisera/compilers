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
        "'examples'\nLoc=<3:0>\tIMPORT "
        "'import'\nLoc=<3:7>\tINTERPRETED_STRING_LIT "
        "'\"fmt\"'\nLoc=<6:0>\tFUNC 'func'\nLoc=<6:5>\tIDENTIFIER "
        "'main'\nLoc=<6:9>\tL_PAREN '('\nLoc=<6:10>\tR_PAREN "
        "')'\nLoc=<6:12>\tL_CURLY '{'\nLoc=<7:1>\tIDENTIFIER "
        "'fmt'\nLoc=<7:4>\tDOT '.'\nLoc=<7:5>\tIDENTIFIER "
        "'Println'\nLoc=<7:12>\tL_PAREN "
        "'('\nLoc=<7:13>\tINTERPRETED_STRING_LIT '\"hello, "
        "world!!\"'\nLoc=<7:29>\tR_PAREN ')'\nLoc=<8:0>\tR_CURLY '}'\n");
}

TEST(Lexer, InvalidTokens) {
    std::stringstream in("$@~");
    std::stringstream out;
    dump_tokens(in, out);
    EXPECT_EQ(
        out.str(),
        "Loc=<1:0>\tINVALID '$'\nLoc=<1:1>\tINVALID '@'\nLoc=<1:2>\tINVALID "
        "'~'\n");
}

TEST(Lexer, InvalidSymbol) {
    const std::filesystem::path path(c_absolute_path);
    std::ifstream example_file(path / "examples/strange_string.go");
    std::stringstream out;
    dump_tokens(example_file, out);
    EXPECT_EQ(
        out.str(),
        "Loc=<1:0>\tPACKAGE 'package'\nLoc=<1:8>\tIDENTIFIER "
        "'examples'\nLoc=<3:0>\tFUNC 'func'\nLoc=<3:5>\tIDENTIFIER "
        "'main'\nLoc=<3:9>\tL_PAREN '('\nLoc=<3:10>\tR_PAREN "
        "')'\nLoc=<3:12>\tL_CURLY '{'\nLoc=<4:1>\tIDENTIFIER "
        "'str'\nLoc=<4:5>\tDECLARE_ASSIGN ':='\nLoc=<4:8>\tINVALID "
        "'\"'\nLoc=<4:9>\tIDENTIFIER 'hello'\nLoc=<4:14>\tINVALID "
        "'\\'\nLoc=<4:15>\tINTEGER_LIT '0'\nLoc=<4:16>\tINVALID "
        "'\"'\nLoc=<4:17>\tSEMI ';'\nLoc=<5:0>\tR_CURLY '}'\n");
}

} // namespace go::test
