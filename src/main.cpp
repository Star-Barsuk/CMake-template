#include "calculator.hpp"

#include <iostream>

int main() {
    std::cout << "2 + 3 = " << add(2, 3) << '\n';
    std::cout << "10 - 4 = " << sub(10, 4) << '\n';
    std::cout << "distance (0,0)-(3,4) = " << distance({0.0F, 0.0F}, {3.0F, 4.0F}) << '\n';
}
