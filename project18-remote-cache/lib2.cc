#include "lib2.h"

int compute2(int n) {
    int result = 1;
    for (int i = 1; i < n * 500; i++) {
        result = (result * i) % 1000000;
    }
    return result;
}
