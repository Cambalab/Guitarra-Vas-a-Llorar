#!/usr/bin/python

import sys


f = open(sys.argv[1])

idxt = 0
idxc = 1

out = []

for l in f:
    if 'TrasteX' in l:
       out.append(l.replace('TrasteX', 'Traste%i'%idxt))
       idxt += 1
       continue
    if 'CuerdaX' in l:
       out.append(l.replace('CuerdaX', 'Cuerda%i'%idxc))
       idxc += 1
       continue
    out.append(l) 

f.close()
f = open('salida.sch', 'wb')
f.writelines(out)
f.close()
