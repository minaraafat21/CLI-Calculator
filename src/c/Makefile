CC = gcc
CFLAGS = -Wall -Werror -fPIC
PYTHON_INCLUDE = $(shell python3-config --includes)
PYTHON_LIB = $(shell python3-config --ldflags)

all: calculator_module.so

calculator_module.so: calculator_module.c calculator.c
	$(CC) $(CFLAGS) -shared -o $@ $^ $(PYTHON_INCLUDE) $(PYTHON_LIB)

test: test_calculator
	./test_calculator

test_calculator: test_calculator.c calculator.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f calculator_module.so test_calculator
