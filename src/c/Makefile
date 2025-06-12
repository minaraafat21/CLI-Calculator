ifeq ($(OS),Windows_NT)
    EXT = pyd
    PYTHON = python
    RM = del /Q
    NULLDEV = nul
    PYINCLUDE := $(shell $(PYTHON) -c "from sysconfig import get_paths as gp; print(gp()['include'])")
    PYLIB := $(shell $(PYTHON) -c "import sysconfig; print(sysconfig.get_config_var('LIBDIR'))")
    PYVER := $(shell $(PYTHON) -c "import sys; print(f'{sys.version_info.major}{sys.version_info.minor}')")
    LINK := -L"$(PYLIB)" -lpython$(PYVER)
    CFLAGS := -Wall -shared -I"$(PYINCLUDE)" -DMS_WIN64
else
    EXT = so
    PYTHON = python3
    RM = rm -f
    NULLDEV = /dev/null
    LINK := $(shell $(PYTHON)-config --ldflags)
    CFLAGS := -Wall -fPIC -shared $(shell $(PYTHON)-config --includes)
endif

TARGET = calculator.$(EXT)
SOURCES = calculator.c calculator_module.c

all: $(TARGET)

$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $(SOURCES) $(LINK)

clean:
	$(RM) $(TARGET) > $(NULLDEV) 2>&1

.PHONY: all clean
