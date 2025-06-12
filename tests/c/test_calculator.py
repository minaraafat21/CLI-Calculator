import pytest
from calculator import add, subtract, multiply, divide


def test_add():
    assert add(2, 3) == 5            # Normal case
    assert add(-1, 1) == 0           # Edge case: negative + positive
    assert add(0, 0) == 0            # Edge case: zeros
    assert add(2.5, 3.5) == 6.0      # Float support


def test_subtract():
    assert subtract(5, 3) == 2       # Normal case
    assert subtract(3, 5) == -2      # Edge case: negative result
    assert subtract(0, 0) == 0       # Edge case: zeros
    assert subtract(5.5, 3.5) == 2.0  # Float support


def test_multiply():
    assert multiply(2, 3) == 6       # Normal case
    assert multiply(-1, 1) == -1     # Edge case: negative
    assert multiply(0, 5) == 0       # Edge case: zero
    assert multiply(2.5, 2) == 5.0   # Float support


def test_divide():
    assert divide(10, 2) == 5        # Normal case
    assert divide(3, 2) == 1.5       # Float result
    assert divide(0, 5) == 0         # Edge case: zero numerator
    with pytest.raises(ZeroDivisionError):  # Error case: division by zero
        divide(10, 0)
