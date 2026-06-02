#include "calculator.hpp"

int add(int lhs, int rhs) {
    return lhs + rhs;
}

int sub(int lhs, int rhs) {
    return lhs - rhs;
}

float distance(Vector2 from, Vector2 to) {
    return vector_length(vector_sub(to, from));
}
