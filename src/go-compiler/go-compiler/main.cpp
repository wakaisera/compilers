#include <libgo/absolutepath.hpp>
#include <libgo/dump_tokens.hpp>

#include <CLI/App.hpp>
#include <CLI/Config.hpp>
#include <CLI/Formatter.hpp>
#include <fmt/format.h>

int main(int argc, char **argv) {
    CLI::App app{"GolangCompiler"};
    std::string input_file;
    app.add_option<std::string>(
        "--dump-tokens",
        input_file,
        "output the result of the lexical analyzer");
    CLI11_PARSE(app, argc, argv);
    if (app.count("--dump-tokens") != 1) {
        fmt::print("{}", app.help());
        return -1;
    }
    const std::filesystem::path path(c_absolute_path);
    std::ifstream in(path / input_file);
    go::dump_tokens(in, std::cout);
    return 0;
}