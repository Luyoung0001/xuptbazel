#include <iostream>
#include "add.h"

int main() {
    if (add(2, 3) != 5) return 1;
    std::cout << "Test passed!" << std::endl;
    return 0;
}
