from setuptools import setup, Extension

calculator_ext = Extension(
    'calculator.calculator',  # Changed from calculator._calculator
    sources=['src/c/calculator_module.c', 'src/c/calculator.c'],
    include_dirs=['src/c/']
)

setup(
    name='calculator',
    version='1.0',
    description='Calculator module written in C',
    packages=['calculator'],
    package_dir={'calculator': 'src/python'},
    ext_modules=[calculator_ext],
    entry_points={
        'console_scripts': [
            'calculator=calculator.cli_calculator:main',
        ],
    },
)