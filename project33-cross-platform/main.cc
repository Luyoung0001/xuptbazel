#include <iostream>

int main() {
    std::cout << "Cross-platform application" << std::endl;

#ifdef __linux__
    std::cout << "Platform: Linux" << std::endl;
#elif __APPLE__
    std::cout << "Platform: macOS" << std::endl;
#elif _WIN32
    std::cout << "Platform: Windows" << std::endl;
#else
    std::cout << "Platform: Unknown" << std::endl;
#endif

#ifdef __x86_64__
    std::cout << "Architecture: x86_64" << std::endl;
#elif __aarch64__
    std::cout << "Architecture: ARM64" << std::endl;
#endif

    return 0;
}
