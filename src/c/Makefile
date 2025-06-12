# Detect OS
ifeq ($(OS),Windows_NT)
    PYTHON := python
    PYTHON_INCLUDE := $(shell $(PYTHON) -c "from sysconfig import get_paths as gp; print(gp()['include'])")
    PYTHON_LIB := $(shell $(PYTHON) -c "import sys; print('python{}.{}.lib'.format(sys.version_info.major, sys.version_info.minor))")
    EXT := pyd
    SHARED_FLAGS := -shared
else
    PYTHON := python3
    PYTHON_INCLUDE := $(shell $(PYTHON)-config --includes)
    PYTHON_LDFLAGS := $(shell $(PYTHON)-config --ldflags)
	PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; print('{}.{}'.format(sys.version_info.major, sys.version_info.minor))")
    EXT := so
    SHARED_FLAGS := -shared -fPIC
endif

TARGET = calculator.$(EXT)
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

$(TARGET): $(SOURCES)
ifeq ($(OS),Windows_NT)
    gcc -Wall $(SHARED_FLAGS) -I"$(PYTHON_INCLUDE)" -o $(TARGET) $(SOURCES) -L"$(PYTHON_INCLUDE)/../libs" -l$(PYTHON_LIB)
else
    # Add -lpythonX.Y explicitly for macOS
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		gcc -Wall $(SHARED_FLAGS) $(PYTHON_INCLUDE) -o $(TARGET) $(SOURCES) $(PYTHON_LDFLAGS) -lpython$(PYTHON_VERSION)
    else
        gcc -Wall $(SHARED_FLAGS) $(PYTHON_INCLUDE) -o $(TARGET) $(SOURCES) $(PYTHON_LDFLAGS)
    endif
endif

clean:
	rm -f calculator.so calculator.pyd

.PHONY: all clean
