#include "lib/public_api.h"
#include "lib/internal.h"

int process(int x) {
    return secret_calculation(x) * 2;
}
