#include <algorithm>
#include <iostream>
#include <string>
#include <vector>

namespace engine::core {

    class Logger {
      public:
        explicit Logger(std::string loggerName)
            : name(std::move(loggerName)) {
        }

        void log(const std::string& message) {
            std::cout << "[" << name << "] " << message << '\n';
        }

      private:
        std::string name;
    };

    struct Point {
        float x{};
        float y{};
    };

    Point makePoint(float x, float y) {
        return Point{x, y};
    }

} // namespace engine::core

namespace math {

    int add(int a, int b) {
        return a + b;
    }

    int multiply(int a, int b) {
        return a * b;
    }

    template<typename T>
    T sum(const std::vector<T>& values) {
        T result{};

        for (const auto& v : values) {
            result = result + v;
        }

        return result;
    }

} // namespace math

int computeComplexValue(int x) {
    if (x < 0) {
        return -1;
    } else if (x == 0) {
        return 0;
    } else {
        return x * x + 42;
    }
}

int main() {
    engine::core::Logger logger("DEMO");

    logger.log("Starting formatting stress test");

    std::vector<int> values = {1, 2, 3, 4, 5, 6};

    auto lambda = [](int a, int b) {
        return a + b;
    };

    int result = 0;

    for (int i = 0; i < 10; i++) {
        result += lambda(i, i * 2);
    }

    int sumValue = math::sum(values);

    int complex = computeComplexValue(5);

    if (complex > 10) {
        logger.log("Complex value is large");
    } else {
        logger.log("Complex value is small");
    }

    std::cout << "Result: " << result << ", Sum: " << sumValue << ", Complex: " << complex << '\n';

    auto heavyLambda = [](int x, int y, int z, int w) {
        return (x + y) * (z + w);
    };

    int finalValue = heavyLambda(1, 2, 3, 4);

    logger.log("Final value computed: " + std::to_string(finalValue));

    return 0;
}
