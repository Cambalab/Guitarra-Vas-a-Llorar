#!/usr/bin/env python

arc = file('los_dinosaurios.gp3').read()

arc = arc[32:]

def bytes_a_int(bytearr):
	bytearr = list(bytearr)
	bytearr.reverse()
	x=0
	for i in range(4):
		x += ord(bytearr[i]) * 2**i
	return x

pos = 0
for i in range(4): # Lo hacemos tres veces
	length = bytes_a_int(arc[pos : pos + 4])
	pos += 4
	print arc[pos:pos + length]
	pos += 6 + length

