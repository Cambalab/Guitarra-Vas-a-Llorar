/*
Copyright 2011

GuitArduino
Date: 4/12/2011
Names: Andrew Garza  (agarza6)
       Mamlook Jendo (mjendo2)
Adviser: Robert Becker

Fecha: 29/06/2011
Nuevas modificaciones para Prueba y compilacion 
Adrian Pardini y Jose Luis Di Biase (elarteylatecnologia.com.ar)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/


//#include <avr/pgmspace.h> // Write constants to Flash
#include <ShiftLCD.h>

//#defines
//---------CHORDS
//MAJOR
#define c_major1 { 0x0000, 0x0001, 0x0000, 0x0002, 0x0004, 0x0000}
#define c_major2 { 0x0004, 0x0014, 0x0014, 0x0014, 0x0004, 0x0000}
#define db_major1 { 0x0008, 0x0028, 0x0028, 0x0028, 0x0008, 0x0000}
#define db_major2 { 0x0100, 0x0100, 0x0300, 0x0500, 0x0500, 0x0100} 
#define d_major1  { 0x0002, 0x0004, 0x0002, 0x0000, 0x0000, 0x0000}
#define d_major2  { 0x0010, 0x0050, 0x0050, 0x0050, 0x0010, 0x0000}
#define eb_major1  { 0x0020, 0x00A0, 0x00A0, 0x00A0, 0x0020, 0x0000}
#define eb_major2  { 0x0400, 0x0400, 0x0C00, 0x1400, 0x1400, 0x0400}
#define e_major1  { 0x0000, 0x0000, 0x0001, 0x0002, 0x0002, 0x0000}
#define e_major2  { 0x0040, 0x0140, 0x0140, 0x0140, 0x0040, 0x0000}
#define f_major1  { 0x0001, 0x0001, 0x0003, 0x0005, 0x0005, 0x0001}
#define f_major2  { 0x0080, 0x0280, 0x0280, 0x0280, 0x0080, 0x0000}
#define gb_major1  { 0x0002, 0x0002, 0x0006, 0x000A, 0x000A, 0x0002}
#define gb_major2  { 0x0100, 0x0500, 0x0500, 0x0500, 0x0100, 0x0000}
#define g_major1  { 0x0004, 0x0000, 0x0000, 0x0000, 0x0002, 0x0004}
#define g_major2  { 0x0004, 0x0004, 0x000C, 0x0014, 0x0014, 0x0004}
#define ab_major1  { 0x0008, 0x0008, 0x0018, 0x0028, 0x0028, 0x0008}
#define ab_major2  { 0x0400, 0x1400, 0x1400, 0x1400, 0x0400, 0x0000}
#define a_major1  { 0x0000, 0x0002, 0x0002, 0x0002, 0x0000, 0x0000}
#define a_major2  { 0x0010, 0x0010, 0x0030, 0x0050, 0x0050, 0x0010}
#define bb_major1  { 0x0001, 0x0005, 0x0005, 0x0005, 0x0001, 0x0000}
#define bb_major2  { 0x0020, 0x0020, 0x0060, 0x00A0, 0x00A0, 0x0020}
#define b_major1  { 0x0002, 0x000A, 0x000A, 0x000A, 0x0002, 0x0000}
#define b_major2  { 0x0040, 0x0040, 0x00C0, 0x0140, 0x0140, 0x0040}

//MINOR
#define c_minor1 { 0x0004, 0x000C, 0x0014, 0x0014, 0x0004, 0x0000}
#define c_minor2 { 0x0080, 0x0080, 0x0080, 0x0280, 0x0280, 0x0080}
#define db_minor1 { 0x0008, 0x0018, 0x0028, 0x0028, 0x0008, 0x0000}
#define db_minor2 { 0x0100, 0x0100, 0x0100, 0x0500, 0x0500, 0x0100}
#define d_minor1  { 0x0001, 0x0004, 0x0002, 0x0000, 0x0000, 0x0000}
#define d_minor2  { 0x0010, 0x0030, 0x0050, 0x0050, 0x0010, 0x0010}
#define eb_minor1  { 0x0020, 0x0060, 0x00A0, 0x00A0, 0x0020, 0x0000}
#define eb_minor2  { 0x0002, 0x0008, 0x0004, 0x0001, 0x0000, 0x0000}
#define e_minor1  { 0x0000, 0x0000, 0x0000, 0x0002, 0x0002, 0x0000}
#define e_minor2  { 0x0040, 0x00C0, 0x0140, 0x0140, 0x0040, 0x0000}
#define f_minor1  { 0x0001, 0x0001, 0x0000, 0x0005, 0x0005, 0x0001}
#define f_minor2  { 0x0080, 0x0180, 0x0280, 0x0280, 0x0080, 0x0000}
#define gb_minor1  { 0x0002, 0x0002, 0x0002, 0x000A, 0x000A, 0x0002}
#define gb_minor2  { 0x0100, 0x0300, 0x0500, 0x0500, 0x0100, 0x0000}
#define g_minor1  { 0x0004, 0x0004, 0x0004, 0x0014, 0x0014, 0x0004}
#define g_minor2  { 0x0200, 0x0600, 0x0A00, 0x0A00, 0x0200, 0x0200}
#define ab_minor1  { 0x0008, 0x0008, 0x0018, 0x0028, 0x0028, 0x0008}
#define ab_minor2  { 0x0400, 0x0C00, 0x1400, 0x1400, 0x0400, 0x0000}
#define a_minor1  { 0x0000, 0x0001, 0x0002, 0x0002, 0x0000, 0x0000}
#define a_minor2  { 0x0010, 0x0010, 0x0010, 0x0050, 0x0050, 0x0010}
#define bb_minor1  { 0x0001, 0x0003, 0x0005, 0x0005, 0x0001, 0x0000}
#define bb_minor2  { 0x0020, 0x0020, 0x0020, 0x00A0, 0x00A0, 0x0020}
#define b_minor1  { 0x0002, 0x0006, 0x000A, 0x000A, 0x0002, 0x0000}
#define b_minor2  { 0x0040, 0x0040, 0x0040, 0x0140, 0x0140, 0x0040}

//---------SCALES (all scales have C as their root)
#define major     { 0x5AD5, 0x5AB5, 0xAB5A, 0x6B56, 0x6AD6, 0x5AD5}
#define harmonic_minor { 0xD6CD, 0xD9AD, 0x9AD9, 0x5B35, 0x66B6, 0xD6CD}
#define mel_min_asc { 0x56D5, 0xDAAD, 0xAADA, 0x5B55, 0x6AB6, 0x56D6}

//----- delirios
#define hello { 0xAEAE, 0xA8AA, 0xAEAA, 0xEAAE, 0xAEA0, 0xA0A0}
#define crea { 0x2736, 0x5151, 0x5351, 0x7331, 0x5151, 0x5756 }
#define puto { 0x0000, 0xE2E7, 0xAE85, 0xAE85, 0xE2EF, 0x0000 }

unsigned int msg2guitar[2][6] = { crea, puto };
unsigned int masterScales[3][6] ={major, harmonic_minor, mel_min_asc};
unsigned int masterRoots[6] = { 0x0080, 0x1001, 0x0010, 0x0200, 0x4004, 0x0080};

//There are 22 chord options total (major,...,maj9)
unsigned int masterChords[2][12][2][6] = {
{//major
{ c_major1, c_major2},{ db_major1, db_major2},{ d_major1, d_major2},{ eb_major1, eb_major2},
{ e_major1, e_major2},{ f_major1, f_major2},{ gb_major1, gb_major2},{ g_major1, g_major2},
{ ab_major1, ab_major2},{ a_major1, a_major2},{ bb_major1, bb_major2},{ b_major1, b_major2}},
{//minor
{ c_minor1, c_minor2},{ db_minor1, db_minor2},{ d_minor1, d_minor2},{ eb_minor1, eb_minor2},
{ e_minor1, e_minor2},{ f_minor1, f_minor2},{ gb_minor1, gb_minor2},{ g_minor1, g_minor2},
{ ab_minor1, ab_minor2},{ a_minor1, a_minor2},{ bb_minor1, bb_minor2},{ b_minor1, b_minor2}}
};

// define the language codes
#define _EN_ 0
#define _ES_ 1

// set a default language if one is not selected
#ifndef _LANG_
#define _LANG_ _ES_
#endif 

// define the language specific strings
#if (_LANG_ == _EN_)
char* mainMenuLCD[] = { "Chords", "Scales", "Song Builder", "Key Signature", "More"};
char* chordSM1LCD[] =  { "Major", "Minor"};
char* scaleSM1LCD[] =  { "Major", "Harmoic Minor", "Mel. Min. (Asc)"};
char* songmakerSM1LCD[] = { "# of Chords: 2?", "# of Chords: 3?","# of Chords: 4?", "# of Chords: 5?", "# of Chords: 6?", "# of Chords: 7?", "# of Chords: 8?", "# of Chords: 9?", "# of Chords: 10?", "# of Chords: 11?", "# of Chords: 12?", "# of Chords: 13?", "# of Chords: 14?", "# of Chords: 15?", "# of Chords: 16?", "# of Chords: 17?", "# of Chords: 18?", "# of Chords: 19?", "# of Chords: 20?"};
//char* capoSM1LCD[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"};
char* positionSM3LCD[] = {"Variation 1", "Variation 2"};
char* keysigSM1LCD[] = { "Alphabetic" , "Solmization"};
#endif

#if (_LANG_ == _ES_)
char* mainMenuLCD[] = { "Acordes", "Escalas", "Crear Canciones", "Cifrado", "Otros"};
char* chordSM1LCD[] = { "Mayor", "Menor"};
char* scaleSM1LCD[] = { "Mayor", "Armonica menor", "Melodica Menor"};
char* songmakerSM1LCD[] = { "# de acorde: 2?", "# de acorde: 3?","# de acorde: 4?", "# de acorde: 5?", "# de acorde: 6?", "# de acorde: 7?", "# de acorde: 8?", "# de acorde: 9?", "# de acorde: 10?", "# de acorde: 11?", "# de acorde: 12?", "# de acorde: 13?", "# de acorde: 14?", "# de acorde: 15?", "# de acorde: 16?", "# de acorde: 17?", "# de acorde: 18?", "# de acorde: 19?", "# de acorde: 20?"};
//char* capoSM1LCD[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"};
char* positionSM3LCD[] = {"Variacion 1", "Variacion 2"};                       
char* keysigSM1LCD[] = { "Americano" , "Tradicional"};
#endif 

char* notesSM2LCD[] ={ "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb","G", "G#/Ab", "A", "A#/Bb", "B"};

char* notesSM2LCDSol[] ={ "Do", "Do#/Reb", "Re", "Re#/Mib", "Mi", "Fa", "Fa#/Solb","Sol", "Sol#/Lab", "La", "La#/Sib", "Si"};

char* notesSM2LCDAlf[] ={ "C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb","G", "G#/Ab", "A", "A#/Bb", "B"};

char* moreSM1LCD[] = { "Crea", "Puto" };

//constants
const int mainMenuSize = 4;
const int chordSM1Size = 1;
const int scaleSM1Size = 2;
const int songmakerSM1Size = 18;
const int SM2Size = 11;
const int chordSM3Size = 1;
const int confSM1Size = 1;
const int keysigSM1Size = 1;
const int moreSM1Size = 1;


//constants - pins
const int left = 2;
const int enter = 3;
const int right = 4;

const int LCDSerial = 5;
const int LCDrclk = 6;
const int LCDsrclk = 7;

const int DCreset = 8;
const int DCclk = 9;

const int SIPOrclk = 10;
const int SIPOserial = 11;
const int SIPOsrclk = 13;


//global variables
int buttonArray[3] = { 0, 0, 0};
int prevButtonArray[3] = {0, 0, 0};

//menu[4] = {main menu, sub menu 1, sub menu 2, sub menu 3}
int menu[ 4] = { 0, 0, 0, 0};

unsigned int tempLED[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
unsigned int blinker = 0;

int songMakerMenu[ 24];
char* songMakerChord[ 8];
char* songMakerNote[ 8];
unsigned int songMakerLED[8][6];

//Initialize LCD
ShiftLCD lcd( LCDSerial, LCDrclk, LCDsrclk);


void LEDMatrix(){
  digitalWrite( DCreset, HIGH);
  digitalWrite( DCreset, LOW);
  
  
  for( int y = 0; y < 6; y++){
    //send to LED Matrix
    digitalWrite( SIPOrclk, LOW);
    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, highByte( tempLED[ y]));
    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST,  lowByte( tempLED[ y]));
//    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, 0xFF);
//    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, 0xFF);
    digitalWrite( SIPOrclk, HIGH);
  
    delay(1);    

    digitalWrite( SIPOrclk, LOW);
    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, 0);
    shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, 0);
    digitalWrite( SIPOrclk, HIGH);
 
    
    digitalWrite( DCclk, HIGH);
    digitalWrite( DCclk, LOW);
  
  }
}


void updateLCD( char* text1LCD, char* text2LCD){
  lcd.clear();
  lcd.setCursor( 0, 0);
  lcd.print( text1LCD);
  lcd.setCursor( 0, 1);
  lcd.print( text2LCD);
}


void updateLCD( int counter, char** textLCD){
  char* tempText = textLCD[ counter];
  lcd.clear();
  lcd.setCursor( 0, 0);
  lcd.print( tempText);
  
}

void updateLED(int counter, int sm2, int sm3){
  unsigned int tempLED1[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int tempLED2[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int h = 0x0000;
  
  if( menu[ 0] == 0 || menu[ 0] == 2){
    if( sm2 == 1){
      for( int x = 6; x > 0; x--){
        //tempLED{ TYPE, NOTE, POSITION, unsigned int}
        tempLED[ 6-x] = masterChords[ menu[1]][ counter][ menu[3]][ x-1];
      }
    }else if( sm3 == 1){
      for( int x = 6; x > 0; x--){
        //tempLED{ TYPE, NOTE, POSITION, unsigned int}
        tempLED[ 6-x] = masterChords[ menu[1]][ menu[2]][ counter][ x-1];
      }
    }
  }else if( menu[ 0] == 1 && sm2 == 1){
    for( int x = 6; x > 0; x--){
      
      tempLED[ 6-x] = (masterScales[ menu[1]][ x-1]);
      if( counter < 4){
        tempLED[ 6-x]  = ((((tempLED[ 6-x]<< counter) & 0xF000) >> 12) | ((tempLED[ 6-x]<< counter) & 0xFFF0));
      }else if(counter < 8){
        tempLED[ 6-x]  = ((((tempLED[ 6-x]<< (counter-4)) & 0xFF00) >> 8) | ((tempLED[ 6-x]<< counter) & 0xFF00));
      }else{
        tempLED[ 6-x]  = ((((tempLED[ 6-x]<< (counter-8)) & 0xFFF0) >> 4) | ((tempLED[ 6-x]<< counter) & 0xFFF0));
      }
      
      tempLED2[ 6-x] = (masterRoots[ x-1]);
      if( counter < 4){
        tempLED2[ 6-x]  = ((((tempLED2[ 6-x]<< counter) & 0xF000) >> 12) | ((tempLED2[ 6-x]<< counter) & 0xFFF0));
      }else if(counter < 8){
        tempLED2[ 6-x]  = ((((tempLED2[ 6-x]<< (counter-4)) & 0xFF00) >> 8) | ((tempLED2[ 6-x]<< counter) & 0xFF00));
      }else{
        tempLED2[ 6-x]  = ((((tempLED2[ 6-x]<< (counter-8)) & 0xFFF0) >> 4) | ((tempLED2[ 6-x]<< counter) & 0xFFF0));
      }
      
      blinker++;
      if( blinker < 1000){
        tempLED[ 6-x] = tempLED[ 6-x] - tempLED2[ 6-x];
      }else{
        tempLED[ 6-x] = tempLED[ 6-x];
        if( blinker > 2000){
          blinker = 0;
        }
      }
    }
  }  
  
  if( menu[ 0] == 4 ) {
    for( int x = 6; x > 0; x--){
        tempLED[ 6-x] = (msg2guitar[ counter][ x-1]);
    }
  }
    
  LEDMatrix();
}

int getInput( int limit, char** textLCD, int sm2, int sm3){
  
  int buttonCounter = 0;
  byte exitFlag = 0;
  updateLCD( buttonCounter, textLCD);
  
  
    while( exitFlag == 0){
     updateLED( buttonCounter, sm2, sm3);
    
    //buttonArray = {left, enter, right}
      buttonArray[ 0] = digitalRead(left);
      buttonArray[ 1] = digitalRead(enter);
      buttonArray[ 2] = digitalRead(right);
      
      if( buttonArray[ 0] != prevButtonArray[ 0] && buttonArray[ 0] == LOW){
          while(digitalRead(left) == LOW){
             updateLED( buttonCounter, sm2, sm3);
          }
          if( buttonCounter == 0){
            buttonCounter = limit;
          }else{
            buttonCounter--;
          } 
         updateLCD( buttonCounter, textLCD);
         updateLED( buttonCounter, sm2, sm3);
        
         
      }else if( buttonArray[ 1] != prevButtonArray[ 1] && buttonArray[ 1] == LOW){
        while(digitalRead(enter) == LOW){
           updateLED( buttonCounter, sm2, sm3);
        }
        exitFlag = 1;
        updateLED( buttonCounter, sm2, sm3);
        return buttonCounter;
          
      }else if( buttonArray[ 2] != prevButtonArray[ 2] && buttonArray[ 2] == LOW){
          while(digitalRead(right) == LOW){
             updateLED( buttonCounter, sm2, sm3);
          }
          if( buttonCounter == limit){
            buttonCounter = 0;
          }else{
            buttonCounter++;
          }
          updateLCD( buttonCounter, textLCD);
          updateLED( buttonCounter, sm2, sm3);
      }
      
      
      prevButtonArray[ 0] = buttonArray[ 0];
      prevButtonArray[ 1] = buttonArray[ 1];
      prevButtonArray[ 2] = buttonArray[ 2];
   
  }
}//close getInput

void songMaker( int numOfChords){
  int buttonCounter = 0;
    
    for( int x = 0; x < (numOfChords+2)*3; x=x+3){
      menu[ 1] = getInput( chordSM1Size, chordSM1LCD, 0, 0);
      menu[ 2] = getInput( SM2Size, notesSM2LCD, 1, 0);
      menu[ 3] = getInput( chordSM3Size, positionSM3LCD, 0, 1);
      songMakerMenu[ x] = menu[ 1];  // chord
      songMakerMenu[ x+1] = menu[ 2]; // note
      songMakerMenu[ x+2] = menu[ 3]; //led position
    }
    for( int x = 0; x < numOfChords+2; x++){
      songMakerChord[ x] = chordSM1LCD[songMakerMenu[ x*3]];
      songMakerNote[ x] = notesSM2LCD[songMakerMenu[ x*3+1]];
      for( int y = 6; y > 0; y--){
        //tempLED{ TYPE, NOTE, POSITION, unsigned int}
        songMakerLED[x][ 6-y] = masterChords[ songMakerMenu[ x*3]][ songMakerMenu[ x*3+1]][ songMakerMenu[ x*3+2]][ y-1];

      }
    }
    
    updateLCD( songMakerNote[ buttonCounter], songMakerChord[ buttonCounter]);  
    for( int z = 0; z < 6; z++){
       tempLED[ z] = songMakerLED[ buttonCounter][ z];
     }
     LEDMatrix();

    //When user hits 'enter' this will break out of the loop
    while(digitalRead(enter) == LOW){ 
      buttonArray[ 0] = digitalRead(left);
      buttonArray[ 2] = digitalRead(right);
    
      if( buttonArray[ 0] != prevButtonArray[ 0] && buttonArray[ 0] == LOW){
          while(digitalRead(left) == LOW){
          }
          if( buttonCounter == 0){
            buttonCounter = numOfChords+1;
          }else{
            buttonCounter--;
          } 
          updateLCD( songMakerNote[ buttonCounter], songMakerChord[ buttonCounter]);        
      }else if( buttonArray[ 2] != prevButtonArray[ 2] && buttonArray[ 2] == LOW){
          while(digitalRead(right) == LOW){
          }
          if( buttonCounter == numOfChords+1){
            buttonCounter = 0;
          }else{
            buttonCounter++;
          }
          updateLCD( songMakerNote[ buttonCounter], songMakerChord[ buttonCounter]);
      }
      prevButtonArray[ 0] = buttonArray[ 0];
      prevButtonArray[ 2] = buttonArray[ 2];  
      for( int z = 0; z < 6; z++){
         tempLED[ z] = songMakerLED[ buttonCounter][ z];
       }
       LEDMatrix();
    }
    
    //wait for user to release 'enter'
    while(digitalRead(enter) == LOW){
    }
}

void cambio_de_str(char **s, char **t, int nlines) {
    int i = 0;
    for(i=0;i<nlines;i++) {
        s[i] = t[i];
    }
}

//Determine menu and submenus
void getMenu(){
  /*Main menu only has four (4) options to choose
    Chords, Scales, Capo, Effects*/

  menu[ 0] = getInput( mainMenuSize, mainMenuLCD, 0, 0);
  
  //Main menu determines the submenus to follow
  switch ( menu[0]){
    //menu[ 0] =  0, CHORDS
    case 0:
      menu[ 1] = getInput( chordSM1Size, chordSM1LCD, 0, 0);
      menu[ 2] = getInput( SM2Size, notesSM2LCD, 1, 0);
      menu[ 3] = getInput( chordSM3Size, positionSM3LCD, 0, 1);
      break;
    
    //menu[ 0] =  1, SCALES
    case 1:
      menu[ 1] = getInput( scaleSM1Size, scaleSM1LCD, 0, 0);
      menu[ 2] = getInput( SM2Size, notesSM2LCD, 1, 0);
      break;
      
    //menu[ 0] =  2, CAPO
//    case 2:
//      menu[ 1] = getInput( capoSM1Size, capoSM1LCD, 0, 0);
//      break;
      
    //menu[ 0] =  3, Song Maker 
//    case 3:
    case 2:
      songMaker(  getInput( songmakerSM1Size, songmakerSM1LCD, 0, 0));
      break;

// conf
    case 3:
      if ( getInput(keysigSM1Size, keysigSM1LCD, 0, 0) == 0  ) {
        cambio_de_str(notesSM2LCD, notesSM2LCDAlf, SM2Size);
      } else {
        cambio_de_str(notesSM2LCD, notesSM2LCDSol, SM2Size);
      }
      break;

    case 4:
      menu[ 1] = getInput( moreSM1Size, moreSM1LCD, 0, 0);

      break;

  }
}

void setup(){
  lcd.begin( 16, 2);
  lcd.clear();
  
  //Define pins I/O
  pinMode( left, INPUT);
  pinMode( enter, INPUT);
  pinMode( right, INPUT);
  
  pinMode( DCreset, OUTPUT);
  pinMode( DCclk, OUTPUT);
  pinMode( SIPOrclk, OUTPUT);
  pinMode( SIPOserial, OUTPUT);
  pinMode( SIPOsrclk, OUTPUT);
  
  digitalWrite(left,1);
  digitalWrite(right,1);
  digitalWrite(enter,1);
  
  Serial.begin( 9600);
}

void loop(){
  for( int x = 0; x < 4; x++){
    menu[ x] = 0;
  }
  for( int x = 0; x < 6; x++){
    tempLED [ x] = 0x0000;
  }
  LEDMatrix();
  getMenu();
}



