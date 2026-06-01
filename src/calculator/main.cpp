#include <iostream>
#include "calculator.hpp"

int main()
{
    std::cout << "2 + 3 = "
              << add(2, 3)
              << '\n';

    std::cout << "10 - 4 = "
              << sub(10, 4)
              << '\n';
}
