#! /usr/bin/python2
import cookielib
import urllib2
from bs4 import BeautifulSoup

class UrlDownloader(urllib2.OpenerDirector):
    def __init__(self, *args, **kargs):
        urllib2.OpenerDirector.__init__(self, *args, **kargs)
        #agregando soporte basico
        self.add_handler(urllib2.ProxyHandler())
        self.add_handler(urllib2.UnknownHandler())
        self.add_handler(urllib2.HTTPHandler())
        self.add_handler(urllib2.HTTPDefaultErrorHandler())
        self.add_handler(urllib2.HTTPRedirectHandler())
        self.add_handler(urllib2.FTPHandler())
        self.add_handler(urllib2.FileHandler())
        self.add_handler(urllib2.HTTPErrorProcessor())

        #Agregar soporte para cookies. (en este momento no es necesario,
        #pero uno nunca sabe si se puede llegar a nececitar)
        self.cj = cookielib.CookieJar()
        self.add_handler(urllib2.HTTPCookieProcessor(self.cj))

    def downloadPage(self, link, *args, **kargs):
        '''Funcion para obtener el html de una pagina'''
        data = ''
        try:
            fh = self.open(link, *args, **kargs)
            data = fh.read()
            fh.close()
        except:
            pass
        return data


class LaCuerda:
    BASE_LINK='http://acordes.lacuerda.net'
    ARTISTAS_LETRAS =  [chr(i) for i in xrange(ord('a'), ord('z')+1)] + ['_num', '\xc3\xb1'] #enie

    def __init__(self):
        self.downloader = UrlDownloader()

    def getAllArtistas(self):
        artistas = []
        for letra in self.ARTISTAS_LETRAS:
            artistas += self.getArtistas(letra)

        return artistas

    def getArtistas(self, letra):
        pag = "%s/tabs/%s/index%%s.html" % (self.BASE_LINK, letra)
        #Solucion muy cabeza, iteramos todas las paginas hasta que una venga sin nada
        i = 0
        artistas = []
        while True:
            html = self.downloader.downloadPage(pag %  (i * 100))
            if html.strip() == '':
                return artistas
            artistas += self.__parseArtistas(html)
            i +=1

    def getCanciones(self, artista):
        '''Se le pasa un diccionario artista, como los que devuele getArtistas'''
        return self.__parseCancionesPag(artista['txt'], self.__getCancionesPag(artista['txt']))

    def getLetra(self, cancion):
        ''' Cancion tiene que ser un diccionario como devuelve el getAutor '''
        pag = self.downloader.downloadPage(cancion['href'])
        if cancion['tipo'] == 'R': #Son acordes
            return self.__parseLetraR(cancion, pag)
        else:
            pass #TBD

    def getSoloLetra(self, cancion):
        ''' Cancion tiene que ser un diccionario como devuelve el getAutor '''
        pag = self.downloader.downloadPage(cancion['href'])
        if cancion['tipo'] == 'R': #Son acordes
            return self.__parseSoloLetraR(cancion, pag)
        else:
            pass #TBD

    def __parseArtistas(self, html):
        As = BeautifulSoup(html).find(id='i_main').find_all('a')
        artistas = []
        for A in As:
            href = A.get('href')
            #Queremos el segundo qe es el nombre del artista
            astrings = A.strings
            astrings.next()
            artistas.append({
                'nombre':astrings.next(),
                'href': "%s/%s" % (self.BASE_LINK, href),
                'txt': href
            });
        return artistas

    def __getCancionesPag(self, autor):
        return self.downloader.downloadPage("%s/%s" % (self.BASE_LINK, autor))

    def __parseCancionesPag(self, autor, html):
        soup = BeautifulSoup(html)
        main = soup.find(id='b_main').find_all('li')
        canciones = []
        for li in main:
            a = li.a
            #Las tabs estan ordernadas por calidad, pero no tengo relacion entre link y tab, el id me la da.
            #si el id termina en 4213, significa qe el primer link es el 4, el segundo el 2, y asi sucecivamente
            order = li.get('id').split('-')
            tipos = []
            href = a.get('href')
            titulo = a.stripped_strings.next()
            for indx in range(0, len(order[1])):
                tipos.append({
                    'titulo': titulo,
                    'txt': href,
                    'calidad': indx, #Orden en el qe estan en la pag, menor mejor calidad
                    'tipo': order[1][indx],
                    'href': "%s/%s/%s.shtml" % (self.BASE_LINK, autor,  href if (int(order[2][indx]) == 1) else "%s-%s" % (href, order[2][indx]))
                })

            canciones.append({
                'titulo': titulo,
                'href': href,
                'tipos': tipos
            })

        return canciones

    def __parseSoloLetraR(self, cancion, html):
        '''Parsea una pagina de una letra del tipo R, devuelve una lista con todos los acordes'''
        soup = BeautifulSoup(html)
        main = soup.find(id='t_body').pre
        #FIXME: muy cabeza, creo que se podria reemplazar con .pritify (o algo asi)
        txt = repr(main).split('\n')
        acordes = []
        #FIXME: Se podria ir intercalando acordes con letra, aca solo estamos guardando los acordes
        for i in range(0, len(txt)):
            pText = BeautifulSoup(txt[i])
            #Escapamos las lineas que no tienen acordes (los acordes estan siempre en un tag a)
            if pText.a:
                continue
            data = []
            next = False
            for linea in pText.stripped_strings:
                if linea.strip() == '':
                    continue
                acordes.append(linea)

        return acordes
    def __parseLetraR(self, cancion, html):
        '''Parsea una pagina de una letra del tipo R, devuelve una lista con todos los acordes'''
        soup = BeautifulSoup(html)
        main = soup.find(id='t_body').pre
        #FIXME: muy cabeza, creo que se podria reemplazar con .pritify (o algo asi)
        txt = repr(main).split('\n')
        acordes = []
        #FIXME: Se podria ir intercalando acordes con letra, aca solo estamos guardando los acordes
        for i in range(0, len(txt)):
            pText = BeautifulSoup(txt[i])
            #Escapamos las lineas que no tienen acordes (los acordes estan siempre en un tag a)
            if not pText.a:
                continue
            data = []
            next = False
            for linea in pText.stripped_strings:
                if linea.strip() == '':
                    continue
                if next:
                    data[len(data)-1] = "%s%s%s" % (data[len(data)-1], next, linea)
                    next = False
                    continue
                if linea.strip() == '-' or linea.strip() == '/': #Los uno suponiendo que se refiere al bajo
                    next = linea
                    continue
                data.append(linea)
            acordes.append(data)

        return acordes

if __name__ == '__main__':
    lc = LaCuerda()
    artistas = lc.getArtistas('a')
    #print artistas
    canciones = lc.getCanciones(artistas[0])
    #print autor[0]['tipos'][0]
    acordes = lc.getLetra(canciones[0]['tipos'][0])

    print "Artista: %s" % artistas[0]['nombre']
    print "Cancion: %s"% canciones[0]['tipos'][0]['titulo']
    for linea in acordes:
        acord = ''
        for a in linea:
            acord = "%s %s" % (acord, a)
        print "\t %s" % acord
    print "Obteniendo todos los artistas, puede tardar mucho"
    tartistas = lc.getAllArtistas()
    print "Hay %s artistas en total" % len(tartistas)
    yn = raw_input('Desea mostrarlos? y/n')
    if yn.strip() == 'y':
        for i in range(0, len(tartistas)):
            print i+1, tartistas[i]




