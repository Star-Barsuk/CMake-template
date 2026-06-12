#include <defaultproject/cli/parser.hpp>

#include <cassert>
#include <initializer_list>

namespace {

    char* argv_storage[4]{};

    char** make_argv(std::initializer_list<const char*> args) {
        int i = 0;
        for (const char* arg : args) {
            argv_storage[i] = const_cast<char*>(arg);
            ++i;
        }
        return argv_storage;
    }

    void expect_action(
        std::initializer_list<const char*> args,
        defaultproject::cli::Action expected
    ) {
        const int argc = static_cast<int>(args.size());
        defaultproject::cli::Options options =
            defaultproject::cli::Parser::parse(argc, make_argv(args));
        assert(defaultproject::cli::parse_ok(options));
        assert(options.action == expected);
    }

    void expect_error(std::initializer_list<const char*> args) {
        const int argc = static_cast<int>(args.size());
        defaultproject::cli::Options options =
            defaultproject::cli::Parser::parse(argc, make_argv(args));
        assert(!defaultproject::cli::parse_ok(options));
        assert(options.error != nullptr);
    }

} // namespace

int main() {
    expect_action({"defaultproject"}, defaultproject::cli::Action::Help);
    expect_action({"defaultproject", "--help"}, defaultproject::cli::Action::Help);
    expect_action({"defaultproject", "-h"}, defaultproject::cli::Action::Help);
    expect_action({"defaultproject", "--version"}, defaultproject::cli::Action::Version);

    expect_error({"defaultproject", "--unknown"});
    expect_error({"defaultproject", "arg", "--flag"});
    expect_error({"defaultproject", "a", "b", "c"});

    return 0;
}
