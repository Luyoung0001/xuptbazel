#include "calculator.h"
#include <iostream>

#define ASSERT_EQ(a, b) \
    if ((a) != (b)) { \
        std::cout << "FAIL: " << #a << " != " << #b << std::endl; \
        return 1; \
    }

int main() {
    Calculator calc;

    ASSERT_EQ(calc.add(2, 3), 5);
    ASSERT_EQ(calc.subtract(10, 3), 7);
    ASSERT_EQ(calc.multiply(4, 5), 20);
    ASSERT_EQ(calc.divide(10, 2), 5);

    std::cout << "Basic tests passed!" << std::endl;
    return 0;
}
