#include <defaultproject/app/application.hpp>
#include <defaultproject/app/exit_code.hpp>
#include <defaultproject/cli/parser.hpp>
#include <defaultproject/cli/usage.hpp>
#include <defaultproject/version.hpp>

namespace defaultproject::app {

    Application::Application(int argc, char* argv[]) noexcept
        : argc_{argc},
          argv_{argv} {
    }

    int Application::dispatch(const cli::Options& options) {
        if (!cli::parse_ok(options)) {
            stderr_.write_cstr(defaultproject::version::kName);
            stderr_.write_cstr(": ");
            stderr_.write_line(options.error);
            stderr_.write_line("Try 'defaultproject --help'.");
            return kExitUsage;
        }

        switch (options.action) {
            case cli::Action::Help:
                cli::Usage::print_help(stdout_);
                return kExitOk;

            case cli::Action::Version:
                cli::Usage::print_version(stdout_);
                return kExitOk;
        }

        return kExitError;
    }

    int Application::run() {
        const cli::Options options = cli::Parser::parse(argc_, argv_);
        return dispatch(options);
    }

} // namespace defaultproject::app
