#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import os

fn = sys.argv[1]
f = open(fn)

kill = False
newfiledata = "";

while 1:

	line = f.readline()
	if line == "":
		break
	if line.startswith("<<<<<<<"):
		pass
	elif line.startswith("======="):
		kill = True
	elif line.startswith(">>>>>>>"):
		kill = False
	elif not kill:
		newfiledata = newfiledata + line

f.close()
f = open(fn, "w")

f.write(newfiledata)
f.close()

