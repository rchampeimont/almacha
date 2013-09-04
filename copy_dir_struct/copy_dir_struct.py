#!/usr/bin/python
# By Raphael Champeimont, public domain

# This programs copies a directory structure,
# ie is a sort of cp -R without the files.
# Its prurpose is to copy a directory tree to another
# directory (which is mkdired if does not exist).
# The destination directory may be under the source
# dir if and only if it is a direct subdir.

import os;
import sys;



def usage():
  print 'Usage: %s source_dir dest_dir' % sys.argv[0]
  sys.exit(0)



def dodir(sdir, path, ddir):
  # List dir contents, we use "list()" because we want
  # the list of subdirs *before* the new dir is created.
  # This way the program can be used to copy a directory
  # in a direct subdirectory of itself.
  subdirs = list(os.listdir(sdir + path))

  # make dir copy
  print 'mkdir "' + ddir + path + '"'
  try:
    os.makedirs(ddir + path)
  except OSError, e:
    print 'Warning: ' + e.strerror

  # go in subdirs
  for dir in subdirs:
    if not os.path.isdir(sdir + path + '/' + dir):
      continue;
    dodir(sdir, path + '/' + dir, ddir)



def main():
  if len(sys.argv) < 3:
    usage()

  sdir = sys.argv[1]
  ddir = sys.argv[2]

  print "Source: %s\nDestination: %s" % (sdir, ddir)

  if not os.path.isdir(sdir):
    print sdir + " is not a directory"
    sys.exit(1);

  dodir(sdir, '', ddir)



main()
