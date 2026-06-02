#pragma once

namespace defaultproject::util {

    template<typename T, typename U>
    constexpr T narrow_cast(U value) {
        return static_cast<T>(value);
    }

} // namespace defaultproject::util
