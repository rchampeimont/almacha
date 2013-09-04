#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain.
# See anormalizefrench for documentation.
# WARNING: Only tested under UNIX!

import anormalize
import sys
import re

_myregex1 = re.compile('^ +')
_myregex2 = re.compile(' +$')

def trimspaces(s):
  s = _myregex1.sub('', s)
  s = _myregex2.sub('', s)
  return s

if len(sys.argv) < 2:
  print "An argument should be given: the root directory."
  sys.exit(1)

root = sys.argv[1]

anormalize.normalize_tree(root, renamefunc = trimspaces, simulate = False)
