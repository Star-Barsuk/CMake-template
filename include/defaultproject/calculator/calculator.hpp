#pragma once

#include <defaultproject/math/vector.hpp>

namespace defaultproject::calculator {

    int add(int lhs, int rhs);
    int sub(int lhs, int rhs);
    float distance(math::Vector2 from, math::Vector2 to);

} // namespace defaultproject::calculator
