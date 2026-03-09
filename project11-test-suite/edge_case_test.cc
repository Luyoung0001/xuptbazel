#include "calculator.h"
#include <iostream>
#include <stdexcept>

int main() {
    Calculator calc;

    // Test division by zero
    try {
        calc.divide(10, 0);
        std::cout << "FAIL: Should throw on division by zero" << std::endl;
        return 1;
    } catch (const std::runtime_error&) {
        std::cout << "PASS: Division by zero throws" << std::endl;
    }

    // Test negative numbers
    if (calc.add(-5, -3) != -8) {
        std::cout << "FAIL: Negative addition" << std::endl;
        return 1;
    }

    std::cout << "Edge case tests passed!" << std::endl;
    return 0;
}
