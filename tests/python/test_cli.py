import pytest
from unittest.mock import patch
from calculator.cli_calculator import main

# Tests for the CLI
def test_cli_add(capsys):
    with patch('sys.argv', ['cli_calculator.py', 'add', '2', '3']):
        with patch('calculator.add', return_value=5):
            main()
            captured = capsys.readouterr()
            assert "Result: 5" in captured.out

def test_cli_divide_by_zero(capsys):
    with patch('sys.argv', ['cli_calculator.py', 'divide', '10', '0']):
        with patch('calculator.divide', side_effect=ValueError("division by zero")):
            main()
            captured = capsys.readouterr()
            assert "Error: division by zero" in captured.out

def test_cli_invalid_operation(capsys):
    with patch('sys.argv', ['cli_calculator.py', 'invalid', '2', '3']):
        with pytest.raises(SystemExit) as exc_info:
            main()
        captured = capsys.readouterr()
        assert "error: argument operation: invalid choice" in captured.err
        assert exc_info.value.code == 2