# Detect OS and platform
PYTHON := python3
UNAME_S := $(shell uname -s)

ifeq ($(OS),Windows_NT)
    PYTHON := python
endif

# Get Python version numbers
PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")
PYTHON_LIBVER := $(shell $(PYTHON) -c "import sys; print('python{}{}'.format(sys.version_info.major, sys.version_info.minor))")

# Get include and lib dirs
PYTHON_INCLUDE := $(shell $(PYTHON) -c "from sysconfig import get_paths as gp; print(gp()['include'])")
PYTHON_LIBDIR := $(shell $(PYTHON) -c "import sys, os; print(os.path.join(sys.exec_prefix, 'libs'))")

EXT := so
SHARED_FLAGS := -shared -fPIC

ifeq ($(OS),Windows_NT)
    EXT := pyd
    SHARED_FLAGS := -shared
endif

TARGET = calculator.$(EXT)
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

ifeq ($(OS),Windows_NT)
$(TARGET): $(SOURCES)
    @gcc -Wall $(SHARED_FLAGS) -I"$(PYTHON_INCLUDE)" -o $(TARGET) $(SOURCES) -L"$(PYTHON_LIBDIR)" -l$(PYTHON_LIBVER)
else ifeq ($(UNAME_S),Darwin)
$(TARGET): $(SOURCES)
    @gcc -Wall $(SHARED_FLAGS) $(shell $(PYTHON)-config --includes) -o $(TARGET) $(SOURCES) $(shell $(PYTHON)-config --ldflags) -lpython$(PYTHON_VERSION)
else
$(TARGET): $(SOURCES)
    @gcc -Wall $(SHARED_FLAGS) $(shell $(PYTHON)-config --includes) -o $(TARGET) $(SOURCES) $(shell $(PYTHON)-config --ldflags)
endif

clean:
    @rm -f calculator.so calculator.pyd

.PHONY: all clean
