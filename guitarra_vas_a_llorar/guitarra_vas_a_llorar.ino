/*
Copyright 2011
 
 GuitArduino
 Date: 4/12/2011
 Names: Andrew Garza  (agarza6)
        Mamlook Jendo (mjendo2)
 Adviser: Robert Becker
 
 Fecha: 02/09/2011
 Nuevas modificaciones para Prueba y compilacion 
 Acordes: 7, m7, 9, m9
 Escalas: menor, armonica menor, pentatonica mayor, pentatonica menor
 Soporte idioma espanol
 Cambio de cifrado
 Interfaz serial 
 Otros mensaje
 RAM a Flash
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
/*
IMPORTANT: to use the menubackend library by Alexander Brevig download it at http://www.arduino.cc/playground/uploads/Profiles/MenuBackend_1-4.zip and add the next code at line 195
	void toRoot() {
		setCurrent( &getRoot() );
	}
*/
#include <ShiftLCD.h>
#include <Flash.h>
#include <MenuBackend.h>    //MenuBackend library - copyright by Alexander Brevig

#define _EN_ 0
#define _ES_ 1
 
#ifndef _LANG_
#define _LANG_ _ES_
#endif

#define _ALPHABETIC_ 0
#define _SOLMIZATION_ 1

#ifndef _KEYSIG_
#define _KEYSIG_ _ALPHABETIC_
#endif


#define crea { 0x2736, 0x5151, 0x5351, 0x7331, 0x5151, 0x5756 }
#define puto { 0x0000, 0xE2E7, 0xAE85, 0xAE85, 0xE2EF, 0x0000 }
PROGMEM prog_uint16_t msg2guitar[2][6] = { crea, puto };

#define major     { 0x5AD5, 0x5AB5, 0xAB5A, 0x6B56, 0x6AD6, 0x5AD5}
#define harmonic_minor { 0xD6CD, 0xD9AD, 0x9AD9, 0x5B35, 0x66B6, 0xD6CD}
#define mel_min_asc { 0x56D5, 0xDAAD, 0xAADA, 0x5B55, 0x6AB6, 0x56D6}
#define pentatonic_major { 0x4A94, 0x5295, 0x2952, 0x2A52, 0x4A54, 0x4A94}
#define minor { 0xD6AD, 0xD5AD, 0x5AD5, 0x5AB5, 0x56B5, 0xD6AD}
#define pentatonic_minor { 0x54A5, 0x94A9, 0x4A94, 0x5295, 0x52A5, 0x54A5}
PROGMEM prog_uint16_t masterScales[6][6] ={major, harmonic_minor, mel_min_asc, pentatonic_major, minor, pentatonic_minor };
PROGMEM prog_uint16_t masterRoots[6] = { 0x0080, 0x1001, 0x0010, 0x0200, 0x4004, 0x0080};

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


//MAJOR 7
#define c_major71 { 0x0000, 0x0001, 0x0004, 0x0002, 0x0004, 0x0000}
#define c_major72 { 0x0080, 0x0080, 0x0180, 0x0080, 0x0280, 0x0080}
#define db_major71 { 0x0100, 0x0100, 0x0300, 0x0100, 0x0500, 0x0100}
#define db_major72 { 0x0000, 0x0100, 0x0200, 0x0100, 0x0000, 0x0100}
#define d_major71  { 0x0002, 0x0001, 0x0002, 0x0000, 0x0000, 0x0000}
#define d_major72  { 0x0200, 0x0200, 0x0600, 0x0200, 0x0A00, 0x0200}
#define eb_major71  { 0x0400, 0x0400, 0x0C00, 0x1400, 0x1400, 0x0400}
#define eb_major72  { 0x0000, 0x0400, 0x0800, 0x0400, 0x0000, 0x0400}
#define e_major71  { 0x0000, 0x0000, 0x0001, 0x0000, 0x0002, 0x0000}
#define e_major72  { 0x0800, 0x0800, 0x1800, 0x0800, 0x2800, 0x0800}
#define f_major71  { 0x0001, 0x0001, 0x0003, 0x0001, 0x0005, 0x0001}
#define f_major72  { 0x1000, 0x1000, 0x3000, 0x1000, 0x5000, 0x1000}
#define gb_major71  { 0x0002, 0x0002, 0x0006, 0x0002, 0x000A, 0x0002}
#define gb_major72  { 0x0000, 0x0002, 0x0004, 0x0002, 0x0000, 0x0002}
#define g_major71  { 0x0001, 0x0000, 0x0000, 0x0000, 0x0002, 0x0004}
#define g_major72  { 0x0004, 0x0004, 0x000C, 0x0004, 0x0014, 0x0004}
#define ab_major71  { 0x0008, 0x0008, 0x0018, 0x0008, 0x0028, 0x0008}
#define ab_major72  { 0x0000, 0x0008, 0x0010, 0x0008, 0x0000, 0x0008}
#define a_major71  { 0x0000, 0x0002, 0x0000, 0x0002, 0x0000, 0x0000}
#define a_major72  { 0x0010, 0x0010, 0x0030, 0x0010, 0x0050, 0x0010}
#define bb_major71  { 0x0020, 0x0020, 0x0060, 0x0020, 0x00A0, 0x0020}
#define bb_major72  { 0x0000, 0x0020, 0x0040, 0x0020, 0x0000, 0x0020}
#define b_major71  { 0x0002, 0x0000, 0x0002, 0x0001, 0x0002, 0x0000}
#define b_major72  { 0x0040, 0x0040, 0x00C0, 0x0040, 0x0140, 0x0040}


//MINOR 7
#define c_minor71 { 0x0080, 0x0080, 0x0080, 0x0080, 0x0280, 0x0080}
#define c_minor72 { 0x0000, 0x0080, 0x0080, 0x0080, 0x0000, 0x0080}
#define db_minor71 { 0x0100, 0x0100, 0x0100, 0x0100, 0x0500, 0x0100}
#define db_minor72 { 0x0000, 0x0100, 0x0100, 0x0100, 0x0000, 0x0100}
#define d_minor71  { 0x0001, 0x0001, 0x0002, 0x0000, 0x0000, 0x0000}
#define d_minor72  { 0x0200, 0x0200, 0x0200, 0x0200, 0x0A00, 0x0200}
#define eb_minor71  { 0x0400, 0x0400, 0x0400, 0x0400, 0x1400, 0x0400}
#define eb_minor72  { 0x0000, 0x0400, 0x0400, 0x0400, 0x0000, 0x0400}
#define e_minor71  { 0x0000, 0x0000, 0x0000, 0x0000, 0x0002, 0x0000}
#define e_minor72 { 0x0800, 0x0800, 0x0800, 0x0800, 0x2800, 0x0800}
#define f_minor71  { 0x0001, 0x0001, 0x0001, 0x0001, 0x0005, 0x0001}
#define f_minor72  { 0x1000, 0x1000, 0x1000, 0x1000, 0x5000, 0x1000}
#define gb_minor71  { 0x0002, 0x0002, 0x0002, 0x0002, 0x000A, 0x0002}
#define gb_minor72  { 0x0000, 0x0002, 0x0002, 0x0002, 0x0000, 0x0002}
#define g_minor71  { 0x0004, 0x0004, 0x0004, 0x0004, 0x0014, 0x0004}
#define g_minor72  { 0x0000, 0x0004, 0x0004, 0x0004, 0x0000, 0x0004}
#define ab_minor71  { 0x0008, 0x0008, 0x0018, 0x0028, 0x0028, 0x0008}
#define ab_minor72  { 0x0000, 0x0008, 0x0008, 0x0008, 0x0000, 0x0008}
#define a_minor71  { 0x0000, 0x0001, 0x0000, 0x0002, 0x0000, 0x0000}
#define a_minor72  { 0x0010, 0x0010, 0x0010, 0x0010, 0x0050, 0x0010}
#define bb_minor71  { 0x0020, 0x0020, 0x0020, 0x0020, 0x00A0, 0x0020}
#define bb_minor72  { 0x0000, 0x0020, 0x0020, 0x0020, 0x0000, 0x0020}
#define b_minor71  { 0x0040, 0x0040, 0x0040, 0x0040, 0x0140, 0x0040}
#define b_minor72  { 0x0000, 0x0040, 0x0040, 0x0040, 0x0000, 0x0040}

//MAJOR 9
#define c_major91 { 0x0000, 0x0080, 0x0040, 0x00C0, 0x0040, 0x0080} 
#define c_major92 { 0x0004, 0x0004, 0x0004, 0x0002, 0x0004, 0x0000}
#define db_major91 { 0x0000, 0x0100, 0x0080, 0x0180, 0x0080, 0x0100}
#define db_major92 { 0x0008, 0x0008, 0x0008, 0x0004, 0x0008, 0x0000}
#define d_major91  { 0x0002, 0x0001, 0x0002, 0x0000, 0x0000, 0x0000}
#define d_major92  { 0x0010, 0x0010, 0x0010, 0x0008, 0x0010, 0x0000}
#define eb_major91  { 0x0000, 0x0400, 0x0200, 0x0600, 0x0200, 0x0400}
#define eb_major92  { 0x0020, 0x0020, 0x0020, 0x0010, 0x0020, 0x0000}
#define e_major91  { 0x0002, 0x0000, 0x0001, 0x0000, 0x0002, 0x0000}
#define e_major92  { 0x0000, 0x0800, 0x0400, 0x0C00, 0x0400, 0x0800}
#define f_major91  { 0x0000, 0x0001, 0x0000, 0x0001, 0x0000, 0x0001}
#define f_major92  { 0x0000, 0x1000, 0x0800, 0x1800, 0x0800, 0x1000}
#define gb_major91  { 0x0000, 0x0002, 0x0001, 0x0003, 0x0001, 0x0002}
#define gb_major92  { 0x0000, 0x2000, 0x1000, 0x3000, 0x1000, 0x2000}
#define g_major91  { 0x0000, 0x0004, 0x0002, 0x0006, 0x0002, 0x0004}
#define g_major92  { 0x0200, 0x0200, 0x0200, 0x0100, 0x0200, 0x0000}
#define ab_major91  { 0x0000, 0x0008, 0x0004, 0x000C, 0x0004, 0x0008}
#define ab_major92  { 0x0400, 0x0400, 0x0400, 0x0200, 0x0400, 0x0000}
#define a_major91  { 0x0000, 0x0010, 0x0008, 0x0018, 0x0008, 0x0010}
#define a_major92  { 0x0800, 0x0800, 0x0800, 0x0400, 0x0800, 0x0000}
#define bb_major91  { 0x0000, 0x0020, 0x0010, 0x0030, 0x0010, 0x0020}
#define bb_major92  { 0x0001, 0x0001, 0x0001, 0x0000, 0x0001, 0x0000}
#define b_major91  { 0x0000, 0x0040, 0x0020, 0x0060, 0x0020, 0x0040}
#define b_major92  { 0x0002, 0x0002, 0x0002, 0x0001, 0x0002, 0x0000}


//MINOR 9
#define c_minor91 { 0x0200, 0x0080, 0x0080, 0x0080, 0x0000, 0x0080}
#define c_minor92 { 0x0000, 0x0004, 0x0004, 0x0001, 0x0004, 0x0000}
#define db_minor91 { 0x0400, 0x0100, 0x0100, 0x0100, 0x0000, 0x0100}
#define db_minor92 { 0x0000, 0x0008, 0x0008, 0x0002, 0x0008, 0x0000}
#define d_minor91  { 0x0800, 0x0200, 0x0200, 0x0200, 0x0000, 0x0200}
#define d_minor92  { 0x0000, 0x0010, 0x0010, 0x0004, 0x0010, 0x0000}
#define eb_minor91  { 0x1000, 0x0400, 0x0400, 0x0400, 0x0000, 0x0400}
#define eb_minor92  { 0x0000, 0x0020, 0x0020, 0x0008, 0x0020, 0x0000}
#define e_minor91  { 0x0002, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000}
#define e_minor92 { 0x2000, 0x0800, 0x0800, 0x0800, 0x0000, 0x0800}
#define f_minor91  { 0x0004, 0x0001, 0x0001, 0x0001, 0x0000, 0x0001}
#define f_minor92  { 0x4000, 0x1000, 0x1000, 0x1000, 0x0000, 0x1000}
#define gb_minor91  { 0x0008, 0x0002, 0x0002, 0x0002, 0x0000, 0x0002}
#define gb_minor92  { 0x0000, 0x0100, 0x0100, 0x0040, 0x0100, 0x0000}
#define g_minor91  { 0x0010, 0x0004, 0x0004, 0x0004, 0x0000, 0x0004}
#define g_minor92  { 0x0000, 0x0200, 0x0200, 0x0080, 0x0200, 0x0000}
#define ab_minor91  { 0x0020, 0x0008, 0x0008, 0x0008, 0x0000, 0x0008}
#define ab_minor92  { 0x0000, 0x0400, 0x0400, 0x0100, 0x0400, 0x0000}
#define a_minor91  { 0x0040, 0x0010, 0x0010, 0x0010, 0x0000, 0x0010}
#define a_minor92  { 0x0000, 0x0800, 0x0800, 0x0200, 0x0800, 0x0000}
#define bb_minor91  { 0x0080, 0x0020, 0x0020, 0x0020, 0x0000, 0x0020}
#define bb_minor92  { 0x0000, 0x1000, 0x1000, 0x0400, 0x1000, 0x0000}
#define b_minor91  { 0x0100, 0x0040, 0x0040, 0x0040, 0x0000, 0x0040}
#define b_minor92  { 0x0000, 0x0002, 0x0002, 0x0000, 0x0002, 0x0000}

//There are 22 chord options total (major,...,maj9)
//TIPO(mayor/menor/etc) NOTA VARIACION cuerda
PROGMEM  prog_uint16_t masterChords[6][12][2][6] = {
{//major
{ c_major1, c_major2},{ db_major1, db_major2},{ d_major1, d_major2},{ eb_major1, eb_major2},
{ e_major1, e_major2},{ f_major1, f_major2},{ gb_major1, gb_major2},{ g_major1, g_major2},
{ ab_major1, ab_major2},{ a_major1, a_major2},{ bb_major1, bb_major2},{ b_major1, b_major2}},
{//minor
{ c_minor1, c_minor2},{ db_minor1, db_minor2},{ d_minor1, d_minor2},{ eb_minor1, eb_minor2},
{ e_minor1, e_minor2},{ f_minor1, f_minor2},{ gb_minor1, gb_minor2},{ g_minor1, g_minor2},
{ ab_minor1, ab_minor2},{ a_minor1, a_minor2},{ bb_minor1, bb_minor2},{ b_minor1, b_minor2}},
{//major7
{ c_major71, c_major72},{ db_major71, db_major72},{ d_major71, d_major72},{ eb_major71, eb_major72},
{ e_major71, e_major72},{ f_major71, f_major72},{ gb_major71, gb_major72},{ g_major71, g_major72},
{ ab_major71, ab_major72},{ a_major71, a_major72},{ bb_major71, bb_major72},{ b_major71, b_major72}},
{//minor7
{ c_minor71, c_minor72},{ db_minor71, db_minor72},{ d_minor71, d_minor72},{ eb_minor71, eb_minor72},
{ e_minor71, e_minor72},{ f_minor71, f_minor72},{ gb_minor71, gb_minor72},{ g_minor71, g_minor72},
{ ab_minor71, ab_minor72},{ a_minor71, a_minor72},{ bb_minor71, bb_minor72},{ b_minor71, b_minor72}},
{//major9
{ c_major91, c_major92},{ db_major91, db_major92},{ d_major91, d_major92},{ eb_major91, eb_major92},
{ e_major91, e_major92},{ f_major91, f_major92},{ gb_major91, gb_major92},{ g_major91, g_major92},
{ ab_major91, ab_major92},{ a_major91, a_major92},{ bb_major91, bb_major92},{ b_major91, b_major92}},
{//minor9
{ c_minor91, c_minor92},{ db_minor91, db_minor92},{ d_minor91, d_minor92},{ eb_minor91, eb_minor92},
{ e_minor91, e_minor92},{ f_minor91, f_minor92},{ gb_minor91, gb_minor92},{ g_minor91, g_minor92},
{ ab_minor91, ab_minor92},{ a_minor91, a_minor92},{ bb_minor91, bb_minor92},{ b_minor91, b_minor92}}
};


void (*pt2Function)(int,int) = NULL;  
int pt2val = -1;
int pt2val2 = -1;

unsigned int tempLED[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
unsigned int blinker = 0;

const int DCreset = 8;
const int DCclk = 9;

const int SIPOrclk = 10;
const int SIPOserial = 11;
const int SIPOsrclk = 13;

const int LCDSerial = 5;
const int LCDrclk = 6;
const int LCDsrclk = 7;

const int buttonPinLeft = 2;      // pin for the Up button
const int buttonPinRight = 4;    // pin for the Down button
const int buttonPinEsc = 12;     // pin for the Esc button
const int buttonPinEnter = 3;   // pin for the Enter button


int lastButtonPushed = 0;
int lastButtonEnterState = HIGH;   // the previous reading from the Enter input pin
int lastButtonEscState = HIGH;   // the previous reading from the Esc input pin
int lastButtonLeftState = HIGH;  // the previous reading from the Left input pin
int lastButtonRightState = HIGH;   // the previous reading from the Right input pin
long lastEnterDebounceTime = 0;  // the last time the output pin was toggled
long lastEscDebounceTime = 0;  // the last time the output pin was toggled
long lastLeftDebounceTime = 0;  // the last time the output pin was toggled
long lastRightDebounceTime = 0;  // the last time the output pin was toggled
const int debounceDelay = 200;    // the debounce time

ShiftLCD lcd( LCDSerial, LCDrclk, LCDsrclk);

void readButtons();
void updateLCD( int counter, int prev,_FLASH_STRING_ARRAY textLCD);
void menuUsed(MenuUseEvent used);
void menuChanged(MenuChangeEvent changed);

//Menu variables
MenuBackend menu = MenuBackend(menuUsed,menuChanged);
//initialize menuitems
    MenuItem m0 = MenuItem("0");
      MenuItem m00 = MenuItem("6");
// MAYORES

         MenuItem  m000 = MenuItem("24");
         MenuItem  m001 = MenuItem("25");
         MenuItem  m002 = MenuItem("26");
         MenuItem  m003 = MenuItem("27");
         MenuItem  m004 = MenuItem("28");
         MenuItem  m005 = MenuItem("29");
         MenuItem  m006 = MenuItem("30");
         MenuItem  m007 = MenuItem("31");
         MenuItem  m008 = MenuItem("32");
         MenuItem  m009 = MenuItem("33");
         MenuItem  m0010 = MenuItem("34");
         MenuItem  m0011 = MenuItem("35");
    
      MenuItem m01 = MenuItem("7");
         MenuItem  m010 = MenuItem("36");
         MenuItem  m011 = MenuItem("37");
         MenuItem  m012 = MenuItem("38");
         MenuItem  m013 = MenuItem("39");
         MenuItem  m014 = MenuItem("40");
         MenuItem  m015 = MenuItem("41");
         MenuItem  m016 = MenuItem("42");
         MenuItem  m017 = MenuItem("43");
         MenuItem  m018 = MenuItem("44");
         MenuItem  m019 = MenuItem("45");
         MenuItem  m0110 = MenuItem("46");
         MenuItem  m0111 = MenuItem("47");
      
      MenuItem m02 = MenuItem("8");
         MenuItem  m020 = MenuItem("48");
         MenuItem  m021 = MenuItem("49");
         MenuItem  m022 = MenuItem("50");
         MenuItem  m023 = MenuItem("51");
         MenuItem  m024 = MenuItem("52");
         MenuItem  m025 = MenuItem("53");
         MenuItem  m026 = MenuItem("54");
         MenuItem  m027= MenuItem("55");
         MenuItem  m028 = MenuItem("56");
         MenuItem  m029 = MenuItem("57");
         MenuItem  m0210 = MenuItem("58");
         MenuItem  m0211 = MenuItem("59");
      
      MenuItem m03 = MenuItem("9");
// MAYORES
         MenuItem  m030 = MenuItem("60");
         MenuItem  m031 = MenuItem("61");
         MenuItem  m032 = MenuItem("62");
         MenuItem  m033 = MenuItem("63");
         MenuItem  m034 = MenuItem("64");
         MenuItem  m035 = MenuItem("65");
         MenuItem  m036 = MenuItem("66");
         MenuItem  m037 = MenuItem("67");
         MenuItem  m038 = MenuItem("68");
         MenuItem  m039 = MenuItem("69");
         MenuItem  m0310 = MenuItem("70");
         MenuItem  m0311 = MenuItem("71");
      
      MenuItem m04 = MenuItem("10");
         MenuItem  m040 = MenuItem("72");
         MenuItem  m041 = MenuItem("73");
         MenuItem  m042 = MenuItem("74");
         MenuItem  m043 = MenuItem("75");
         MenuItem  m044 = MenuItem("76");
         MenuItem  m045 = MenuItem("77");
         MenuItem  m046 = MenuItem("78");
         MenuItem  m047 = MenuItem("79");
         MenuItem  m048 = MenuItem("80");
         MenuItem  m049 = MenuItem("81");
         MenuItem  m0410 = MenuItem("82");
         MenuItem  m0411 = MenuItem("83");
      
      MenuItem m05 = MenuItem("11");
         MenuItem  m050 = MenuItem("84");
         MenuItem  m051 = MenuItem("85");
         MenuItem  m052 = MenuItem("86");
         MenuItem  m053 = MenuItem("87");
         MenuItem  m054 = MenuItem("88");
         MenuItem  m055 = MenuItem("89");
         MenuItem  m056 = MenuItem("90");
         MenuItem  m057 = MenuItem("91");
         MenuItem  m058 = MenuItem("92");
         MenuItem  m059 = MenuItem("93");
         MenuItem  m0510 = MenuItem("94");
         MenuItem  m0511 = MenuItem("95");

    MenuItem m1 = MenuItem("1");
      MenuItem m10 = MenuItem("14");
      MenuItem m11 = MenuItem("15");
      MenuItem m12 = MenuItem("16");
      MenuItem m13 = MenuItem("17");  
      MenuItem m14 = MenuItem("18");
      MenuItem m15 = MenuItem("19");
    MenuItem m4 = MenuItem("4");
      MenuItem m40 = MenuItem("22");
      MenuItem m41 = MenuItem("23");
    MenuItem m5 = MenuItem("5");

void setup()
{
  pinMode(buttonPinLeft, INPUT);
  pinMode(buttonPinRight, INPUT);
  pinMode(buttonPinEnter, INPUT);
  pinMode(buttonPinEsc, INPUT);

  digitalWrite(buttonPinLeft,1);
  digitalWrite(buttonPinRight,1);
  digitalWrite(buttonPinEnter,1);
  digitalWrite(buttonPinEsc,1);

   pinMode( DCreset, OUTPUT);
   pinMode( DCclk, OUTPUT);
   pinMode( SIPOrclk, OUTPUT);
   pinMode( SIPOserial, OUTPUT);
   pinMode( SIPOsrclk, OUTPUT);


  lcd.begin(16, 2);

  //configure menu


//MENU RECURSIVO PARA TODAS LAS OPCIONES
//  m0.addRight(menu1Item1).addRight(menu1Item2).addRight(menu1Item3).addRight(menu1Item4).addRight(menu1Item5);
  m0.addRight(m1).addRight(m4).addRight(m5);
  m0.addLeft(m5);
    menu.getRoot().add(m5);
      menu.getRoot().add(m4);
          menu.getRoot().add(m1);
  menu.getRoot().add(m0);          

  m0.add(m05);
  m0.add(m04);
  m0.add(m03);
  m0.add(m02);
  m0.add(m01);
  m0.add(m00);
  m00.addRight(m01).addRight(m02).addRight(m03).addRight(m04).addRight(m05);
  m00.addLeft(m05);


  m00.add(m0011);
  m00.add(m0010);
  m00.add(m009);
  m00.add(m008);
  m00.add(m007);
  m00.add(m006);
  m00.add(m005);
  m00.add(m004);
  m00.add(m003);
  m00.add(m002);
  m00.add(m001);
  m00.add(m000);
  m000.addRight(m001).addRight(m002).addRight(m003).addRight(m004).addRight(m005).addRight(m006).addRight(m007).addRight(m008).addRight(m009).addRight(m0010).addRight(m0011);
  m000.addLeft(m0011);    
  
  m01.add(m0111);
  m01.add(m0110);
  m01.add(m019);
  m01.add(m018);
  m01.add(m017);
  m01.add(m016);
  m01.add(m015);
  m01.add(m014);
  m01.add(m013);
  m01.add(m012);
  m01.add(m011);
  m01.add(m010);
  m010.addRight(m011).addRight(m012).addRight(m013).addRight(m014).addRight(m015).addRight(m016).addRight(m017).addRight(m018).addRight(m019).addRight(m0110).addRight(m0111);
  m010.addLeft(m0111);    


  m02.add(m0211);
  m02.add(m0210);
  m02.add(m029);
  m02.add(m028);
  m02.add(m027);
  m02.add(m026);
  m02.add(m025);
  m02.add(m024);
  m02.add(m023);
  m02.add(m022);
  m02.add(m021);
  m02.add(m020);
  m020.addRight(m021).addRight(m022).addRight(m023).addRight(m024).addRight(m025).addRight(m026).addRight(m027).addRight(m028).addRight(m029).addRight(m0210).addRight(m0211);
  m020.addLeft(m0211);    

  m03.add(m0311);
  m03.add(m0310);
  m03.add(m039);
  m03.add(m038);
  m03.add(m037);
  m03.add(m036);
  m03.add(m035);
  m03.add(m034);
  m03.add(m033);
  m03.add(m032);
  m03.add(m031);
  m03.add(m030);
  m030.addRight(m031).addRight(m032).addRight(m033).addRight(m034).addRight(m035).addRight(m036).addRight(m037).addRight(m038).addRight(m039).addRight(m0310).addRight(m0311);
  m030.addLeft(m0311);    

  m04.add(m0411);
  m04.add(m0410);
  m04.add(m049);
  m04.add(m048);
  m04.add(m047);
  m04.add(m046);
  m04.add(m045);
  m04.add(m044);
  m04.add(m043);
  m04.add(m042);
  m04.add(m041);
  m04.add(m040);
  m040.addRight(m041).addRight(m042).addRight(m043).addRight(m044).addRight(m045).addRight(m046).addRight(m047).addRight(m048).addRight(m049).addRight(m0410).addRight(m0411);    
  m040.addLeft(m0411);    


  m05.add(m0511);
  m05.add(m0510);
  m05.add(m059);
  m05.add(m058);
  m05.add(m057);
  m05.add(m056);
  m05.add(m055);
  m05.add(m054);
  m05.add(m053);
  m05.add(m052);
  m05.add(m051);
  m05.add(m050);
  m050.addRight(m051).addRight(m052).addRight(m053).addRight(m054).addRight(m055).addRight(m056).addRight(m057).addRight(m058).addRight(m059).addRight(m0510).addRight(m0511);
  m050.addLeft(m0511);    


  m1.add(m15);
  m1.add(m14);
  m1.add(m13);
  m1.add(m12);
  m1.add(m11);
  m1.add(m10);
  m10.addRight(m11).addRight(m12).addRight(m13).addRight(m14).addRight(m15);
  m10.addLeft(m15);


m000.remember_parent=true;
m10.add(m000);
m11.add(m000);
m12.add(m000);
m13.add(m000);
m14.add(m000);
m15.add(m000);



/* 
  menu1Item3.add(menuItem30);
  menuItem30.addRight(menuItem31);
  menuItem30.addLeft(menuItem31);
*/
  m4.add(m41);
  m4.add(m40);
  m40.addRight(m41);
  m40.addLeft(m41);
  
  menu.toRoot();

  lcd.setCursor(0,0);  
  lcd.print(" ..::CREAR::.. ");
  lcd.setCursor(0,1);  
  lcd.print("__Guitarra Led__");
  
// Serial.begin( 9600);
// Serial.print("XXX\n");

}  // setup()...


void loop()
{
for( int x = 0; x < 6; x++){
    tempLED [ x] = 0x0000;
   }

  readButtons();  //I splitted button reading and navigation in two procedures because 
  navigateMenus();  //in some situations I want to use the button for other purpose (eg. to change some settings)

if (pt2val != -1 && pt2Function != NULL) {
    pt2Function(pt2val,pt2val2);
}
     
  LEDMatrix();              
} //loop()... 

void showChord(int idx, int other) {
if(other != -1) {
  for( int x = 6; x > 0; x--){
         tempLED[ 6-x] = pgm_read_word_near(&(masterChords[ other ][ idx][ 0][ x-1]));
//       tempLED[ 6-x] = pgm_read_word_near(&(masterChords[ grupo/tipo ][ acorde][ variacion][ x-1]));
//       masterChords[6][12][2][6]
       }
}

}


void showMessage(int idx, int other) {
    for( int x = 6; x > 0; x--){
      tempLED[ 6-x] = pgm_read_word_near(&(msg2guitar[ idx][ x-1]));
     }
}

void showScale(int counter, int other) {
  unsigned int tempLED1[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int tempLED2[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int h = 0x0000;
  // menu[1] en vez de 0
  for( int x = 6; x > 0; x--){
       tempLED[ 6-x] = pgm_read_word_near(&(masterScales[ other][ x-1]));
       if( counter < 4){
         tempLED[ 6-x]  = ((((tempLED[ 6-x]<< counter) & 0xF000) >> 12) | ((tempLED[ 6-x]<< counter) & 0xFFF0));
       }else if(counter < 8){
         tempLED[ 6-x]  = ((((tempLED[ 6-x]<< (counter-4)) & 0xFF00) >> 8) | ((tempLED[ 6-x]<< counter) & 0xFF00));
       }else{
         tempLED[ 6-x]  = ((((tempLED[ 6-x]<< (counter-8)) & 0xFFF0) >> 4) | ((tempLED[ 6-x]<< counter) & 0xFFF0));
       }
 
       tempLED2[ 6-x] = pgm_read_word_near(&(masterRoots[ x-1]));
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


void updateLCD( int counter, int prev,_FLASH_STRING_ARRAY textLCD){
   lcd.clear();

   lcd.setCursor( 0, 0);
   lcd.setCursor(((16-textLCD[prev].length())/2),0);
   textLCD[prev].print(lcd);
   
   lcd.setCursor( 0, 1);
   FLASH_STRING(izquierda, "<-");
   izquierda.print(lcd); 
   lcd.setCursor(((14-textLCD[counter].length())/2)+2,1);
   textLCD[counter].print(lcd);
}

void  readButtons(){  //read buttons status
  int reading;
  int buttonEnterState=HIGH;             // the current reading from the Enter input pin
  int buttonEscState=HIGH;             // the current reading from the input pin
  int buttonLeftState=HIGH;             // the current reading from the input pin
  int buttonRightState=HIGH;             // the current reading from the input pin

  //Enter button
                  // read the state of the switch into a local variable:
                  reading = digitalRead(buttonPinEnter);

                  // check to see if you just pressed the enter button 
                  // (i.e. the input went from LOW to HIGH),  and you've waited 
                  // long enough since the last press to ignore any noise:  
                
                  // If the switch changed, due to noise or pressing:
                  if (reading != lastButtonEnterState) {
                    // reset the debouncing timer
                    lastEnterDebounceTime = millis();
                  } 
                  
                  if ((millis() - lastEnterDebounceTime) > debounceDelay) {
                    // whatever the reading is at, it's been there for longer
                    // than the debounce delay, so take it as the actual current state:
                    buttonEnterState=reading;
                    lastEnterDebounceTime=millis();
                  }
                  
                  // save the reading.  Next time through the loop,
                  // it'll be the lastButtonState:
                  lastButtonEnterState = reading;
                  

    //Esc button                 
                  reading = digitalRead(buttonPinEsc);
                  if (reading != lastButtonEscState) {
                    lastEscDebounceTime = millis();
                  } 
                  if ((millis() - lastEscDebounceTime) > debounceDelay) {
                    buttonEscState = reading;
                    lastEscDebounceTime=millis();
                  }
                  lastButtonEscState = reading; 
                  
                 
   //Down button               
                  reading = digitalRead(buttonPinRight);
                  if (reading != lastButtonRightState) {
                    lastRightDebounceTime = millis();
                  } 
                  if ((millis() - lastRightDebounceTime) > debounceDelay) {
                    buttonRightState = reading;
                   lastRightDebounceTime =millis();
                  }
                  lastButtonRightState = reading;                  
                  
                  
    //Up button               
                  reading = digitalRead(buttonPinLeft);
                  if (reading != lastButtonLeftState) {
                    lastLeftDebounceTime = millis();
                  } 
                  if ((millis() - lastLeftDebounceTime) > debounceDelay) {
                    buttonLeftState = reading;
                    lastLeftDebounceTime=millis();;
                  }
                  lastButtonLeftState = reading;  

                  if (buttonEnterState==LOW){
                    lastButtonPushed=buttonPinEnter;

                  }else if(buttonEscState==LOW){
                    lastButtonPushed=buttonPinEsc;

                  }else if(buttonRightState==LOW){
                    lastButtonPushed=buttonPinRight;

                  }else if(buttonLeftState==LOW){
                    lastButtonPushed=buttonPinLeft;

                  }else{
                    lastButtonPushed=0;
                  }   
}
void menuUsed(MenuUseEvent used){
/*        lcd.setCursor(0,0);
       lcd.print(used.item.getBefore()->getName());
      lcd.print(used.item.getName());
      return;*/
  if( used.item == m40 ){
      pt2Function = &showMessage;
      pt2val = 0;
  }
   
  if( used.item == m41 ){
      pt2Function = &showMessage;
      pt2val = 1;
      pt2val2 = -1;
  }
/*
  if( used.item == m10 || used.item == m11 || used.item == m12 || used.item == m13 || used.item == m14 || used.item == m15) {
//if( used.item == m100 || used.item == m101  || used.item == m102  || used.item == m103  || used.item == m104  || used.item == m105  || used.item == m106  || used.item == m107  || used.item == m108  || used.item == m109  || used.item == m1010   || used.item == m1011) {
  //    MenuItem a = used.item.getLeft()->getName();
//      lcd.setCursor(0,0);
//      lcd.print(used.item.getBefore()->getName());
      pt2Function = &showScale;
      pt2val = atoi(used.item.getName())-14;
      pt2val2 = atoi(used.item.getBefore()->getName())-24;
  }
*/
if( used.item == m000 || used.item == m001  || used.item == m002  || used.item == m003  || used.item == m004  || used.item == m005  || used.item == m006  || used.item == m007  || used.item == m008  || used.item == m009  || used.item == m0010   || used.item == m0011 ||
    used.item == m010 || used.item == m011  || used.item == m012  || used.item == m013  || used.item == m014  || used.item == m015  || used.item == m016  || used.item == m017  || used.item == m018  || used.item == m019  || used.item == m0010   || used.item == m0111 ||
    used.item == m020 || used.item == m021  || used.item == m022  || used.item == m023  || used.item == m024  || used.item == m025  || used.item == m026  || used.item == m027  || used.item == m028  || used.item == m029  || used.item == m0210   || used.item == m0211 ||
    used.item == m030 || used.item == m031  || used.item == m032  || used.item == m033  || used.item == m034  || used.item == m035  || used.item == m036  || used.item == m037  || used.item == m038  || used.item == m039  || used.item == m0310   || used.item == m0311 ||
    used.item == m040 || used.item == m041  || used.item == m042  || used.item == m043  || used.item == m044  || used.item == m045  || used.item == m046  || used.item == m047  || used.item == m048  || used.item == m049  || used.item == m0410   || used.item == m0411 ||
    used.item == m050 || used.item == m051  || used.item == m052  || used.item == m053  || used.item == m054  || used.item == m055  || used.item == m056  || used.item == m057  || used.item == m058  || used.item == m059  || used.item == m0510   || used.item == m0511 
    ) {
      
   MenuItem padre = *(used.item.getBefore());  
   if( padre == m10 || padre == m11 || padre == m12 || padre == m13 || padre == m14 || padre == m15) {
      pt2Function = &showScale;
      pt2val = atoi(used.item.getName())-24;
      pt2val2 = atoi(used.item.getBefore()->getName())-14;
   } else {
        pt2Function = &showChord;
        pt2val = atoi(used.item.getName())%12;
        pt2val2 = atoi(used.item.getBefore()->getName())-6;
  }
}  


  delay(200);  //delay to allow message reading
//  menu.toRoot();  //back to Main
}

void menuChanged(MenuChangeEvent changed){
  FLASH_STRING_ARRAY( menuLCD, 
#if (_LANG_ == _ES_)
                               PSTR("Acordes"), PSTR( "Escalas"),  PSTR("Crear Canciones"),  PSTR("Cifrado"),  PSTR("Mensajes"),  PSTR("Conectar PC"), 
                               PSTR("Mayor"),  PSTR("Menor"),  PSTR("Mayor 7"), PSTR("Menor 7"),  PSTR("Mayor 9"),  PSTR("Menor 9"), 
                               PSTR("Variacion 1"),  PSTR("Variacion 2"), 
                               PSTR("Mayor"),  PSTR("Armonica menor"),  PSTR("Melodica Menor"),  PSTR("Pentatonica May"),  PSTR("Menor"),  PSTR("Pentatonica Men"), 
                               PSTR("Americano") ,  PSTR("Tradicional"),
                               PSTR("Crea"), PSTR("Puto"),                              
#endif              
#if (_LANG_ == _EN_)
                               PSTR("Chords"), PSTR( "Scales"),  PSTR("Song Builder"), PSTR("Key Signature"),  PSTR("Messages"),  PSTR("Songs"),
                               PSTR("Major"),  PSTR("Minor"),  PSTR("Major 7"), PSTR("Minor 7"),  PSTR("Major 9"),  PSTR("Minor 9"),
                               PSTR("Variation 1"),  PSTR("Variation 2"),
                               PSTR("Major"),  PSTR("Harmonic minor"),  PSTR("Melodic Minor"),  PSTR("Pentatonic Maj"),  PSTR("Minor"),  PSTR("Pentatonic Min"),
                               PSTR("Alphabetic") ,  PSTR("Solmization"),
                               PSTR("Crea"), PSTR("Puto"),               

#endif            
#if (_KEYSIG_ == _ALPHABETIC_)
                               PSTR("C"), PSTR("C#/Db"), PSTR("D"), PSTR("D#/Eb"), PSTR("E"), PSTR("F"), PSTR("F#/Gb"),PSTR("G"), PSTR("G#/Ab"), PSTR("A"), PSTR("A#/Bb"), PSTR("B"),
                               PSTR("Cm"),  PSTR("C#m/Dbm"),  PSTR("Dm"),  PSTR("D#m/Ebm"), PSTR("Em"),  PSTR("Fm"),  PSTR("F#m/Gbm"), PSTR("Gm"),  PSTR("G#m/Abm"),  PSTR("Am"), PSTR("A#m/Bbm"),  PSTR("Bm"),
                               PSTR("C7"),  PSTR("C#7/Db7"),  PSTR("D7"),  PSTR("D#7/Eb7"), PSTR("E7"),  PSTR("F7"),  PSTR("F#7/Gb7"), PSTR("G7"),  PSTR("G#7/Ab7"),  PSTR("A7"), PSTR("A#7/Bb7"),  PSTR("B7"),
                               PSTR("Cm7"),  PSTR("C#m7/Dbm7"),  PSTR("Dm7"),  PSTR("D#m7/Ebm7"),  PSTR("Em7"),  PSTR("Fm7"),  PSTR("F#m7/Gbm7"), PSTR("Gm7"),  PSTR("G#m7/Abm7"), PSTR("Am7"),  PSTR("A#m7/Bbm7"), PSTR("Bm7"),
                               PSTR("C9"),  PSTR("C#9/Db9"),  PSTR("D9"),  PSTR("D#9/Eb9"), PSTR("E9"),  PSTR("F9"),  PSTR("F#9/Gb9"), PSTR("G9"),  PSTR("G#9/Ab9"),  PSTR("A9"), PSTR("A#9/Bb9"),  PSTR("B9"),
                               PSTR("Cm9"),  PSTR("C#m9/Dbm9"),  PSTR("Dm9"),  PSTR("D#m9/Ebm9"),  PSTR("Em9"),  PSTR("Fm9"),  PSTR("F#m9/Gbm9"), PSTR("Gm9"),  PSTR("G#m9/Abm9"), PSTR("Am9"),  PSTR("A#m9/Bbm9"),  PSTR("Bm9"),
#endif
#if (_KEYSIG_ == _SOLMIZATION_)
                               PSTR("Do"), PSTR("Do#/Reb"), PSTR("Re"), PSTR("Re#/Mib"), PSTR("Mi"), PSTR("Fa"), PSTR("Fa#/Solb"),PSTR("Sol"), PSTR("Sol#/Lab"), PSTR("La"), PSTR("La#/Sib"), PSTR("Si"),
                               PSTR( "Dom"), PSTR("Do#m/Rebm"), PSTR("Rem"), PSTR("Re#m/Mibm"), PSTR("Mim"), PSTR("Fam"), PSTR("Fa#m/Solbm"),PSTR("Solm"), PSTR("Sol#m/Labm"), PSTR("Lam"), PSTR("La#m/Sibm"), PSTR("Sim"),
                               PSTR("Do7"), PSTR("Do#7/Reb7"), PSTR("Re7"), PSTR("Re#7/Mib7"), PSTR("Mi7"), PSTR("Fa7"), PSTR("Fa#7/Solb7"),PSTR("Sol7"), PSTR("Sol#7/Lab7"), PSTR("La7"), PSTR("La#7/Sib7"), PSTR("Si7"),
                               PSTR("Dom7"), PSTR("Do#m7/Rebm7"), PSTR("Rem7"), PSTR("Re#m7/Mibm7"), PSTR("Mim7"), PSTR("Fam7"), PSTR("Fa#m7/Solbm7"),PSTR("Solm7"), PSTR("Sol#m7/Labm7"), PSTR("Lam7"), PSTR("La#m7/Sibm7"), PSTR("Sim7"),
                               PSTR("Do9"), PSTR("Do#9/Reb9"), PSTR("Re9"), PSTR("Re#9/Mib9"), PSTR("Mi9"), PSTR("Fa9"), PSTR("Fa#9/Solb9"),PSTR("Sol9"), PSTR("Sol#9/Lab9"), PSTR("La9"), PSTR("La#9/Sib9"), PSTR("Si9"),
                               PSTR("Dom9"), PSTR("Do#m9/Rebm9"), PSTR("Rem9"), PSTR("Re#m9/Mibm9"), PSTR("Mim9"), PSTR("Fam9"), PSTR("Fa#m9/Solbm9"),PSTR("Solm9"), PSTR("Sol#m9/Labm9"), PSTR("Lam9"), PSTR("La#m9/Sibm9"), PSTR("Sim9")
#endif
                               );
  MenuItem newMenuItem=changed.to; //get the destination menu
  MenuItem newMenuItemAnt = changed.from; //get the destination menu

  if(newMenuItem.getName()==menu.getRoot()){

    //ACA HAY QUE IR A L PRIMER ELEMENTO DEL MENU PROBAR SETCURERENT cambiando a public
    lcd.clear();
    lcd.setCursor(0,1);
    lcd.print("Main Menu       ");
    
    
  } else {
    
  
//    updateLCD(atoi(newMenuItemAnt.getName()),menuLCD);
    updateLCD(atoi(newMenuItem.getName()), atoi(newMenuItem.getBefore()->getName()), menuLCD );
  }
   
   
}


void navigateMenus() {
  MenuItem currentMenu=menu.getCurrent();

  switch (lastButtonPushed){
    case buttonPinEnter:
      if(!(currentMenu.moveDown())){  //if the current menu has a child and has been pressed enter then menu navigate to item below
        menu.use();
      }else{  //otherwise, if menu has no child and has been pressed enter the current menu is used
        menu.moveDown();
       } 
      break;
    case buttonPinEsc:
      menu.toRoot();  //back to main
      break;
    case buttonPinRight:
      menu.moveRight();
      break;      
    case buttonPinLeft:
      menu.moveLeft();
      break;      
  }
  
  lastButtonPushed=0; //reset the lastButtonPushed variable
}


void LEDMatrix(){
   digitalWrite( DCreset, HIGH);
   digitalWrite( DCreset, LOW);
 
   for( int y = 5; y >= 0; y--){
 //  for( int y = 0; y < 6; y++){
     //send to LED Matrix
     digitalWrite( SIPOrclk, LOW);
     shiftOut( SIPOserial, SIPOsrclk, MSBFIRST, highByte( tempLED[ y]));
     shiftOut( SIPOserial, SIPOsrclk, MSBFIRST,  lowByte( tempLED[ y]));
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

