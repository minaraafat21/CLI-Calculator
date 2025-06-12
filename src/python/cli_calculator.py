"""CLI Calculator module."""

import argparse

from calculator import add, divide, multiply, subtract


def calculate(operation, num1, num2):
    """Map the operation to the corresponding C function."""
    if operation == "add":
        return add(num1, num2)
    if operation == "subtract":
        return subtract(num1, num2)
    if operation == "multiply":
        return multiply(num1, num2)
    if operation == "divide":
        return divide(num1, num2)
    raise ValueError("Invalid operation")  # Fallback safety


def main():
    """Parse arguments and execute the calculation."""
    parser = argparse.ArgumentParser(description="CLI Calculator")
    parser.add_argument(
        "operation",
        choices=["add", "subtract", "multiply", "divide"],
        help="Operation to perform"
    )
    parser.add_argument("num1", type=float, help="First number")
    parser.add_argument("num2", type=float, help="Second number")

    args = parser.parse_args()

    try:
        result = calculate(args.operation, args.num1, args.num2)
        print(f"Result: {result}")
    except ValueError as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
