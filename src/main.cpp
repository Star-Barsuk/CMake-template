#include <defaultproject/calculator/calculator.hpp>
#include <iostream>

int main() {
    using defaultproject::calculator::add;
    using defaultproject::calculator::distance;
    using defaultproject::calculator::sub;
    using defaultproject::math::Vector2;

    std::cout << "2 + 3 = " << add(2, 3) << '\n';
    std::cout << "10 - 4 = " << sub(10, 4) << '\n';
    std::cout << "distance (0,0)-(3,4) = " << distance(Vector2{0.0F, 0.0F}, Vector2{3.0F, 4.0F})
              << '\n';
}
