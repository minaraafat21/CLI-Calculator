# Simple cross-platform Makefile
ifeq ($(OS),Windows_NT)
    PYTHON = python
    EXT = pyd
    CFLAGS = -shared -I$(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_path('include'))")
    LDFLAGS = -L$(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_path('stdlib').replace('Lib', 'libs'))") -lpython$(shell $(PYTHON) -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')")
    RM = del
else
    PYTHON = python3
    EXT = so
    CFLAGS = -shared -fPIC $(shell $(PYTHON)-config --cflags)
    LDFLAGS = $(shell $(PYTHON)-config --ldflags)
    RM = rm -f
endif

TARGET = calculator.$(EXT)
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	gcc $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	$(RM) calculator.so calculator.pyd

.PHONY: all clean
