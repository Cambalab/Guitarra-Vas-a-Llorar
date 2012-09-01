# -*- coding: utf-8 -*-

from mingus.core import chords

cuerdas_notacion = ('E','A','D','G','B','E')
cuerdas = ('6','5','4','3','2','1')
trastes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
acordes = ['C', 'E' , 'Cm']

def triad(acorde):
	if len(acorde) == 1:
		# Mayor
		return chords.major_triad(acorde)
	else:
		return chords.minor_triad(acorde[0])

def cuerda_a_trastes(cuerda):
	i = trastes.index(cuerda)
	mul =  trastes*5
	return mul[i:(i+5)]

cuerda_traste = {}
#for (cuerda,notacion) in (cuerdas,cuerdas_notacion):
i = 0
while i < len(cuerdas):
	cuerda = cuerdas[i]
	notacion = cuerdas_notacion[i]
	cuerda_traste[cuerda] = cuerda_a_trastes(notacion)
	i += 1


def acorde_a_traste(acorde):
	triada = triad(acorde)
	tonica = acorde

	#Buscamos la tónica
	encontrado = False
	importantes = []
	tocar = {}

	for cuerda in cuerdas:
		traste = cuerda_traste[cuerda]
		if not encontrado:
			try:
				i = traste.index(tonica)
			except ValueError:
				#tocar[cuerda] = None
				pass
			else:
				encontrado = True
				importantes.append(traste[i:])
				tocar[cuerda] = i
		else:
			importantes.append(cuerda_traste[cuerda])
			for nota in triada:
				if nota in traste and (not tocar.has_key(cuerda)):
					tocar[cuerda] = traste.index(nota)
				"""elif not tocar.has_key(cuerda):
					tocar[cuerda] = None"""
	return tocar

for c in cuerdas_notacion:
	print c,cuerda_a_trastes(c)

