#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain.

# This script renames all files in given directory and all subdirectories
# when they contain characters forbidden in Windows filesystems:
# \/:*?"<>|
# The typical usage of this script is to prepare a copy of a file tree from
# a Linux filesystem (which allows this characters) to a Windows one.
# This one is just a simulation, ie. only displays what it would rename
# if it were not a simulation.

import anormalize
import sys

if len(sys.argv) < 2:
  print "An argument should be given: the root directory."
  sys.exit(1)

root = sys.argv[1]

print "Script start"
anormalize.normalize_tree(root = root, renamefunc = anormalize.renamefunc_windows, simulate = True)
print "Script end"
