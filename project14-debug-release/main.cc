#include <iostream>

int main() {
#ifdef DEBUG
    std::cout << "Debug mode enabled" << std::endl;
#else
    std::cout << "Release mode" << std::endl;
#endif
    return 0;
}
