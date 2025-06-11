#include <Python.h>
#include "calculator.h"


// wrapper functions takes args passed to python, process them in C, and return the result back to Python.
static PyObject* py_add(PyObject* self, PyObject* args) {
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b)) // parses the arguments passed to a Python C function into local C variables.
        return NULL; // If the parsing fails, it returns NULL, which indicates an error in the function call itself
    return Py_BuildValue("d", add(a, b));
}
static PyObject* py_subtract(PyObject* self, PyObject* args) {
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;
    return Py_BuildValue("d", subtract(a, b));
}
static PyObject* py_multiply(PyObject* self, PyObject* args) {
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;
    return Py_BuildValue("d", multiply(a, b));
}
static PyObject* py_divide(PyObject* self, PyObject* args) {
    double a, b;
    if (!PyArg_ParseTuple(args, "dd", &a, &b))
        return NULL;    
    if (b == 0) { // handle zero division
        PyErr_SetString(PyExc_ZeroDivisionError, "division by zero");
        return NULL;
    }   
    double result = divide(a, b);
    return Py_BuildValue("d", result);
}

// method table
static PyMethodDef CalculatorMethods[] = {
    // {callable name, C function pointer, METH_VARARGS-> creates a tuple of args passed to function , docstring}
    {"add", py_add, METH_VARARGS, "Add two numbers"}, // ex: calculator.add(1, 2) 
    {"subtract", py_subtract, METH_VARARGS, "Subtract two numbers"},
    {"multiply", py_multiply, METH_VARARGS, "Multiply two numbers"},
    {"divide", py_divide, METH_VARARGS, "Divide two numbers"},
    {NULL, NULL, 0, NULL} /* Sentinel */
};

// module definition
static struct PyModuleDef calculatormodule = {
    PyModuleDef_HEAD_INIT,
    "calculator", // name of module in python
    "calculator module implemented in C", // docstring
    -1,
    CalculatorMethods // link to method table
};

PyMODINIT_FUNC PyInit_calculator(void) {
    return PyModule_Create(&calculatormodule);
}
