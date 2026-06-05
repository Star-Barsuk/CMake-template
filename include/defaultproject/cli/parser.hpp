#pragma once

#include <defaultproject/cli/options.hpp>

namespace defaultproject::cli {

    /// Converts `argc`/`argv` into `Options` without heap allocation.
    class Parser {
      public:
        [[nodiscard]] static Options parse(int argc, char* argv[]);
    };

} // namespace defaultproject::cli
