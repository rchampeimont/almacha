#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys

def compute_hash_of_file(fn):
	f = open(fn, mode="rb")
	S = 0
	while 1:
		c = f.read(1)
		if c == "":
			break
		S = (S + ord(c)) % 1000
	print "%d\t%s" % (S, fn)

def main():
	fns = sys.argv[1:]
	for fn in fns:
		compute_hash_of_file(fn)

main()

