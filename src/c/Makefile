TARGET = calculator.so
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	gcc -Wall -fPIC -shared $(shell python3-config --includes --ldflags) -o $(TARGET) $(SOURCES)
	# flags used: -Wall: warnings, -fPIC: position independent code, -shared: shared library for Python 

clean:
	rm -f $(TARGET)

.PHONY: all clean
