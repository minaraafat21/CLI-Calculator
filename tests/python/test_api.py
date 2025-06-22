"""Unit tests for the calculator API."""

# Standard Library
from unittest.mock import patch

# Third Party
import pytest

# First Party
from calculator.cli_calculator import calculate


# Tests for the calculate function
@patch("calculator.cli_calculator.add")
def test_calculate_add(mock_add):
    """Test addition operation."""
    mock_add.return_value = 5
    result = calculate("add", 2, 3)
    assert result == 5
    mock_add.assert_called_once_with(2, 3)


@patch("calculator.cli_calculator.subtract")
def test_calculate_subtract(mock_subtract):
    """Test subtraction operation."""
    mock_subtract.return_value = 2
    result = calculate("subtract", 5, 3)
    assert result == 2
    mock_subtract.assert_called_once_with(5, 3)


@patch("calculator.cli_calculator.multiply")
def test_calculate_multiply(mock_multiply):
    """Test multiplication operation."""
    mock_multiply.return_value = 6
    result = calculate("multiply", 2, 3)
    assert result == 6
    mock_multiply.assert_called_once_with(2, 3)


@patch("calculator.cli_calculator.divide")
def test_calculate_divide(mock_divide):
    """Test division operation."""
    mock_divide.return_value = 5
    result = calculate("divide", 10, 2)
    assert result == 5
    mock_divide.assert_called_once_with(10, 2)


@patch("calculator.cli_calculator.power")
def test_calculate_power(mock_power):
    """Test multiplication operation."""
    mock_power.return_value = 8
    result = calculate("power", 2, 3)
    assert result == 8
    mock_power.assert_called_once_with(2, 3)


def test_calculate_invalid_operation():
    """Test invalid operation."""
    with pytest.raises(ValueError, match="Invalid operation"):
        calculate("invalid", 2, 3)


@patch("calculator.cli_calculator.divide")
def test_calculate_divide_by_zero(mock_divide):
    """Test division by zero operation."""
    mock_divide.side_effect = ValueError("division by zero")
    with pytest.raises(ValueError, match="division by zero"):
        calculate("divide", 10, 0)
