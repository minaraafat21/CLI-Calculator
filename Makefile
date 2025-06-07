# Makefile for CLI Calculator Project
# DevOps & Quality Assurance Configuration

# Variables
PYTHON := python3
PIP := pip3
CC := gcc
CFLAGS := -Wall -Wextra -std=c99 -fPIC
DEBUG_FLAGS := -g -O0 -DDEBUG
RELEASE_FLAGS := -O3 -DNDEBUG
LDFLAGS := -shared

# Directories
SRC_DIR := src
C_SRC_DIR := $(SRC_DIR)/c
PYTHON_SRC_DIR := $(SRC_DIR)/python
TEST_DIR := tests
C_TEST_DIR := $(TEST_DIR)/c
PYTHON_TEST_DIR := $(TEST_DIR)/python
BUILD_DIR := build
DIST_DIR := dist
DOCS_DIR := docs

# Source files
C_SOURCES := $(wildcard $(C_SRC_DIR)/*.c)
C_HEADERS := $(wildcard $(C_SRC_DIR)/*.h)
C_OBJECTS := $(C_SOURCES:$(C_SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
C_TEST_SOURCES := $(wildcard $(C_TEST_DIR)/*.c)

# Shared library
SHARED_LIB := $(BUILD_DIR)/libcalculator.so

# Python extension
PYTHON_EXT := $(PYTHON_SRC_DIR)/cli_calculator/_calculator$(shell python3-config --extension-suffix)

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

.PHONY: all build build-c build-python test test-c test-python clean install install-dev format lint typecheck security-check coverage docs help setup-dev

# Default target
all: build test

# Help target
help:
	@echo "$(BLUE)CLI Calculator Build System$(NC)"
	@echo ""
	@echo "$(GREEN)Build Targets:$(NC)"
	@echo "  build        - Build C backend and Python package"
	@echo "  build-c      - Build C backend only"
	@echo "  build-python - Build Python package only"
	@echo "  debug        - Build with debug symbols"
	@echo "  release      - Build optimized release version"
	@echo ""
	@echo "$(GREEN)Test Targets:$(NC)"
	@echo "  test         - Run all tests"
	@echo "  test-c       - Run C unit tests"
	@echo "  test-python  - Run Python tests"
	@echo "  coverage     - Run tests with coverage report"
	@echo "  benchmark    - Run performance benchmarks"
	@echo ""
	@echo "$(GREEN)Quality Targets:$(NC)"
	@echo "  format       - Format all code"
	@echo "  lint         - Run all linters"
	@echo "  typecheck    - Run type checking"
	@echo "  security-check - Run security scans"
	@echo "  pre-commit   - Run pre-commit hooks"
	@echo ""
	@echo "$(GREEN)Documentation:$(NC)"
	@echo "  docs         - Generate documentation"
	@echo "  docs-serve   - Serve documentation locally"
	@echo ""
	@echo "$(GREEN)Utility Targets:$(NC)"
	@echo "  clean        - Clean build artifacts"
	@echo "  install      - Install package"
	@echo "  install-dev  - Install in development mode"
	@echo "  setup-dev    - Setup development environment"

# Setup development environment
setup-dev:
	@echo "$(BLUE)Setting up development environment...$(NC)"
	$(PIP) install -r requirements-dev.txt
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "$(GREEN)Development environment ready!$(NC)"

# Create directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Build targets
build: build-c build-python
	@echo "$(GREEN)Build completed successfully!$(NC)"

# Build C backend
build-c: $(BUILD_DIR) $(C_OBJECTS) $(SHARED_LIB)
	@echo "$(GREEN)C backend built successfully!$(NC)"

# Compile C object files
$(BUILD_DIR)/%.o: $(C_SRC_DIR)/%.c $(C_HEADERS)
	@echo "$(BLUE)Compiling $<...$(NC)"
	$(CC) $(CFLAGS) $(RELEASE_FLAGS) -c $< -o $@

# Create shared library
$(SHARED_LIB): $(C_OBJECTS)
	@echo "$(BLUE)Creating shared library...$(NC)"
	$(CC) $(LDFLAGS) -o $@ $^

# Build Python package
build-python: build-c
	@echo "$(BLUE)Building Python package...$(NC)"
	$(PYTHON) setup.py build_ext --inplace
	@echo "$(GREEN)Python package built successfully!$(NC)"

# Debug build
debug: CFLAGS += $(DEBUG_FLAGS)
debug: clean build-c
	@echo "$(GREEN)Debug build completed!$(NC)"

# Release build
release: CFLAGS += $(RELEASE_FLAGS)
release: clean build
	@echo "$(GREEN)Release build completed!$(NC)"

# Test targets
test: test-c test-python
	@echo "$(GREEN)All tests passed!$(NC)"

# Test C backend
test-c: build-c
	@echo "$(BLUE)Running C unit tests...$(NC)"
	@if [ -f "$(C_TEST_DIR)/test_runner" ]; then \
		$(C_TEST_DIR)/test_runner; \
	else \
		echo "$(YELLOW)Building C test runner...$(NC)"; \
		$(CC) $(CFLAGS) -I$(C_SRC_DIR) -I$(C_TEST_DIR)/unity \
			$(C_TEST_SOURCES) $(C_TEST_DIR)/unity/unity.c $(C_OBJECTS) \
			-o $(C_TEST_DIR)/test_runner; \
		$(C_TEST_DIR)/test_runner; \
	fi

# Test Python package
test-python: build-python
	@echo "$(BLUE)Running Python tests...$(NC)"
	$(PYTHON) -m pytest $(PYTHON_TEST_DIR)/ -v

# Integration tests
test-integration: build
	@echo "$(BLUE)Running integration tests...$(NC)"
	$(PYTHON) -m pytest $(TEST_DIR)/integration/ -v

# Coverage testing
coverage: build
	@echo "$(BLUE)Running tests with coverage...$(NC)"
	coverage run -m pytest $(PYTHON_TEST_DIR)/
	coverage report
	coverage html
	@echo "$(GREEN)Coverage report generated in htmlcov/$(NC)"

# Performance benchmarks
benchmark: build
	@echo "$(BLUE)Running performance benchmarks...$(NC)"
	$(PYTHON) -m pytest $(TEST_DIR)/benchmarks/ -v --benchmark-only

# Code quality targets
format:
	@echo "$(BLUE)Formatting code...$(NC)"
	black $(PYTHON_SRC_DIR) $(TEST_DIR)
	isort $(PYTHON_SRC_DIR) $(TEST_DIR)
	find $(C_SRC_DIR) -name "*.c" -o -name "*.h" | xargs clang-format -i
	@echo "$(GREEN)Code formatting completed!$(NC)"

# Linting
lint:
	@echo "$(BLUE)Running linters...$(NC)"
	flake8 $(PYTHON_SRC_DIR) $(TEST_DIR)
	pylint $(PYTHON_SRC_DIR)
	@if command -v cppcheck >/dev/null 2>&1; then \
		echo "$(BLUE)Running C linter...$(NC)"; \
		cppcheck --enable=all --error-exitcode=1 $(C_SRC_DIR)/; \
	else \
		echo "$(YELLOW)cppcheck not found, skipping C linting$(NC)"; \
	fi
	@echo "$(GREEN)Linting completed!$(NC)"

# Type checking
typecheck:
	@echo "$(BLUE)Running type checker...$(NC)"
	mypy $(PYTHON_SRC_DIR)
	@echo "$(GREEN)Type checking completed!$(NC)"

# Security scanning
security-check:
	@echo "$(BLUE)Running security scans...$(NC)"
	bandit -r $(PYTHON_SRC_DIR)/
	safety check
	@echo "$(GREEN)Security scan completed!$(NC)"

# Pre-commit hooks
pre-commit:
	@echo "$(BLUE)Running pre-commit hooks...$(NC)"
	pre-commit run --all-files

# Documentation
docs:
	@echo "$(BLUE)Generating documentation...$(NC)"
	@if [ -d "$(DOCS_DIR)" ]; then \
		cd $(DOCS_DIR) && make html; \
	else \
		echo "$(YELLOW)Docs directory not found, creating basic docs...$(NC)"; \
		mkdir -p $(DOCS_DIR); \
		sphinx-quickstart -q -p "CLI Calculator" -a "Team" -v "1.0" $(DOCS_DIR); \
		cd $(DOCS_DIR) && make html; \
	fi
	@echo "$(GREEN)Documentation generated in $(DOCS_DIR)/_build/html/$(NC)"

docs-serve: docs
	@echo "$(BLUE)Serving documentation at http://localhost:8000$(NC)"
	cd $(DOCS_DIR)/_build/html && $(PYTHON) -m http.server 8000

# Installation targets
install: build
	@echo "$(BLUE)Installing package...$(NC)"
	$(PIP) install .

install-dev: build
	@echo "$(BLUE)Installing in development mode...$(NC)"
	$(PIP) install -e .

# Package building
package: clean build
	@echo "$(BLUE)Building distribution packages...$(NC)"
	$(PYTHON) -m build
	twine check $(DIST_DIR)/*
	@echo "$(GREEN)Packages built successfully in $(DIST_DIR)/$(NC)"

# Cleaning
clean:
	@echo "$(BLUE)Cleaning build artifacts...$(NC)"
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)
	rm -rf *.egg-info
	rm -rf htmlcov
	rm -rf .coverage
	rm -rf .pytest_cache
	rm -rf __pycache__
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -name "*.so" -delete
	rm -f $(C_TEST_DIR)/test_runner
	@echo "$(GREEN)Clean completed!$(NC)"

# Deep clean (including dependencies)
clean-all: clean
	@echo "$(BLUE)Deep cleaning...$(NC)"
	rm -rf venv
	rm -rf .venv
	rm -rf node_modules
	@echo "$(GREEN)Deep clean completed!$(NC)"

# Development workflow helpers
dev-setup: setup-dev build-dev
	@echo "$(GREEN)Development setup completed!$(NC)"

build-dev: debug install-dev
	@echo "$(GREEN)Development build completed!$(NC)"

# Continuous Integration helpers
ci-setup:
	@echo "$(BLUE)Setting up CI environment...$(NC)"
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install -r requirements-dev.txt

ci-test: build test lint typecheck security-check
	@echo "$(GREEN)CI tests completed!$(NC)"

ci-package: package
	@echo "$(GREEN)CI packaging completed!$(NC)"

# Git hooks
install-hooks:
	@echo "$(BLUE)Installing git hooks...$(NC)"
	cp scripts/pre-commit .git/hooks/pre-commit
	cp scripts/pre-push .git/hooks/pre-push
	chmod +x .git/hooks/pre-commit
	chmod +x .git/hooks/pre-push
	@echo "$(GREEN)Git hooks installed!$(NC)"

# Dependency management
update-deps:
	@echo "$(BLUE)Updating dependencies...$(NC)"
	$(PIP) list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 $(PIP) install -U
	$(PIP) freeze > requirements.txt
	@echo "$(GREEN)Dependencies updated!$(NC)"

# Security audit
audit:
	@echo "$(BLUE)Running security audit...$(NC)"
	$(PIP) audit
	@echo "$(GREEN)Security audit completed!$(NC)"

# Performance profiling
profile: build
	@echo "$(BLUE)Running performance profiling...$(NC)"
	$(PYTHON) -m cProfile -s cumulative -o profile.stats $(PYTHON_SRC_DIR)/cli_calculator/cli.py 2 + 3
	@echo "$(GREEN)Profile saved to profile.stats$(NC)"

# Memory checking (requires valgrind)
memcheck: build-c
	@echo "$(BLUE)Running memory check...$(NC)"
	@if command -v valgrind >/dev/null 2>&1; then \
		valgrind --leak-check=full --show-leak-kinds=all $(C_TEST_DIR)/test_runner; \
	else \
		echo "$(YELLOW)valgrind not found, skipping memory check$(NC)"; \
	fi

# Static analysis
analyze:
	@echo "$(BLUE)Running static analysis...$(NC)"
	@if command -v scan-build >/dev/null 2>&1; then \
		scan-build make build-c; \
	else \
		echo "$(YELLOW)scan-build not found, using cppcheck$(NC)"; \
		cppcheck --enable=all --xml $(C_SRC_DIR)/ 2> analysis.xml; \
	fi
	@echo "$(GREEN)Static analysis completed!$(NC)"

# Docker support
docker-build:
	@echo "$(BLUE)Building Docker image...$(NC)"
	docker build -t cli-calculator .

docker-test: docker-build
	@echo "$(BLUE)Running tests in Docker...$(NC)"
	docker run --rm cli-calculator make test

# Show project statistics
stats:
	@echo "$(BLUE)Project Statistics:$(NC)"
	@echo "C Source Lines: $(find $(C_SRC_DIR) -name '*.c' -exec wc -l {} + | tail -1 | awk '{print $1}')"
	@echo "C Header Lines: $(find $(C_SRC_DIR) -name '*.h' -exec wc -l {} + | tail -1 | awk '{print $1}')"
	@echo "Python Lines: $(find $(PYTHON_SRC_DIR) -name '*.py' -exec wc -l {} + | tail -1 | awk '{print $1}')"
	@echo "Test Lines: $(find $(TEST_DIR) -name '*.py' -o -name '*.c' -exec wc -l {} + | tail -1 | awk '{print $1}')"
	@echo "Total Files: $(find . -name '*.py' -o -name '*.c' -o -name '*.h' | wc -l)"

# Check dependencies
check-deps:
	@echo "$(BLUE)Checking dependencies...$(NC)"
	$(PIP) check
	@echo "$(GREEN)Dependencies check completed!$(NC)"