from setuptools import setup, Extension

calculator_module = Extension(
    'calculator',  
    sources=[
        'src\c\calculator_module.c',
        'src\c\calculator.c'],
    include_dirs=['calculator']
)

setup(
    name='calculator',
    version='1.0',
    description='Calculator module written in C',
    ext_modules=[calculator_module],
)
