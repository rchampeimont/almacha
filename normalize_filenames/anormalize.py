#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain.
# anormalize: Almacha's NORMALIZE
# WARNING: Only tested under UNIX!

import os
import sys
import re

class AchaNormalizeException(Exception):
  r"""Raised when a problem occurs."""

_bad_chars_regex = re.compile(r'[^' + re.escape(""" !#$%&'()+,-.0123456789;=@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{}~""") + ']')

def renamefunc_da_ascii(filename):
  r"""Returns filename, but with "bad" characters replaced by '_'.
  By bad, we mean characters that satisfy at least one of these conditions:
  - outside displayable ASCII, ie. outside [0x20,0x7e]
  - forbidden in filenames in UNIX (ie. is not a slash)
  - forbidden in Windows filenames (ie. is not one of: \/:*?"<>|)
  """
  return _bad_chars_regex.sub('_', filename)

_bad_windows_chars_regex = re.compile(r'[' + re.escape("""\/:*?"<>|""") + ']')
  
def renamefunc_windows(filename):
  r"""Replace characters forbidden in Windows filsystems.
  Useful for UNIX to Windows tree copy."""
  return _bad_windows_chars_regex.sub('_', filename)


def _test1():
  print """ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"""
  print renamefunc_da_ascii(""" !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ""")
  print """[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"""
  print renamefunc_da_ascii("""[\]^_`abcdefghijklmnopqrstuvwxyz{|}~""")

def normalize_filename(filepath, renamefunc, simulate = False):
  r"""Renamed the file using the privided renaming function.
  The filepath should not end with a '/'."""
  (parentdir, filename) = os.path.split(filepath)
  newfilename = renamefunc(filename)
  if (newfilename != filename):
    newpath = os.path.join(parentdir, newfilename)
    print "%s -> %s" % (filepath, newpath)
    if os.path.lexists(newpath):
      sys.stderr.write("""Error: "%s" exists.\n""" % newpath)
      raise AchaNormalizeException
    if not simulate:
      os.rename(filepath, newpath)
  

def normalize_tree(root, renamefunc = renamefunc_da_ascii, simulate = False):
  r"""
  This function renames all directories and filenames in the given
  directory, using the provided renaming function (renamefunc).
  If the renamefunc returns the same filename it was given,
  nothing is done to the file.

  The default renamefunc is will forever be renamefunc_da_ascii.

  You can provide your own renaming function, ie the function
  which, given an original filename (as normal string), returns
  the new filename (as normal string too). You can pass this function
  using the renamefunc optional named argument.

  If simulate is set to True, then the program only displays
  the renames that would occur, but does not do them.
  
  INFORMATION WHICH IS TRUE WHATEVER RENAMING FUNCTION IS USED
  Note that the given root will not be renamed, only its children will.
  Symlinks are not followed, but are still renamed.
  The given root directory does not need to end with a '/'.
  This program will not delete files, if renamed names clash,
  this program will rename the first and raise an exception instead
  of renaming the second."""

  def process_directory(dir):
    ls = os.listdir(dir)
    for f in ls:
      filepath = os.path.join(dir, f)
      normalize_filename(filepath, renamefunc, simulate = simulate)
    # List directory contents again (to get new filenames)
    ls = os.listdir(dir)
    for f in ls:
      filepath = os.path.join(dir, f)
      if not os.path.islink(filepath) and os.path.isdir(filepath):
	# We process recursively the directory if and only
	# if it is not a link (we don't want to recurse
	# in links to directories)
	process_directory(filepath)

  process_directory(root)


