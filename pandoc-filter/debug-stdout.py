#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
output = sys.stdout
print("\n\item sys.version:", sys.version, file=output)
print("\n\item sys.platform:", sys.platform, file=output)
print("\n\item sys.prefix:", sys.prefix, file=output)
print("\n\item sys.path:\n\\begin{itemize}\n", file=output)
for p in sys.path:
    print("\\item ", p, "\n", file=output)
print("\\end{itemize}\n", file=output)

# print("\nsys.path\_importer\_cache:", sys.path_importer_cache, file=output)
# import panflute as pf
# print("\nsys.path nach import panflute:", sys.path, file=output)

