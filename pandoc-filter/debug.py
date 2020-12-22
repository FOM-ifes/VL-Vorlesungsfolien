#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import pip

print("\nsys.version:", sys.version, file=sys.stderr)
print("\nsys.platform:", sys.platform, file=sys.stderr)
print("\nsys.prefix:", sys.prefix, file=sys.stderr)
print("\nsys.path:", sys.path, file=sys.stderr)
#print("\nsys.path_importer_cache:", sys.path_importer_cache, file=sys.stderr)
print("\npip.__version__:", pip.__version__, file=sys.stderr)
print("\npip.__path__:", pip.__path__, file=sys.stderr)

import panflute as pf
print("\nsys.path nach import panflute:", sys.path, file=sys.stderr)

