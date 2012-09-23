# -*- coding: utf-8 -*-
# Parser de archivos GP4 (Versión 4.6 de Guitar Pro)
# Autor: Matías Lang <shareman1204@gmail.com>
# Licencia: GPL

import sys

def bytes_to_int(n):
	ret = 0
	n = list(n)
	for i in range(len(n)):
		ret += ord(n[i]) * 16**i
	return ret

def calcular_meta():
	archivo = globals()['archivo']
	archivo = archivo[4:] #Ignoramos los primeros 4 bytes
	length = ord(archivo[0])
	archivo = archivo[1:]
	ret = archivo[:length]
	globals()['archivo'] = archivo[:length]
	return ret

def main():
	if(len(sys.argv) != 2):
		print 'Uso: %s <archivo.gp4>' % sys.argv[0]
		exit()

	#Cargamos el archivo
	try:
		archivo = open(sys.argv[1]).read()
	except IOError:
		print 'No se puede leer el archivo %s' % sys.argv[1]
		exit()
	
	# Carga headers

	#Versión
	version_length = ord(archivo[0])
	version = archivo[1 : version_length+1]
	archivo = archivo[31:] #Descartamos información de la versión
	if version != 'FICHIER GUITAR PRO v4.06':
		print 'El formato de archivo no coincide con la versión 4.06 de Guitar Pro'
		exit()

	globals()['archivo'] = archivo #La hacemos global

	#Tamaño de la información que sigue
	print calcular_meta()
	archivo = globals()['archivo']
	print archivo[:10].encode('hex')
	print calcular_meta()

if __name__ == '__main__':
	main()


