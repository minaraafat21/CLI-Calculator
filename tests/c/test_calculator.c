#include "calculator.h"
#include <assert.h>
#include <stdio.h>

int main() {
    // Test addition
    assert(add(2, 3) == 5.0);
    assert(add(-1, 1) == 0.0);
    assert(add(0, 0) == 0.0);

    // Test subtraction
    assert(subtract(5, 3) == 2.0);
    assert(subtract(3, 5) == -2.0);
    assert(subtract(0, 0) == 0.0);

    // Test multiplication
    assert(multiply(2, 3) == 6.0);
    assert(multiply(-1, 1) == -1.0);
    assert(multiply(0, 5) == 0.0);

    // Test division
    int error;
    double result = divide(10, 2, &error);
    assert(error == 0);
    assert(result == 5.0);

    result = divide(10, 0, &error);
    assert(error == 1);

    printf("All C tests passed.\n");
    return 0;
}