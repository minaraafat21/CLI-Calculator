.. CLI Calculator documentation master file, created by
   sphinx-quickstart on Fri Jun 13 02:04:07 2025.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
.. CLI Calculator documentation

Welcome to CLI Calculator's documentation!
==========================================

.. toctree::
   :maxdepth: 2

   usage
   calculator

Usage
=====

Command Line:
   .. code-block:: bash

      calculator add 2 3
      # Result: 5.0

Python API:
   .. code-block:: python

      from calculator import add
      result = add(2, 3)
      print(result)  # 5.0

