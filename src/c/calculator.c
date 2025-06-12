#include "calculator.h"
#include <stdio.h>

double add(double a, double b) { return a + b; }
double subtract(double a, double b) { return a - b; }
double multiply(double a, double b) { return a * b; }
double divide(double a, double b) {
  if (b == 0) { // handle zero division
    printf("Error: Division by zero is not allowed.\n");
    // it will also raise a python error before even being passed here
  }
  return a / b;
}
