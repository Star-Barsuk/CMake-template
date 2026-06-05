#include <defaultproject/cli/usage.hpp>
#include <defaultproject/version.hpp>

namespace defaultproject::cli {

    void Usage::print_help(io::StdoutWriter& out) {
        out.write_line("Usage: defaultproject [KEYWORD] [ARG]...");
        out.write_line("       defaultproject --version");
        out.write_line("       defaultproject --help");
    }

    void Usage::print_version(io::StdoutWriter& out) {
        out.write_cstr(defaultproject::version::kName);
        out.write_cstr(" ");
        out.write_line(defaultproject::version::kVersion);
        out.write_line("");
    }

} // namespace defaultproject::cli
