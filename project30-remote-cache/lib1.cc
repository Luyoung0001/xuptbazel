#include "lib1.h"

int compute1(int n) {
    int result = 0;
    for (int i = 0; i < n * 1000; i++) {
        result += i % 7;
    }
    return result;
}
