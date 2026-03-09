#include <iostream>
#include <string>

int main(int argc, char* argv[]) {
    std::string name = (argc > 1) ? argv[1] : "World";
    std::cout << "Hello from C++, " << name << "!" << std::endl;
    return 0;
}
