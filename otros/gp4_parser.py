# -*- coding: utf-8 -*-
# Parser de archivos GP4 (Versión 4.6 de Guitar Pro)
# Autor: Matías Lang <shareman1204@gmail.com>
# Licencia: GPL

import sys
archivo=''

def readbyte():
	global archivo
	n = ord(archivo[0])
	del(archivo[0])
	return n

def readstr():
	global archivo
	length = ord(archivo[0])
	del(archivo[0])
	ret = archivo[:length]
	del(archivo[:length])
	return ''.join(ret)

def readint():
	global archivo
	ret = 0
	n = archivo[:4]
	archivo = archivo[4:]
	for i in range(len(n)):
		ret += ord(n[i]) * 256**i
	return ret

def calcular_meta():
	global archivo
	archivo = archivo[4:] #Ignoramos los primeros 4 bytes
	length = ord(archivo[0])
	archivo = archivo[1:]
	ret = archivo[:length]
	archivo = archivo[length:]
	return ''.join(ret)

def main():
	global archivo
	if(len(sys.argv) != 2):
		print 'Uso: %s <archivo.gp4>' % sys.argv[0]
		exit()

	#Cargamos el archivo
	try:
		archivo = open(sys.argv[1]).read()
		archivo = list(archivo)
	except IOError:
		print 'No se puede leer el archivo %s' % sys.argv[1]
		exit()
	
	# Carga headers

	#Versión
	version_length = ord(archivo[0])
	version = archivo[1 : version_length+1]
	version = ''.join(version)
	archivo = archivo[31:] #Descartamos información de la versión
	if version != 'FICHIER GUITAR PRO v4.06':
		print 'El formato de archivo no coincide con la versión 4.06 de Guitar Pro'
		exit()

	#Tamaño de la información que sigue
	"""print 'Título', calcular_meta()
	print archivo[:10].encode('hex')
	print 'Subtítulo', calcular_meta()
	print 'Intérprete', calcular_meta()
	print 'Álbum', calcular_meta()
	print 'Autor', calcular_meta()
	print 'Copyright', calcular_meta()
	print 'Autor de tablatura', calcular_meta()
	print 'Acerca de la tablatura', calcular_meta()"""
	titulo, subtitulo, interprete, album, autor, copyright, autor_tab, acerca = calcular_meta(), calcular_meta(), calcular_meta(), calcular_meta(), calcular_meta(), calcular_meta(), calcular_meta(), calcular_meta() 
	print titulo, subtitulo, interprete, album, autor, copyright, autor_tab, acerca

	n_notices =  readint()
	instances = readint()
	tripletfeel = readbyte()
	print n_notices, instances, tripletfeel

	#Lyrics
	track = readint()
	lyrics = [readstr() for i in range(5)]
	print track, lyrics

	#Otros datos
	tempo, key, octave = readint(), readbyte(), readbyte()
	print tempo, key, octave

	#Midichannels
	ports = []
	for i in range(4):
		# Puertos
		ports.append([])
		for j in range(16):
			# Canales
			channel = {} 
			channel['instrument'] = readint()
			channel['volume'] = readbyte()
			channel['balance'] = readbyte()
			channel['chorus'] = readbyte()
			channel['reverb'] = readbyte()
			channel['phaser'] = readbyte()
			channel['tremolo'] = readbyte()
			channel['blank1'] = readbyte()
			channel['blank2'] = readbyte()
			ports[i].append(channel)
	measures, tracks = readint(), readint()
	print ports, measures, tracks

if __name__ == '__main__':
	main()


