#include "vector.hpp"

#include <cmath>

Vector2 vector_add(Vector2 lhs, Vector2 rhs) {
    return {lhs.x + rhs.x, lhs.y + rhs.y};
}

Vector2 vector_sub(Vector2 lhs, Vector2 rhs) {
    return {lhs.x - rhs.x, lhs.y - rhs.y};
}

float vector_length(Vector2 v) {
    return std::hypot(v.x, v.y);
}
