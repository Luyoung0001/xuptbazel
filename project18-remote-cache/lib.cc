#include "lib.h"
#include "lib1.h"
#include "lib2.h"
#include "lib3.h"

int compute(int n) {
    int result = 0;
    result += compute1(n);
    result += compute2(n);
    result += compute3(n);
    for (int i = 0; i < n; i++) {
        result += i * i;
    }
    return result;
}
