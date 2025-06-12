TARGET = calculator.so
SOURCES = calculator.c calculator_module.c

PYTHON_LIB = -lpython$(shell python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

all: $(TARGET)

$(TARGET): $(SOURCES)
	gcc -Wall -fPIC -shared $(shell python3-config --includes) -o $(TARGET) $(SOURCES) $(shell python3-config --ldflags) $(PYTHON_LIB)
	# flags used: -Wall: warnings, -fPIC: position independent code, -shared: shared library for Python 

clean:
	rm -f $(TARGET)

.PHONY: all clean
