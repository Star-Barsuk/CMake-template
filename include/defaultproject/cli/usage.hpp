#pragma once

#include <defaultproject/io/stdout_writer.hpp>

namespace defaultproject::cli {

    /// Renders built-in help and version strings.
    class Usage {
      public:
        static void print_help(io::StdoutWriter& out);
        static void print_version(io::StdoutWriter& out);
    };

} // namespace defaultproject::cli
