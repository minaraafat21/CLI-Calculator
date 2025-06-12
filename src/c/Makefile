# Detect OS and platform
PYTHON_VERSION := $(shell python3 -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")
UNAME_S := $(shell uname -s)

ifeq ($(OS),Windows_NT)
    PYTHON := python
    PYTHON_INCLUDE := $(shell $(PYTHON) -c "from sysconfig import get_paths as gp; print(gp()['include'])")
    PYTHON_LIBDIR := $(shell $(PYTHON) -c "from sysconfig import get_paths as gp; print(gp()['include'] + '/../libs')")
    PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")
    EXT := pyd
    SHARED_FLAGS := -shared
else
    PYTHON := python3
    PYTHON_INCLUDE := $(shell $(PYTHON)-config --includes)
    PYTHON_LDFLAGS := $(shell $(PYTHON)-config --ldflags)
    EXT := so
    SHARED_FLAGS := -shared -fPIC
endif

TARGET = calculator.$(EXT)
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

ifeq ($(OS),Windows_NT)
$(TARGET): $(SOURCES)
    # Windows build (tab at start)
	gcc -Wall $(SHARED_FLAGS) -I"$(PYTHON_INCLUDE)" -o $(TARGET) $(SOURCES) -L"$(PYTHON_LIBDIR)" -lpython$(PYTHON_VERSION)
else ifeq ($(UNAME_S),Darwin)
$(TARGET): $(SOURCES)
    # macOS build (tab at start)
	gcc -Wall $(SHARED_FLAGS) $(PYTHON_INCLUDE) -o $(TARGET) $(SOURCES) $(PYTHON_LDFLAGS) -lpython$(PYTHON_VERSION)
else
$(TARGET): $(SOURCES)
    # Linux build (tab at start)
	gcc -Wall $(SHARED_FLAGS) $(PYTHON_INCLUDE) -o $(TARGET) $(SOURCES) $(PYTHON_LDFLAGS)
endif

clean:
	rm -f calculator.so calculator.pyd

.PHONY: all clean
