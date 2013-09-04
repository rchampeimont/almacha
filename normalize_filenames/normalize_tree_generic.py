#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain.
# See anormalize.py for documentation.
# WARNING: Only tested under UNIX!

import anormalize
import sys

if len(sys.argv) < 2:
  print "An argument should be given: the root directory."
  sys.exit(1)

root = sys.argv[1]

anormalize.normalize_tree(root = root)
