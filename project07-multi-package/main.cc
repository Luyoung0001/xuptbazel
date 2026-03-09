#include <iostream>
#include "src/core/math.h"
#include "src/utils/string_utils.h"

int main() {
    std::cout << "2^10 = " << power(2, 10) << std::endl;
    std::cout << repeat("Hello ", 3) << std::endl;
    return 0;
}
