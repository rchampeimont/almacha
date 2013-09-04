#!/usr/bin/python
# -*- coding: utf-8 -*-

# By Raphael CHAMPEIMONT, in the public domain
# anormalize: Almacha's NORMALIZE

import anormalize
import adevaccents

class AchaNormalizeException(Exception):
  r"""Raised when a problem occurs."""

def normalize_tree_french(root, simulate = False):
  r"""
  This function is just a call to anormalize.normalize_tree
  using the adevaccents.normaliser_nom_de_fichier_utf8 function.
  As a consequence of this,
  this function renames all directories and filenames in the given
  directory, so that they only contain displayable and allowed ASCII
  characters. The resulting filenames will only contain bytes that
  satisfy all these conditions:
  - displayable ASCII (ie. bytes in range 0x20 - 0x7e)
  - allowed in UNIX (ie. is not a '/')
  - allowed in Windows (ie. is not one of: \/:*?"<>|)
  This program will try to replace French accents by the
  unaccented letters, as long as they are written in UTF-8
  in the original filename.

  For documentation which is general to the tree processing
  (ie. which is independant from the renaming function used),
  see the anormalize.normalize_tree source.
  """
  anormalize.normalize_tree(root = root,
      renamefunc = adevaccents.normaliser_nom_de_fichier_utf8,
      simulate = simulate)


