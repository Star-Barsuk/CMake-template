#pragma once

namespace defaultproject::cli {

    enum class Action {
        Help,
        Version,
    };

    struct Options {
        Action action{Action::Help};

        /// Set when parsing fails; message suitable for stderr.
        const char* error{nullptr};
    };

    [[nodiscard]] inline bool parse_ok(const Options& o) noexcept {
        return o.error == nullptr;
    }

} // namespace defaultproject::cli
