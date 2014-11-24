#!/usr/bin/python

import re

BETACODE_FILE = 'origs-betacode.txt'
OUT_FILE = 'origs-betacode-no-accents.txt'
PATTERN = '[\/\\\=\(\)]'

r = re.compile(PATTERN)

out = open(OUT_FILE, 'w')
f = open(BETACODE_FILE, 'r')

for line in f.readlines():
  if r.search(line) is None:
    out.write(line)

f.close()
out.close()