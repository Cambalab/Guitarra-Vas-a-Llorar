#include <avr/pgmspace.h> // Write constants to Flash

//constants

const int SIPOdata = 9; //DS   pin 14
const int SIPOlatch = 10;//STCP pin 12
const int SIPOclk = 11;  //SHCP pin 11
const int SIPOclear = 12;//MR   pin 10



unsigned long tempLED[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 };


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
        shiftOut( SIPOdata, SIPOclk, MSBFIRST, (tempLED[y] >> 16) );
        shiftOut( SIPOdata, SIPOclk, MSBFIRST, (tempLED[y] >> 8) );
        shiftOut( SIPOdata, SIPOclk, LSBFIRST,  tempLED[y] & 0xFF);
        shiftOut( SIPOdata, SIPOclk, MSBFIRST, 1<<(y+1));
//      shiftOut( SIPOdata, SIPOclk, MSBFIRST, 2);
    digitalWrite( SIPOlatch, LOW);
    delay(1);
    digitalWrite( SIPOlatch, HIGH);
  }
}



void readSongNotes() {
    int i=0;
    unsigned long c1=0,c2=0,c3=0,c4=0,c5=0,c6=0,c7=0;
//    long start_time = millis();
    c1 = c2 = c3 = c4 = c5 = c6 = c7 = 0xFFFFFF;

    while(c1 != 0xFF) { 
        tempLED[0] = c1;
        tempLED[1] = c2;
        tempLED[2] = c3;
        tempLED[3] = c4;
        tempLED[4] = c5;
        tempLED[5] = c6;

        if(Serial.available()) {
            if( Serial.available() >= 19 ) {       // wait for 1byte header + 18 bytes 
                if(Serial.read() == 'N') {
                    c1  = long(Serial.read()) << 16;
//                    if(c1 == 32) break;
                    //c1 = 0x0000;
                    c1 |= long(Serial.read()) << 8;
                    c1 |= Serial.read();
                    
                    c2  = long(Serial.read()) << 16;
                    //c2 = 0x0000;
                    c2 |= long(Serial.read()) << 8;
                    c2 |= Serial.read();

                    c3  = long(Serial.read()) << 16;
                    //c3 = 0x0000;
                    c3 |= long(Serial.read()) << 8;
                    c3 |= Serial.read();

                    c4  = long(Serial.read()) << 16;
                    //c4 = 0x0000;
                    c4 |= long(Serial.read()) << 8;
                    c4 |= Serial.read();

                    c5  = long(Serial.read()) << 16;
                    //c5 = 0x0000;
                    c5 |= long(Serial.read()) << 8;
                    c5 |= Serial.read();

                    c6  = long(Serial.read()) << 16;
                    //c6 = 0x0000;
                    c6 |= long(Serial.read()) << 8;
                    c6 |= Serial.read();

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
//    digitalWrite( SIPOclear, LOW);
//    delay(1);
//    digitalWrite( SIPOclear, HIGH);

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

