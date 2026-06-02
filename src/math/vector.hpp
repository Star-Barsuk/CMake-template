#pragma once

struct Vector2 {
    float x{};
    float y{};
};

Vector2 vector_add(Vector2 lhs, Vector2 rhs);
Vector2 vector_sub(Vector2 lhs, Vector2 rhs);
float vector_length(Vector2 v);
