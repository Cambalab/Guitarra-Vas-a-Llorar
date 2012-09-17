import serial
import time
import struct

def packIntegerAsULong(value):
    """Packs a python 4 byte unsigned integer to an arduino unsigned long"""
    return struct.pack('I', value)    #should check bounds

segundos = 10
end_time = time.time() + segundos # time() is calculated in seconds
arduino = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)
time.sleep(3)

#19bytes por vez (header + 18) bytes
todo = [ '\xff\xff\xff', '\xff\xff\xff', '\xff\xff\xff', '\xff\xff\xff', '\xff\xff\xff', '\xff\xff\xff', ]
nada = [ '\x00\x00\x00',  '\x00\x00\x00',  '\x00\x00\x00',  '\x00\x00\x00',  '\x00\x00\x00',  '\x00\x00\x00',  ]
encabezado = 'N'

while time.time() < end_time:
    arduino.write(encabezado)
    for cuerda in todo:
        arduino.write(cuerda)
    arduino.write(encabezado)
    for cuerda in nada:
        arduino.write(cuerda)

arduino.close()
exit()

