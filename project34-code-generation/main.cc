#include <iostream>
#include "config.h"

int main() {
    std::cout << "Application: " << APP_NAME << std::endl;
    std::cout << "Version: " << APP_VERSION << std::endl;
    std::cout << "Build Time: " << BUILD_TIME << std::endl;
    return 0;
}
