from setuptools import setup, Extension

calculator_module = Extension(
    'calculator',  # this is the name you'll import in Python
    sources=[
        'C_calclulator/calculator_module.c',
        'C_calclulator/calculator.c'],
    include_dirs=['calculator']
)

setup(
    name='calculator',
    version='1.0',
    description='Calculator module written in C',
    ext_modules=[calculator_module],
)
