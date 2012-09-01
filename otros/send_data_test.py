import serial
import time


end_time = time.time() + 10 # time() is calculated in seconds
arduino = serial.Serial('/dev/ttyACM0', 9600)
time.sleep(3)

l = [0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x04, 0x00, 0x00]
d = "".join([chr(x) for x in l])
    
#while time.time() < end_time:
while True:
    input = raw_input(">> ")
    if input == 'exit':
        arduino.close()
        exit()
    else:
        arduino.write('N')
        time.sleep(1)
        for i in l:
            arduino.write(str(i))
            time.sleep(1)
