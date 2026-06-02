#include <defaultproject/calculator/calculator.hpp>
#include <defaultproject/util/cast.hpp>

namespace defaultproject::calculator {

    int add(int lhs, int rhs) {
        return util::narrow_cast<int>(lhs + rhs);
    }

    int sub(int lhs, int rhs) {
        return util::narrow_cast<int>(lhs - rhs);
    }

    float distance(math::Vector2 from, math::Vector2 to) {
        return math::vector_length(math::vector_sub(to, from));
    }

} // namespace defaultproject::calculator
