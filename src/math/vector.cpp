#include "detail/length.hpp"

#include <defaultproject/math/vector.hpp>

namespace defaultproject::math {

    Vector2 vector_add(Vector2 lhs, Vector2 rhs) {
        return {lhs.x + rhs.x, lhs.y + rhs.y};
    }

    Vector2 vector_sub(Vector2 lhs, Vector2 rhs) {
        return {lhs.x - rhs.x, lhs.y - rhs.y};
    }

    float vector_length(Vector2 v) {
        return detail::length_components(v.x, v.y);
    }

} // namespace defaultproject::math
