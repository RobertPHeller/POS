/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Thu Jan 4 15:50:06 2018
 *  Last Modified : <180104.1629>
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
#include "hidapi.h"

int main(int argc, char *argv[]) {
    hid_device *swipedev;
    unsigned char buffer[256];
    int bytes, i, count = 0;
    
    swipedev = hid_open_path("/dev/SWIPE");
    if (swipedev == NULL) {
        perror("Could not open /dev/SWIPE:");
        exit(errno);
    }
    while (1) {
        bytes = hid_read(swipedev,buffer,sizeof(buffer));
        if (bytes < 0) {
            perror("Could not read /dev/SWIPE:");
            exit(errno);
        }
        printf ("%4d: (%d bytes)\n", count++, bytes);
        for (i = 0; i < bytes; i++) {
            if ((i % 16) == 0) {
                printf("\n\t%04x: ",i);
            }
            printf("%02x ",buffer[i]);
            if (isprint(buffer[i])) {
                printf("(%c) ",buffer[i]);
            } else {
                printf("( ) ");
            }
        }
        printf("\n");
    }
    hid_close(swipedev);
    hid_exit();
}
