#! /usr/bin/python
import os
import sys
import os.path
from db_musica import LaCuerda

if __name__ == '__main__':
    if not sys.argv > 2:
        print "pasame un artista logi"
        exit()

    print "Buscando artista"
    artista = sys.argv[1].strip().lower()
    lc = LaCuerda()
    artistas = lc.getArtistas(artista[0])
    find = []
    for key in artistas:
        if key['nombre'].strip().lower().find(artista) > -1:
            find.append(key)

    artistaDict = {}
    if len(find) == 0:
        print "No se encontro artista"
        exit()
    elif len(find) > 1:
        for key in xrange(0, len(find)):
            print i, find[i]
        num = int(raw_input("cual elegis?"))
        artistaDict = find[num]
    else:
        artistaDict = find[0]

    folder = artistaDict['nombre'].strip()
    print "Artista Encontrado %s " % (folder)

    if not os.path.isdir(folder):
        os.mkdir(folder)
    print "Obteniendo Canciones..."
    canciones = lc.getCanciones(artistaDict)
    for cancion in canciones:
        with open("%s/%s.txt" % (folder, cancion['titulo']), 'w') as archivo:
            letra = lc.getSoloLetra(cancion['tipos'][0])
            if letra:
                for linea in letra:
                    archivo.write("%s\n" % linea.encode('ascii', 'ignore'));
