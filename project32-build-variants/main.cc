#include <iostream>

#ifdef DEBUG
void debug_log(const char* msg) {
    std::cout << "[DEBUG] " << msg << std::endl;
}
#else
void debug_log(const char* msg) {}
#endif

int compute(int n) {
    debug_log("Starting computation");
    int result = 0;
    for (int i = 0; i < n; i++) {
        result += i;
    }
    return result;
}

int main() {
    std::cout << "Result: " << compute(100) << std::endl;

#ifdef DEBUG
    std::cout << "Running in DEBUG mode" << std::endl;
#else
    std::cout << "Running in RELEASE mode" << std::endl;
#endif

    return 0;
}
