#include "src/utils/string_utils.h"

std::string repeat(const std::string& str, int times) {
    std::string result;
    for (int i = 0; i < times; i++) {
        result += str;
    }
    return result;
}
