#pragma once

#include <cmath>

namespace defaultproject::math::detail {

    inline float length_components(float x, float y) {
        return std::hypot(x, y);
    }

} // namespace defaultproject::math::detail
