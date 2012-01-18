#include <avr/pgmspace.h> // Write constants to Flash

//constants

const int SIPOdata = 10; //DS   pin 14
const int SIPOlatch = 12;//STCP pin 12
const int SIPOclk = 11;  //SHCP pin 11
const int SIPOclear = 9;//MR   pin 10



unsigned int tempLED[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};


void setup()
{
    pinMode(SIPOclk, OUTPUT);
    pinMode(SIPOdata , OUTPUT);
    pinMode(SIPOlatch, OUTPUT);
    pinMode(SIPOclear, OUTPUT);
    digitalWrite( SIPOclear, HIGH);
    Serial.begin( 9600);
    for(int idx=0; idx<6; idx++)
        tempLED[idx] = 0x5555;
}


void LEDMatrix(){
//  for( int y = 5; y >= 0; y--){ 
  for( int y = 0; y < 6; y++){
    //send to LED Matrix
        digitalWrite( SIPOclk, LOW);
//FIXME: leer otro byte desde readSongNotes() y mandarlo aca:
       shiftOut( SIPOdata, SIPOclk, MSBFIRST, 0);
        shiftOut( SIPOdata, SIPOclk, MSBFIRST, highByte( tempLED[ y]));
        shiftOut( SIPOdata, SIPOclk, MSBFIRST,  lowByte( tempLED[ y]));
        shiftOut( SIPOdata, SIPOclk, MSBFIRST, 1<<(y+1));
//      shiftOut( SIPOdata, SIPOclk, MSBFIRST, 2);
    digitalWrite( SIPOlatch, LOW);
    delay(1);
    digitalWrite( SIPOlatch, HIGH);
  }
}



void readSongNotes() {
    int i=0;
    unsigned int c1=0,c2=0,c3=0,c4=0,c5=0,c6=0,c7=0;
    long start_time = millis();
    c1 = c2 = c3 = c4 = c5 = c6 = 0x5555;

    while(c1 != 32) { 
        tempLED[0] = c1;
        tempLED[1] = c2;
        tempLED[2] = c3;
        tempLED[3] = c4;
        tempLED[4] = c5;
        tempLED[5] = c6;

        if(Serial.available()) {
            if( Serial.available() >= 13 ) {       // wait for 1byte header + 12 bytes 
                if(Serial.read() == 'N') {
                    c1 = Serial.read();
                    if(c1 == 32) break;
                    c1 = word(c1,Serial.read());
                    c2 = Serial.read();
                    c2 = word(c2,Serial.read());
                    c3 = Serial.read();
                    c3 = word(c3,Serial.read());
                    c4 = Serial.read();
                    c4 = word(c4,Serial.read());
                    c5 = Serial.read();
                    c5 = word(c5,Serial.read());
                    c6 = Serial.read();
                    c6 = word(c6,Serial.read());
                    Serial.flush();
                } else {
                    Serial.println("ERROR");
                }
            }
        } else {
/*            if( (millis() - start_time) > 10000 ) 
                break;
*/
        }
        LEDMatrix();
    }
}



void loop(){
    digitalWrite( SIPOclear, LOW);
    delay(1);
    digitalWrite( SIPOclear, HIGH);
//    digitalWrite( SIPOclk, LOW);
//    shiftOut( SIPOdata, SIPOclk, MSBFIRST, 0x55);
//    digitalWrite( SIPOlatch, LOW);
//    delay(1);    
//    digitalWrite( SIPOlatch, HIGH);
//    digitalWrite( SIPOclk, LOW);
//    shiftOut( SIPOdata, SIPOclk, MSBFIRST, 2);
//    digitalWrite( SIPOlatch, LOW);
//    delay(1);    
//    digitalWrite( SIPOlatch, HIGH);
//LEDMatrix();
    readSongNotes();
}

