import argparse
from calculator import add, subtract, multiply, divide

def calculate(operation, num1, num2):
    """Map the operation to the corresponding C function."""
    if operation == "add":
        return add(num1, num2)
    elif operation == "subtract":
        return subtract(num1, num2)
    elif operation == "multiply":
        return multiply(num1, num2)
    elif operation == "divide":
        return divide(num1, num2)
    else:
        raise ValueError("Invalid operation")  # Fallback safety

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="CLI Calculator")
    parser.add_argument("operation", choices=["add", "subtract", "multiply", "divide"], 
                        help="Operation to perform")
    parser.add_argument("num1", type=float, help="First number")
    parser.add_argument("num2", type=float, help="Second number")
    
    # Parse arguments
    args = parser.parse_args()

    # Execute calculation and handle errors
    try:
        result = calculate(args.operation, args.num1, args.num2)
        print(f"Result: {result}")
    except ValueError as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()