#include "lib3.h"

int compute3(int n) {
    int result = 0;
    for (int i = 0; i < n * 800; i++) {
        result += (i * i) % 13;
    }
    return result;
}
