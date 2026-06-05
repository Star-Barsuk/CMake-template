#pragma once

#include <defaultproject/cli/options.hpp>
#include <defaultproject/io/stdout_writer.hpp>

namespace defaultproject::app {

    /// Top-level entry: parse CLI and dispatch to help, version, or collector.
    class Application {
      public:
        Application(int argc, char* argv[]) noexcept;

        [[nodiscard]] int run();

      private:
        [[nodiscard]] int dispatch(const cli::Options& options);

        int argc_;
        char** argv_;
        io::StdoutWriter stdout_;
        io::StderrWriter stderr_{2};
    };

} // namespace defaultproject::app
