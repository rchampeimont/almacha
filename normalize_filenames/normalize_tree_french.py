#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain.
# See anormalizefrench for documentation.
# WARNING: Only tested under UNIX!

import anormalizefrench
import sys

if len(sys.argv) < 2:
  print "An argument should be given: the root directory."
  sys.exit(1)

root = sys.argv[1]

anormalizefrench.normalize_tree_french(root)
