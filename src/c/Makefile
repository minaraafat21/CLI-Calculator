TARGET = calculator.so
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	gcc -Wall -fPIC -shared $(shell python3-config --includes) -o $(TARGET) $(SOURCES) $(shell python3-config --ldflags)
	# flags used: -Wall: warnings, -fPIC: position independent code, -shared: shared library for Python 

clean:
	rm -f $(TARGET)

.PHONY: all clean
