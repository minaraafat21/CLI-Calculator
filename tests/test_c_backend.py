"""Tests for the C backend calculator module."""

from calculator import add, divide, multiply, subtract

import pytest


def test_add():
    """Test the add function."""
    assert add(2, 3) == 5            # Normal case
    assert add(-1, 1) == 0           # Edge case: negative + positive
    assert add(0, 0) == 0            # Edge case: zeros
    assert add(2.5, 3.5) == 6.0      # Float support


def test_subtract():
    """Test the subtract function."""
    assert subtract(5, 3) == 2       # Normal case
    assert subtract(3, 5) == -2      # Edge case: negative result
    assert subtract(0, 0) == 0       # Edge case: zeros


def test_multiply():
    """Test the multiply function."""
    assert multiply(2, 3) == 6
    assert multiply(-1, 1) == -1
    assert multiply(0, 5) == 0
    assert multiply(2.5, 2) == 5.0


def test_divide():
    """Test the divide function."""
    assert divide(6, 3) == 2
    assert divide(5, 2) == 2.5
    assert divide(-6, 3) == -2
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)
