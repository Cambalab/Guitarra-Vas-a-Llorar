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


#include <avr/pgmspace.h> // Write constants to Flash
#include <ShiftLCD.h>
#include <Flash.h>

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

//---------SCALES (all scales have C as their root)
#define major     { 0x5AD5, 0x5AB5, 0xAB5A, 0x6B56, 0x6AD6, 0x5AD5}
#define harmonic_minor { 0xD6CD, 0xD9AD, 0x9AD9, 0x5B35, 0x66B6, 0xD6CD}
#define mel_min_asc { 0x56D5, 0xDAAD, 0xAADA, 0x5B55, 0x6AB6, 0x56D6}
#define pentatonic_major { 0x4A94, 0x5295, 0x2952, 0x2A52, 0x4A54, 0x4A94}
#define minor { 0xD6AD, 0xD5AD, 0x5AD5, 0x5AB5, 0x56B5, 0xD6AD}
#define pentatonic_minor { 0x54A5, 0x94A9, 0x4A94, 0x5295, 0x52A5, 0x54A5}

#define crea { 0x2736, 0x5151, 0x5351, 0x7331, 0x5151, 0x5756 }
#define puto { 0x0000, 0xE2E7, 0xAE85, 0xAE85, 0xE2EF, 0x0000 }

PROGMEM prog_uint16_t msg2guitar[2][6] = { crea, puto };
PROGMEM prog_uint16_t masterScales[6][6] ={major, harmonic_minor, mel_min_asc, pentatonic_major, minor, pentatonic_minor };
PROGMEM prog_uint16_t masterRoots[6] = { 0x0080, 0x1001, 0x0010, 0x0200, 0x4004, 0x0080};

//There are 22 chord options total (major,...,maj9)
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

// define the language codes
#define _EN_ 0
#define _ES_ 1

// set a default language if one is not selected
#ifndef _LANG_
#define _LANG_ _ES_
#endif 

//constants
const int mainMenuSize = 5;
const int chordSM1Size = 5;
const int scaleSM1Size = 5;
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

int keysig = 0; // 0 americano 1 tradicional

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


void updateLCD( _FLASH_STRING text1LCD, _FLASH_STRING text2LCD){
  lcd.clear();
  lcd.setCursor( 0, 0);
  text1LCD.print(lcd);
  lcd.setCursor( 0, 1);
  text2LCD.print(lcd);
}


void updateLCD( int counter, _FLASH_STRING_ARRAY textLCD){
  lcd.clear();
  lcd.setCursor( 0, 0);
  textLCD[counter].print(lcd);
}

void updateLED(int counter, int sm2, int sm3){
  unsigned int tempLED1[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int tempLED2[6] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
  unsigned int h = 0x0000;
  
  if( menu[ 0] == 0 || menu[ 0] == 2){
    if( sm2 == 1){
      for( int x = 6; x > 0; x--){
        //tempLED{ TYPE, NOTE, POSITION, unsigned int}
        tempLED[ 6-x] = pgm_read_word_near(&(masterChords[ menu[1]][ counter][ menu[3]][ x-1]));
      }
    }else if( sm3 == 1){
      for( int x = 6; x > 0; x--){
        //tempLED{ TYPE, NOTE, POSITION, unsigned int}
        tempLED[ 6-x] = pgm_read_word_near(&(masterChords[ menu[1]][ menu[2]][ counter][ x-1]));
      }
    }
  }else if( menu[ 0] == 1 && sm2 == 1){
    for( int x = 6; x > 0; x--){
      
      tempLED[ 6-x] = pgm_read_word_near(&(masterScales[ menu[1]][ x-1]));
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
  
  if( menu[ 0] == 4 ) {
    for( int x = 6; x > 0; x--){
        tempLED[ 6-x] = pgm_read_word_near(&(msg2guitar[ counter][ x-1]));
    }
  }
    
  LEDMatrix();
}

int getInput( int limit, _FLASH_STRING_ARRAY textLCD, int sm2, int sm3){
  
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
/*
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
        songMakerLED[x][ 6-y] = pgm_read_word_near(&(masterChords[ songMakerMenu[ x*3]][ songMakerMenu[ x*3+1]][ songMakerMenu[ x*3+2]][ y-1]));

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
    */
}


void cambio_de_str(char *(*s)[12], char *(*t)[12], int nlines) {
     int i,j = 0;
     for(i=0;i<6;i++) {
         for(j=0;j<12;j++) {
            s[i][j] = t[i][j];
         }
     }
}




void readSongNotes() {
    int n=0, x=0 , t=0;
    
    // Usamos los 96 caracteres luego del 32 dec para mostrar (33 a 127)
    while(t != 32) { // leemos serial hasta barra espaciadora
        n = t - 32;
        for(x = 0; x < 6; x++) {
            if((n <= ((x+1)*16)) && (n > (x*16))) {
                tempLED[ x] = 1 << (n - (16*x) - 1);
                //Serial.println((n-(16*x)));
            } else {
                tempLED[ x]= 0;
                //Serial.println(0);
            }
        }
      
        if (Serial.available() > 0) {  
            // read the incoming byte:  
            t = Serial.read();
            //Serial.println(t);
            delay(10);
        }
        LEDMatrix();
    }
}



//Determine menu and submenus
void getMenu(){
  /*Main menu only has four (4) options to choose
    Chords, Scales, Capo, Effects*/
  
  //updateLCD("..::Crear::..","Guitarduino v1.0");

#if (_LANG_ == _EN_)
    char* mainMenuLCD[] = { "Chords", "Scales", "Song Builder", "Key Signature", "Messages", "Songs"};
    char* chordSM1LCD[] =  { "Major", "Minor", "Major 7", "Minor 7", "Major 9", "Minor 9"};
    char* scaleSM1LCD[] =  { "Major", "Harmoic Minor", "Mel. Min. (Asc)", "Pentatonic Major", "Minor", "Pentatonic Minor"};
//    char* songmakerSM1LCD[] = { "# of Chords: 2?", "# of Chords: 3?","# of Chords: 4?", "# of Chords: 5?", "# of Chords: 6?", "# of Chords: 7?", "# of Chords: 8?", "# of Chords: 9?", "# of Chords: 10?", "# of Chords: 11?", "# of Chords: 12?", "# of Chords: 13?", "# of Chords: 14?", "# of Chords: 15?", "# of Chords: 16?", "# of Chords: 17?", "# of Chords: 18?", "# of Chords: 19?", "# of Chords: 20?"};
//char* capoSM1LCD[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"};
    char* positionSM3LCD[] = {"Variation 1", "Variation 2"};
    char* keysigSM1LCD[] = { "Alphabetic" , "Solmization"};
#endif

#if (_LANG_ == _ES_)
    FLASH_STRING_ARRAY( mainMenuLCD, PSTR("Acordes"), PSTR( "Escalas"),  PSTR("Crear Canciones"),  PSTR("Cifrado"),  PSTR("Mensajes"),  PSTR("Canciones"));
    
    FLASH_STRING_ARRAY(chordSM1LCD,  PSTR("Mayor"),  PSTR("Menor"),  PSTR("Mayor 7"),  PSTR("Menor 7"),  PSTR("Mayor 9"),  PSTR("Menor 9"));
    
    FLASH_STRING_ARRAY(scaleSM1LCD,  PSTR("Mayor"),  PSTR("Armonica menor"),  PSTR("Melodica Menor"),  PSTR("Pentatonica May"),  PSTR("Menor"),  PSTR("Pentatonica Men"));
    
//    FLASH_STRING_ARRAY( songmakerSM1LCD, PSTR("# de acorde: 2?"),  PSTR("# de acorde: 3?"), PSTR("# de acorde: 4?"), PSTR("# de acorde: 5?"), PSTR("# de acorde: 6?"), PSTR("# de acorde: 7?"), PSTR("# de acorde: 8?"), PSTR("# de acorde: 9?"), PSTR("# de acorde: 10?"), PSTR("# de acorde: 11?"), PSTR("# de acorde: 12?"), PSTR("# de acorde: 13?"), PSTR("# de acorde: 14?"), PSTR("# de acorde: 15?"), PSTR("# de acorde: 16?)", PSTR("# de acorde: 17?"), PSTR("# de acorde: 18?"), PSTR("# de acorde: 19?"), PSTR("# de acorde: 20?"));
//char* capoSM1LCD[] = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"};
    
    FLASH_STRING_ARRAY(positionSM3LCD,  PSTR("Variacion 1"),  PSTR("Variacion 2"));
    
    FLASH_STRING_ARRAY(keysigSM1LCD ,  PSTR("Americano") ,  PSTR("Tradicional"));
#endif

//char *notesSM2LCD[6][12] = {

FLASH_STRING_ARRAY(notesSM2LCD1, PSTR("C"), PSTR("C#/Db"), PSTR("D"), PSTR("D#/Eb"), PSTR("E"), PSTR("F"), PSTR("F#/Gb"),PSTR("G"), PSTR("G#/Ab"), PSTR("A"), PSTR("A#/Bb"), PSTR("B"));

FLASH_STRING_ARRAY(notesSM2LCD2, PSTR("Cm"),  PSTR("C#m/Dbm"),  PSTR("Dm"),  PSTR("D#m/Ebm"),  PSTR("Em"),  PSTR("Fm"),  PSTR("F#m/Gbm"), PSTR("Gm"),  PSTR("G#m/Abm"),  PSTR("Am"),  PSTR("A#m/Bbm"),  PSTR("Bm"));

FLASH_STRING_ARRAY(notesSM2LCD3, PSTR("C7"),  PSTR("C#7/Db7"),  PSTR("D7"),  PSTR("D#7/Eb7"),  PSTR("E7"),  PSTR("F7"),  PSTR("F#7/Gb7"), PSTR("G7"),  PSTR("G#7/Ab7"),  PSTR("A7"),  PSTR("A#7/Bb7"),  PSTR("B7"));

FLASH_STRING_ARRAY(notesSM2LCD4, PSTR("Cm7"),  PSTR("C#m7/Dbm7"),  PSTR("Dm7"),  PSTR("D#m7/Ebm7"),  PSTR("Em7"),  PSTR("Fm7"),  PSTR("F#m7/Gbm7"), PSTR("Gm7"),  PSTR("G#m7/Abm7"),  PSTR("Am7"),  PSTR("A#m7/Bbm7"),  PSTR("Bm7"));

FLASH_STRING_ARRAY(notesSM2LCD5, PSTR("C9"),  PSTR("C#9/Db9"),  PSTR("D9"),  PSTR("D#9/Eb9"),  PSTR("E9"),  PSTR("F9"),  PSTR("F#9/Gb9"), PSTR("G9"),  PSTR("G#9/Ab9"),  PSTR("A9"),  PSTR("A#9/Bb9"),  PSTR("B9"));

FLASH_STRING_ARRAY(notesSM2LCD6, PSTR("Cm9"),  PSTR("C#m9/Dbm9"),  PSTR("Dm9"),  PSTR("D#m9/Ebm9"),  PSTR("Em9"),  PSTR("Fm9"),  PSTR("F#m9/Gbm9"), PSTR("Gm9"),  PSTR("G#m9/Abm9"),  PSTR("Am9"),  PSTR("A#m9/Bbm9"),  PSTR("Bm9"));

//char *notesSM2LCDSol[6][12] = {
FLASH_STRING_ARRAY(notesSM2LCD1t, PSTR("Do"), PSTR("Do#/Reb"), PSTR("Re"), PSTR("Re#/Mib"), PSTR("Mi"), PSTR("Fa"), PSTR("Fa#/Solb"),PSTR("Sol"), PSTR("Sol#/Lab"), PSTR("La"), PSTR("La#/Sib"), PSTR("Si"));

FLASH_STRING_ARRAY(notesSM2LCD2t, PSTR( "Dom"), PSTR("Do#m/Rebm"), PSTR("Rem"), PSTR("Re#m/Mibm"), PSTR("Mim"), PSTR("Fam"), PSTR("Fa#m/Solbm"),PSTR("Solm"), PSTR("Sol#m/Labm"), PSTR("Lam"), PSTR("La#m/Sibm"), PSTR("Sim"));

FLASH_STRING_ARRAY(notesSM2LCD3t, PSTR("Do7"), PSTR("Do#7/Reb7"), PSTR("Re7"), PSTR("Re#7/Mib7"), PSTR("Mi7"), PSTR("Fa7"), PSTR("Fa#7/Solb7"),PSTR("Sol7"), PSTR("Sol#7/Lab7"), PSTR("La7"), PSTR("La#7/Sib7"), PSTR("Si7"));

FLASH_STRING_ARRAY(notesSM2LCD4t, PSTR("Dom7"), PSTR("Do#m7/Rebm7"), PSTR("Rem7"), PSTR("Re#m7/Mibm7"), PSTR("Mim7"), PSTR("Fam7"), PSTR("Fa#m7/Solbm7"),PSTR("Solm7"), PSTR("Sol#m7/Labm7"), PSTR("Lam7"), PSTR("La#m7/Sibm7"), PSTR("Sim7"));

FLASH_STRING_ARRAY(notesSM2LCD5t, PSTR("Do9"), PSTR("Do#9/Reb9"), PSTR("Re9"), PSTR("Re#9/Mib9"), PSTR("Mi9"), PSTR("Fa9"), PSTR("Fa#9/Solb9"),PSTR("Sol9"), PSTR("Sol#9/Lab9"), PSTR("La9"), PSTR("La#9/Sib9"), PSTR("Si9"));

FLASH_STRING_ARRAY(notesSM2LCD6t, PSTR("Dom9"), PSTR("Do#m9/Rebm9"), PSTR("Rem9"), PSTR("Re#m9/Mibm9"), PSTR("Mim9"), PSTR("Fam9"), PSTR("Fa#m9/Solbm9"),PSTR("Solm9"), PSTR("Sol#m9/Labm9"), PSTR("Lam9"), PSTR("La#m9/Sibm9"), PSTR("Sim9"));

FLASH_STRING_ARRAY(moreSM1LCD, PSTR("Crea"), PSTR("Puto"));

  menu[ 0] = getInput( mainMenuSize, mainMenuLCD, 0, 0);
  
  //Main menu determines the submenus to follow
    //menu[ 0] =  0, CHORDS
switch ( menu[0]) {
    case 0:
      
      menu[ 1] = getInput( chordSM1Size, chordSM1LCD, 0, 0);
      
      switch(menu[1]) { //Horrible pero con esta libreria no se puede array de array de strings
        case 0: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD1:notesSM2LCD1t), 1, 0); break;
        case 1: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD2:notesSM2LCD2t), 1, 0); break;      
        case 2: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD3:notesSM2LCD3t), 1, 0); break;        
        case 3: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD4:notesSM2LCD4t), 1, 0); break;        
        case 4: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD5:notesSM2LCD5t), 1, 0); break;
        case 5: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD6:notesSM2LCD6t), 1, 0); break;
        default: menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD1:notesSM2LCD1t), 1, 0); break;
      }
      menu[ 3] = getInput( chordSM3Size, positionSM3LCD, 0, 1);
      break;
    
    //menu[ 0] =  1, SCALES
    case 1:
      menu[ 1] = getInput( scaleSM1Size, scaleSM1LCD, 0, 0);
      menu[ 2] = getInput( SM2Size, ((keysig==0)?notesSM2LCD1:notesSM2LCD1t), 1, 0);
      break;
      
    //menu[ 0] =  2, CAPO
//    case 2:
//      menu[ 1] = getInput( capoSM1Size, capoSM1LCD, 0, 0);
//      break;
      
    //menu[ 0] =  3, Song Maker 
//    case 3:
    case 2:
      //songMaker(  getInput( songmakerSM1Size, songmakerSM1LCD, 0, 0));
      break;

// conf
    case 3:
      if ( getInput(keysigSM1Size, keysigSM1LCD, 0, 0) == 0  ) {
        keysig = 0;
      } else {
        keysig = 1;
      }
      break;

    case 4:
      menu[ 1] = getInput( moreSM1Size, moreSM1LCD, 0, 0);
      break;


    case 5:
      readSongNotes();
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

