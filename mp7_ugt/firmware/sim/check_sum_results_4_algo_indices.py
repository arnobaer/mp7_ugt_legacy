#!/bin/env python

path = "sim_results_gtl_fdl_wrapper_TestVector_L1Menu_Collisions2015_25nsStage1_v6_uGT_v2_TTbar"


def hex2bin(s):
  padding = len(s)*4
  decimal = int(s,16)
  binary = bin(decimal)[2:].zfill(padding)
  return binary


def compare(array):
  if len(array) != 2:
    raise RuntimeError
  hex_val = array[0].strip()
  hex_ref = array[1].strip()

  bin_val = ''.join(reversed(hex2bin(hex_val)))
  bin_ref = ''.join(reversed(hex2bin(hex_ref)))

  error = ""
  for ii in range(len(bin_val)):
    if bin_val[ii] != bin_ref[ii]:
      error += " bit %03d, " % ii

  if error:
    print " @ %s" % error


data = {}
key = ''
for line in file(path).readlines():
  if not line: continue
  tokens = line.split(':')
  if len(tokens) < 2: continue
  if ("bx-nr" in tokens[0]) and (tokens[1] not in data.keys()):
    key = tokens[1]
    data[key] = []
    continue
  data[key].append(tokens[1])

for key in sorted(data):
  print key.strip(),
  compare(data[key])

# eof
