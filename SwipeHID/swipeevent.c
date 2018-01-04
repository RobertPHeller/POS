/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Thu Jan 4 17:45:23 2018
 *  Last Modified : <180104.1832>
 *
 *  Description	
 *
 *  Notes
 *
 *  History
 *	
 ****************************************************************************
 *
 *    Copyright (C) 2018  Robert Heller D/B/A Deepwoods Software
 *			51 Locke Hill Road
 *			Wendell, MA 01379-9728
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * 
 *
 ****************************************************************************/

static const char rcsid[] = "@(#) : $Id$";



#include <stdio.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>

static char *keys[] = {
    "RESERVED",
    "ESC",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    "-",
    "=",
    "\b",
    "\t",
    "q",
    "w",
    "e",
    "r",
    "t",
    "y",
    "u",
    "i",
    "o",
    "p",
    "[",
    "]",
    "\n",
    "LEFTCTRL",
    "a",
    "s",
    "d",
    "f",
    "g",
    "h",
    "j",
    "k",
    "l",
    ";",
    "'",
    "`",
    "LEFTSHIFT",
    "\\",
    "z",
    "x",
    "c",
    "v",
    "b",
    "n",
    "m",
    ",",
    ".",
    "/",
    "RIGHTSHIFT",
    "KPASTERISK",
    "LEFTALT",
    " ",
    "CAPSLOCK",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "NUMLOCK",
    "SCROLLLOCK",
    "KP7",
    "KP8",
    "KP9",
    "KPMINUS",
    "KP4",
    "KP5",
    "KP6",
    "KPPLUS",
    "KP1",
    "KP2",
    "KP3",
    "KP0",
    "KPDOT",
    "",
    "ZENKAKUHANKAKU",
    "102ND",
    "F11",
    "F12",
    "RO",
    "KATAKANA",
    "HIRAGANA",
    "HENKAN",
    "KATAKANAHIRAGANA",
    "MUHENKAN",
    "KPJPCOMMA",
    "KPENTER",
    "RIGHTCTRL",
    "KPSLASH",
    "SYSRQ",
    "RIGHTALT",
    "LINEFEED",
    "HOME",
    "UP",
    "PAGEUP",
    "LEFT",
    "RIGHT",
    "END",
    "DOWN",
    "PAGEDOWN",
    "INSERT",
    "DELETE",
    "MACRO",
    "MUTE",
    "VOLUMEDOWN",
    "VOLUMEUP",
    "POWER",
    "KPEQUAL",
    "KPPLUSMINUS",
    "PAUSE",
    "SCALE",
    "KPCOMMA",
    "HANGEUL",
    "HANGUEL",
    "HANJA",
    "YEN",
    "LEFTMETA",
    "RIGHTMETA",
    "COMPOSE",
    "STOP",
    "AGAIN",
    "PROPS",
    "UNDO",
    "FRONT",
    "COPY",
    "OPEN",
    "PASTE",
    "FIND",
    "CUT",
    "HELP",
    "MENU",
    "CALC",
    "SETUP",
    "SLEEP",
    "WAKEUP",
    "FILE",
    "SENDFILE",
    "DELETEFILE",
    "XFER",
    "PROG1",
    "PROG2",
    "WWW",
    "MSDOS",
    "COFFEE",
    "DIRECTION",
    "CYCLEWINDOWS",
    "MAIL",
    "BOOKMARKS",
    "COMPUTER",
    "BACK",
    "FORWARD",
    "CLOSECD",
    "EJECTCD",
    "EJECTCLOSECD",
    "NEXTSONG",
    "PLAYPAUSE",
    "PREVIOUSSONG",
    "STOPCD",
    "RECORD",
    "REWIND",
    "PHONE",
    "ISO",
    "CONFIG",
    "HOMEPAGE",
    "REFRESH",
    "EXIT",
    "MOVE",
    "EDIT",
    "SCROLLUP",
    "SCROLLDOWN",
    "KPLEFTPAREN",
    "KPRIGHTPAREN",
    "NEW",
    "REDO",
    "F13",
    "F14",
    "F15",
    "F16",
    "F17",
    "F18",
    "F19",
    "F20",
    "F21",
    "F22",
    "F23",
    "F24"};

static char *shiftedkeys[] = {
    "RESERVED",
    "ESC",
    "!",
    "@",
    "#",
    "$",
    "%",
    "^",
    "&",
    "*",
    "(",
    ")",
    "_",
    "+",
    "\b",
    "\t",
    "Q",
    "W",
    "E",
    "R",
    "T",
    "Y",
    "U",
    "I",
    "O",
    "P",
    "{",
    "}",
    "\n",
    "LEFTCTRL",
    "A",
    "S",
    "D",
    "F",
    "G",
    "H",
    "J",
    "K",
    "L",
    ":",
    "\"",
    "~",
    "LEFTSHIFT",
    "|",
    "Z",
    "X",
    "C",
    "V",
    "B",
    "N",
    "M",
    "<",
    ">",
    "?"};
   
int main(int argc, char *argv[]) {
    int swipeeventFD;
    int bytes, i, count = 0;
    struct input_event eventBuffer;
    int shift = 0;
         
    swipeeventFD = open("/dev/SWIPEEVENT",O_RDONLY);
    if (swipeeventFD < 0) {
        perror("Could not open /dev/SWIPEEVENT:");
        exit(errno);
    }
    
    while (1) {
        bytes = read(swipeeventFD,&eventBuffer,sizeof(eventBuffer));
        if (bytes < 0) {
            perror("Could not read /dev/SWIPEEVENT:");
            exit(errno);
        }
        /*printf("%4d: %04x, %04x, %d\n",count++,eventBuffer.type,
           eventBuffer.code,eventBuffer.value);*/
        switch(eventBuffer.type) {
        case EV_SYN:
            /*printf("%4d EV_SYN: %d\n",count++,eventBuffer.code);*/
            break;
        case EV_KEY:
            if (eventBuffer.value == 1) {
                if (eventBuffer.code == KEY_LEFTSHIFT || eventBuffer.code == KEY_RIGHTSHIFT) {
                    shift = 1;
                } else {
                    if (shift) printf("%s",shiftedkeys[eventBuffer.code]);
                    else printf("%s",keys[eventBuffer.code]);
                    shift = 0;
                }
            }
            /*printf("%4d EV_KEY: %s, %d\n",count++,keys[eventBuffer.code],eventBuffer.value);*/
            break;
        case EV_MSC:
            /*printf("%4d EV_MSC: %d\n",count++,eventBuffer.code);*/
            break;
        default:
            printf("%4d EV_(Other)\n",count++);
            break;
        }
    }
    close(swipeeventFD);
}

