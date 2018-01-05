#*****************************************************************************
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Fri Jan 5 08:04:00 2018
#  Last Modified : <180105.0812>
#
#  Description	
#
#  Notes
#
#  History
#	
#*****************************************************************************
#
#    Copyright (C) 2018  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# 
#
#*****************************************************************************

package require snit

snit::type DWSLogo {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no
    
    typevariable width 312
    typevariable height 88
    typevariable bits {
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFE  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xBF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0x7F  0xFE  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0x7F  0xFD  0xFF  
        0xFF  0x7B  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xEF  0xFF  0x5D  0xFF  0xFF  0x5F  
        0xFE  0xFF  0xFF  0xFF  0x97  0xFA  0xFF  0x9F  0x10  0xFA  0xFF  0xFF  
        0x3F  0xF0  0xFF  0x0F  0x00  0xE0  0xFF  0xFF  0x05  0x00  0x00  0x7F  
        0x01  0x00  0xC0  0x0F  0x00  0xFC  0x7F  0x00  0xFE  0x03  0xFF  0x00  
        0xF8  0x7F  0x00  0xC0  0xFF  0xFF  0x7F  0x00  0xC0  0xFF  0x0F  0x00  
        0x80  0xFF  0xFF  0x1F  0x00  0xFE  0x1F  0x00  0x00  0xFF  0x7F  0x00  
        0x00  0x00  0x3F  0x00  0x00  0x80  0x0F  0x00  0xE0  0x1F  0x00  0xFE  
        0x01  0xFE  0x00  0xF8  0x1F  0x00  0x00  0xFF  0xFF  0x1F  0x00  0x00  
        0xFF  0x0F  0x00  0x00  0xFE  0xFF  0x0F  0x00  0xF8  0x0F  0x00  0x00  
        0xFC  0x7F  0x00  0x00  0x00  0x1E  0x00  0x00  0x80  0x0F  0x00  0x00  
        0x3F  0x00  0xFE  0x01  0xFE  0x00  0xF8  0x07  0x00  0x00  0xFE  0xFF  
        0x07  0x00  0x00  0xFE  0x0F  0x00  0x00  0xFC  0xFF  0x0F  0x00  0xFC  
        0x0F  0x00  0x00  0xF0  0x7F  0x00  0x00  0x00  0x3E  0x00  0x00  0x80  
        0x0F  0x00  0x00  0x3E  0x00  0xFC  0x00  0xFE  0x00  0xF8  0x07  0x00  
        0x00  0xF8  0xFF  0x03  0x00  0x00  0xFC  0x0F  0x00  0x00  0xF0  0xFF  
        0x07  0x00  0xFC  0x1F  0x00  0x00  0xE0  0x7F  0x00  0x00  0x00  0x1E  
        0x00  0x00  0x80  0x0F  0x00  0x00  0x3C  0x00  0xFC  0x00  0x7C  0x00  
        0xF8  0x01  0x00  0x00  0xF8  0xFF  0x01  0x00  0x00  0xF0  0x0F  0x20  
        0x00  0xE0  0xFF  0x03  0x00  0xFE  0x0F  0xFC  0x0B  0xC0  0x7F  0x60  
        0xDF  0x0B  0x1C  0xF8  0xDF  0x83  0x0F  0xFE  0x01  0x38  0x00  0xFC  
        0x00  0x7C  0x00  0xF8  0x00  0xFC  0x01  0xF0  0xFF  0x00  0xFC  0x01  
        0xF0  0x0F  0xBE  0x0F  0xC0  0xFF  0x03  0x02  0xFF  0x0F  0x04  0x3E  
        0x80  0x7F  0xF0  0xB5  0x16  0x1E  0x9C  0x34  0x04  0x0F  0x12  0x0F  
        0x78  0x10  0x7C  0x00  0x7C  0x10  0xFC  0x00  0x27  0x0F  0xE0  0xFF  
        0x00  0x17  0x0E  0xE0  0x0F  0x00  0x38  0x80  0xFF  0x01  0x03  0xFF  
        0x0F  0x04  0xE0  0x80  0x7F  0x10  0x00  0x00  0x1C  0x04  0x00  0x00  
        0x0F  0x02  0x10  0x70  0x10  0xFC  0x20  0x78  0x10  0x7C  0x80  0x01  
        0x38  0xE0  0x7F  0x80  0x01  0x18  0xC0  0x0F  0x04  0xE0  0x80  0xFF  
        0x01  0x81  0xFF  0x0F  0x04  0xC0  0x01  0x7F  0x10  0x00  0x00  0x1C  
        0x04  0x00  0x00  0x0F  0x02  0x60  0x70  0x10  0x78  0x20  0x78  0x10  
        0x7C  0xC0  0x00  0x60  0xC0  0x3F  0xC0  0x00  0x60  0xC0  0x0F  0x02  
        0x80  0x01  0xFF  0x80  0x81  0xFF  0x1F  0x04  0x00  0x03  0x7E  0x10  
        0x00  0x00  0x1C  0x04  0x00  0x00  0x0F  0x02  0xC0  0x60  0x20  0x78  
        0x30  0x78  0x00  0x3C  0x60  0x00  0x40  0x80  0x3F  0x60  0x00  0xC0  
        0x80  0x0F  0x00  0x00  0x01  0xFE  0xC0  0xC0  0xFF  0x0F  0x04  0x00  
        0x06  0x7E  0x10  0x00  0x00  0x1C  0x04  0x00  0x00  0x0F  0x00  0x80  
        0xE0  0x20  0x78  0x70  0x38  0x08  0x1C  0x30  0x00  0x80  0x81  0x1F  
        0x30  0x00  0x80  0x81  0x0F  0x02  0x00  0x06  0xFE  0x40  0xE0  0xDF  
        0x1F  0x04  0x00  0x0C  0x7C  0x10  0x00  0x00  0x1C  0x04  0x00  0x00  
        0x0E  0x82  0x03  0xC1  0x20  0x38  0x48  0x30  0x00  0x1C  0x18  0x00  
        0x00  0x01  0x1F  0x18  0x00  0x00  0x03  0x0F  0x04  0x00  0x04  0xFC  
        0x40  0xE0  0xFF  0x0F  0x04  0x01  0x08  0x7C  0x10  0xFC  0x07  0x18  
        0x04  0xFF  0x05  0x0F  0x82  0x07  0xC1  0x40  0x38  0xC0  0x30  0x08  
        0x1E  0x08  0xF0  0x00  0x02  0x1F  0x08  0xF0  0x01  0x02  0x0F  0x02  
        0x03  0x08  0x78  0x40  0xE0  0xFF  0x0F  0x04  0x0F  0x10  0x78  0x10  
        0xFC  0xFF  0x1F  0x84  0xFF  0xFF  0x0F  0x82  0x0F  0xC1  0x41  0x38  
        0x88  0x30  0x08  0x0E  0x0C  0xFC  0x07  0x06  0x0F  0x0C  0xFC  0x03  
        0x06  0x0E  0x00  0x0F  0x18  0x78  0x40  0xE0  0xFF  0x0F  0x04  0x1F  
        0x30  0x78  0x10  0xFE  0xFF  0x1F  0x04  0xFF  0xFF  0x0F  0xC2  0x0F  
        0x82  0x41  0x10  0x84  0x20  0x08  0x0E  0x04  0xFE  0x0F  0x04  0x0E  
        0x04  0xFE  0x0F  0x04  0x0E  0x02  0x1F  0x10  0x70  0x40  0xE0  0xFF  
        0x1F  0x04  0x3F  0x20  0x70  0x10  0xFC  0xFF  0x1F  0x04  0xFF  0xFF  
        0x0F  0xC2  0x0F  0xC2  0x81  0x10  0x84  0x00  0x08  0x0E  0x04  0xFF  
        0x1F  0x0C  0x0E  0x04  0xFF  0x1F  0x04  0x0E  0x84  0x2F  0x20  0x70  
        0x40  0xE0  0xFF  0x0F  0x04  0x7F  0x60  0x70  0x10  0xFC  0xFF  0x1F  
        0x04  0xFF  0xFF  0x0F  0x82  0x1F  0x82  0x81  0x00  0x04  0x01  0x04  
        0x0E  0x82  0xFF  0x1F  0x04  0x0E  0x06  0xFF  0x1F  0x08  0x0C  0x02  
        0x7F  0x20  0x60  0x40  0xE0  0xFF  0x0F  0x04  0xFF  0x60  0x60  0x10  
        0x40  0xCA  0x1F  0x04  0x40  0xF0  0x0F  0x82  0x0F  0x82  0x83  0x00  
        0x04  0x01  0x04  0x07  0x82  0xFF  0x3F  0x08  0x06  0x82  0xFF  0x3F  
        0x08  0x0E  0x00  0x7F  0x60  0x70  0x40  0xC0  0xFF  0x0F  0x04  0xFF  
        0x40  0x60  0x10  0x00  0x80  0x1F  0x04  0x00  0xE0  0x0F  0x82  0x0F  
        0x82  0x83  0x00  0x02  0x01  0x04  0x07  0xC2  0xFF  0x3F  0x08  0x06  
        0x82  0xFF  0x3F  0x08  0x0C  0x82  0xFF  0x40  0xE0  0xC0  0xC0  0xFF  
        0x1F  0x04  0xFF  0x41  0x60  0x10  0x00  0x80  0x1F  0x0C  0x00  0xE0  
        0x0F  0x82  0x07  0xC2  0x03  0x00  0x02  0x02  0x04  0x07  0xC3  0xFF  
        0x3F  0x18  0x06  0xC2  0xFF  0x3F  0x08  0x0E  0x04  0xFF  0x40  0xE0  
        0x80  0xC0  0xFF  0x0F  0x04  0xFF  0x41  0x60  0x10  0x00  0x80  0x1F  
        0x04  0x00  0xE0  0x0F  0x02  0x00  0xC1  0x03  0x01  0x02  0x02  0x06  
        0x07  0xC1  0xFF  0x3F  0x08  0x06  0xC1  0xFF  0x7F  0x18  0x0E  0x00  
        0xFF  0x41  0xE0  0x81  0x80  0xFF  0x0F  0x04  0xFF  0xC1  0x60  0x10  
        0x00  0x00  0x1F  0x04  0x00  0xC0  0x0F  0x02  0x00  0xC1  0x07  0x01  
        0x02  0x02  0x00  0x07  0xC3  0xFF  0x7F  0x18  0x06  0xC2  0xFF  0x7F  
        0x10  0x0C  0x82  0xFF  0x41  0xE0  0x01  0x81  0xFF  0x0F  0x04  0xFF  
        0x01  0x60  0x70  0x55  0x02  0x1F  0x9C  0x5A  0xC1  0x0F  0x02  0xC0  
        0xC0  0x07  0x01  0x01  0x00  0x86  0x07  0xC0  0xFF  0x7F  0x00  0x06  
        0xC1  0xFF  0x7F  0x10  0x0E  0x04  0xFF  0x40  0xE0  0x03  0x81  0xFF  
        0x0F  0x00  0xFF  0x81  0x40  0x70  0xA2  0x05  0x1F  0x5C  0xC5  0xC0  
        0x0F  0x02  0xE0  0xE0  0x07  0x02  0x01  0x04  0x82  0x07  0xC3  0xFF  
        0x3F  0x08  0x06  0xC1  0xFF  0x7F  0x00  0x0E  0x04  0xFF  0x41  0xE0  
        0x07  0x02  0xFF  0x0F  0x04  0xFF  0xC1  0x60  0x10  0x00  0x00  0x1F  
        0x04  0x00  0xC0  0x0F  0x02  0x30  0xE0  0x0F  0x02  0x01  0x04  0x82  
        0x07  0xC0  0xFF  0x7F  0x00  0x06  0xC2  0xFF  0x3F  0x18  0x06  0x80  
        0xFF  0x40  0xE0  0x07  0x02  0xFD  0x0F  0x06  0xFF  0x41  0x60  0x10  
        0x00  0x00  0x1E  0x04  0x00  0x80  0x0F  0x46  0x0F  0xE0  0x0F  0x82  
        0x00  0x00  0x82  0x0F  0x81  0xFF  0x7F  0x18  0x0E  0x83  0xFF  0x7F  
        0x10  0x0E  0x02  0xFF  0x40  0xE0  0x07  0x02  0xFE  0x1F  0x04  0xFF  
        0x40  0x60  0x30  0x00  0x00  0x1F  0x0C  0x00  0xC0  0x0F  0xBE  0x00  
        0xF0  0x0F  0x82  0x20  0x08  0x81  0x07  0x82  0xFF  0x3F  0x08  0x06  
        0x82  0xFF  0x3F  0x08  0x0E  0x04  0x7F  0x40  0xE0  0x07  0x04  0xFE  
        0x0F  0x06  0x7F  0x40  0x60  0x10  0x00  0x00  0x1F  0x04  0x00  0x80  
        0x07  0x02  0x00  0xFC  0x0F  0x80  0x60  0x08  0x81  0x0F  0x02  0xFF  
        0x3F  0x08  0x0E  0x02  0xFF  0x3F  0x08  0x0E  0x04  0x7F  0x20  0xE0  
        0x0F  0x04  0xFC  0x0F  0x00  0x7F  0x60  0x60  0x10  0x00  0x00  0x1F  
        0x04  0x00  0xC0  0x0F  0x02  0x00  0xFC  0x1F  0x84  0x70  0x00  0xC1  
        0x0F  0x06  0xFF  0x1F  0x08  0x0F  0x02  0xFF  0x1F  0x08  0x07  0x02  
        0x3F  0x20  0xF0  0x0F  0x04  0xFC  0x0F  0x04  0x3F  0x20  0x70  0x10  
        0xFC  0xFF  0x1F  0x04  0xFF  0xFF  0x0F  0x02  0x00  0xFF  0x1F  0x84  
        0x30  0x10  0xC1  0x0F  0x04  0xFE  0x0F  0x0C  0x0F  0x06  0xFE  0x0F  
        0x08  0x0E  0x84  0x1F  0x30  0xF0  0x0F  0x08  0xFC  0x0F  0x04  0x1F  
        0x30  0x70  0x10  0xFC  0xFF  0x1F  0x0C  0xFF  0xFF  0x0F  0x00  0xC0  
        0xFF  0x1F  0x48  0xF0  0x10  0xC1  0x0F  0x04  0xFC  0x07  0x04  0x0F  
        0x04  0xFC  0x07  0x04  0x0F  0x02  0x0F  0x10  0xF0  0x0F  0x08  0xFC  
        0x0F  0x06  0x0F  0x10  0x70  0x10  0xFE  0xFF  0x1F  0x04  0xFF  0xFF  
        0x0F  0x02  0xFF  0xFF  0x3F  0x48  0xF0  0x00  0xC0  0x1F  0x0C  0xF8  
        0x03  0x06  0x1F  0x08  0xF0  0x03  0x06  0x0F  0x02  0x03  0x08  0xF8  
        0x0F  0x08  0xFC  0x0F  0x04  0x02  0x18  0x78  0x10  0xFC  0xFF  0x1F  
        0x04  0xFF  0xFF  0x0F  0x02  0xFF  0xFF  0x3F  0x48  0xF0  0xA0  0xE0  
        0x1F  0x08  0x40  0x00  0x02  0x1F  0x08  0x60  0x00  0x02  0x0F  0x00  
        0x00  0x08  0xF8  0x0F  0x08  0xFC  0x0F  0x04  0x00  0x0C  0x78  0x10  
        0xFC  0xFF  0x1F  0x04  0xFF  0xFF  0x0F  0x00  0xFF  0xFF  0x3F  0x28  
        0xF8  0xA0  0xE0  0x1F  0x10  0x00  0x00  0x81  0x1F  0x10  0x00  0x00  
        0x01  0x07  0x02  0x00  0x04  0xF8  0x0F  0x08  0xFC  0x0F  0x04  0x00  
        0x04  0x7C  0x10  0xFC  0xFF  0x1F  0x04  0xFE  0x7D  0x07  0x82  0xFF  
        0xFF  0x3F  0x30  0xF8  0xE1  0xE0  0x3F  0x30  0x00  0x80  0x81  0x3F  
        0x30  0x00  0x80  0x81  0x0F  0x04  0x00  0x02  0xFC  0x0F  0x08  0xFC  
        0x0F  0x04  0x00  0x03  0x7C  0x10  0x00  0x00  0x1C  0x04  0x00  0x00  
        0x0F  0x82  0xFF  0xFF  0x7F  0x30  0xF8  0xC1  0xE0  0x7F  0x60  0x00  
        0xC0  0x80  0x3F  0x60  0x00  0xC0  0xC0  0x0F  0x02  0x00  0x01  0xFE  
        0x07  0x04  0xFC  0x0F  0x06  0x80  0x01  0x7E  0x10  0x00  0x00  0x1C  
        0x08  0x00  0x00  0x07  0x80  0xFF  0xFF  0x7F  0x10  0xFC  0x81  0xF0  
        0x7F  0xC0  0x01  0x30  0xC0  0x7F  0xC0  0x01  0x70  0xC0  0x07  0x00  
        0xC0  0x01  0xFE  0x07  0x04  0xFE  0x0F  0x04  0x40  0x00  0x7F  0x10  
        0x00  0x00  0x1C  0x04  0x00  0x00  0x0E  0x82  0xFF  0xFF  0x7F  0x00  
        0xFC  0x01  0xE0  0xFF  0x00  0x07  0x1C  0xE0  0xFF  0x00  0x07  0x1C  
        0xE0  0x0F  0x06  0x20  0x00  0xFF  0x03  0x02  0xFE  0x0F  0x5C  0x3D  
        0x00  0x7F  0x10  0x00  0x00  0x1C  0x04  0x00  0x00  0x0F  0x82  0xFF  
        0xFF  0x7F  0x00  0xFC  0x03  0xF0  0xFF  0x01  0xFC  0x07  0xF0  0xFF  
        0x01  0xFC  0x07  0xE0  0x07  0xFC  0x0F  0x80  0xFF  0x01  0x02  0xFF  
        0x0F  0xA0  0x02  0x80  0x7F  0x10  0x00  0x00  0x1C  0x08  0x00  0x00  
        0x0F  0x82  0xFF  0xFF  0x7F  0x00  0xFC  0x03  0xF0  0xFF  0x01  0x60  
        0x00  0xF0  0xFF  0x01  0xA0  0x00  0xF0  0x0F  0x10  0x00  0x80  0xFF  
        0x01  0x00  0xFF  0x0F  0x00  0x00  0xC0  0x7F  0xF0  0xFF  0x0F  0x1E  
        0xF8  0xF7  0x07  0x07  0x80  0xFF  0xFF  0xFF  0x00  0xFE  0x03  0xF0  
        0xFF  0x03  0x00  0x00  0xF8  0xFF  0x03  0x00  0x00  0xF8  0x07  0x00  
        0x00  0xE0  0xFF  0x00  0x80  0xFF  0x0F  0x00  0x00  0xE0  0x7F  0xE0  
        0x9B  0x02  0x1E  0xD8  0x4E  0x80  0x0F  0x80  0xFF  0xFF  0xFF  0x00  
        0xFE  0x07  0xF0  0xFF  0x07  0x00  0x00  0xFC  0xFF  0x07  0x00  0x00  
        0xFC  0x0F  0x00  0x00  0xF0  0xFF  0x00  0x80  0xFF  0x0F  0x00  0x00  
        0xF0  0x7F  0x00  0x00  0x00  0x3E  0x00  0x00  0x80  0x07  0x80  0xFF  
        0xFF  0xFF  0x00  0xFE  0x07  0xF8  0xFF  0x0F  0x00  0x00  0xFE  0xFF  
        0x0F  0x00  0x00  0xFE  0x07  0x00  0x00  0xF8  0xFF  0x00  0x80  0xFF  
        0x0F  0x00  0x00  0xF8  0x7F  0x00  0x00  0x00  0x1E  0x00  0x00  0x80  
        0x0F  0x80  0xFF  0xFF  0xFF  0x00  0xFE  0x0F  0xF8  0xFF  0x3F  0x00  
        0x00  0xFF  0xFF  0x3F  0x00  0x00  0xFF  0x07  0x00  0x00  0xFC  0xFF  
        0x03  0xE0  0xFF  0x0F  0x00  0x00  0xFE  0x7F  0x00  0x00  0x00  0x3F  
        0x00  0x00  0xC0  0x07  0x00  0xFF  0xFF  0xFF  0x01  0xFF  0x0F  0xF8  
        0xFF  0xFF  0x00  0xC0  0xFF  0xFF  0xFF  0x01  0xC0  0xFF  0x0F  0x00  
        0x00  0xFF  0xFF  0x0F  0xE0  0xFF  0xFF  0x02  0xC0  0xFF  0xFF  0x00  
        0x00  0x00  0x3F  0x00  0x00  0xC0  0xFF  0x9A  0xFF  0xFF  0xFF  0xC7  
        0xFF  0xBF  0xFF  0xFF  0xFF  0x1F  0xF1  0xFF  0xFF  0xFF  0x5F  0xF8  
        0xFF  0xFF  0x4E  0xE8  0xFF  0xFF  0x7F  0xF0  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xDF  0xFF  0xFF  0xFD  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xDF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0x1F  0xFE  0xFF  0xFF  0xBF  
        0xFB  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFD  0x7F  0xA6  0xFF  0xDF  0x95  0xFF  0xFF  0xFF  
        0xFF  0x07  0xF8  0xFF  0xFF  0xE6  0x4C  0x18  0xFF  0xFF  0x0F  0x00  
        0xFF  0xFF  0x00  0x00  0xFE  0x7F  0x00  0x00  0x00  0xC0  0x0F  0x00  
        0x00  0x00  0x30  0x00  0xFC  0x0F  0xF0  0x0F  0x00  0xFC  0x0F  0x00  
        0xF8  0xFF  0x2F  0x00  0x00  0x00  0x7F  0x07  0x00  0x00  0x00  0xFE  
        0xFF  0x03  0x00  0xF8  0x0F  0x00  0x00  0xF0  0x7F  0x00  0x00  0x00  
        0xC0  0x07  0x00  0x00  0x00  0x30  0x00  0xF8  0x07  0xE0  0x0F  0x00  
        0xFE  0x07  0x00  0xF8  0xFF  0x0F  0x00  0x00  0x00  0xFC  0x07  0x00  
        0x00  0x00  0xFE  0xFF  0x01  0x00  0xFE  0x03  0x00  0x00  0x80  0x7F  
        0x00  0x00  0x00  0xC0  0x07  0x00  0x00  0x00  0x38  0x00  0xF0  0x07  
        0xE0  0x0F  0x00  0xFE  0x07  0x00  0xF0  0xFF  0x0F  0x80  0x6D  0x00  
        0xF0  0x07  0x00  0x00  0x00  0xFE  0xFF  0x00  0x01  0xFF  0x00  0xF8  
        0x0F  0x00  0x7F  0x00  0x04  0x01  0xC0  0x07  0xFF  0xFF  0x1F  0x38  
        0x20  0xF0  0x03  0xC0  0x0F  0x04  0xFE  0x03  0x1A  0xF0  0xFF  0x0F  
        0x3C  0x00  0x0E  0xE0  0x07  0x56  0x99  0x05  0xFC  0x7F  0x80  0x80  
        0x7F  0x00  0x07  0xE0  0x00  0x7E  0x40  0x10  0x00  0x80  0x03  0x00  
        0x0E  0x00  0x78  0x20  0xF0  0x83  0xC1  0x07  0x02  0xFF  0x01  0x23  
        0xE0  0xFF  0x0F  0x08  0x00  0x30  0xC0  0x07  0x02  0x00  0x00  0xFC  
        0x3F  0x60  0xC0  0x3F  0xC0  0x00  0x00  0x03  0x7C  0x40  0x00  0x00  
        0x80  0x03  0x00  0x04  0x00  0xFC  0x40  0xE0  0x81  0x81  0x07  0x02  
        0xFF  0x01  0x61  0xC0  0xFF  0x0F  0x04  0x50  0x40  0xC0  0x07  0x02  
        0x00  0x00  0xFC  0x1F  0x20  0xE0  0x1F  0x30  0x00  0x00  0x0C  0x70  
        0x60  0x00  0x00  0x80  0x01  0x00  0x06  0x00  0xFC  0x40  0xE0  0x41  
        0x02  0x07  0x02  0xFF  0x80  0x40  0xC0  0xFF  0x0F  0x0C  0xFC  0x81  
        0x80  0x07  0x02  0x00  0x00  0xF8  0x1F  0x20  0xE0  0x0F  0x18  0x80  
        0x03  0x30  0x70  0x00  0x00  0x0A  0x80  0x81  0x05  0x04  0x00  0xFE  
        0x80  0xE0  0x40  0x06  0x07  0x01  0xFF  0xC0  0x40  0x80  0xFF  0x0F  
        0x08  0xFC  0x81  0x80  0x07  0x02  0x7E  0xAF  0xFC  0x0F  0x30  0xF0  
        0x0F  0x0C  0xFC  0x1F  0x20  0x60  0x60  0xF0  0xFF  0xBF  0xFF  0x07  
        0x0E  0x7E  0xFE  0x81  0x60  0x20  0x04  0x02  0x81  0x7F  0x40  0x80  
        0x80  0xFF  0x0F  0x04  0xFE  0x83  0x81  0x07  0x82  0xFF  0xFF  0xFF  
        0x1F  0x30  0xF0  0x07  0x04  0xFE  0xFF  0x40  0x60  0x20  0xF0  0xFF  
        0xFF  0xFF  0x0F  0x06  0xFE  0xFF  0x01  0x01  0x20  0x08  0x00  0x81  
        0x7F  0x40  0x00  0x01  0xFF  0x0F  0x04  0xFC  0x01  0x81  0x07  0x02  
        0xFF  0xEF  0xFF  0x1F  0x20  0xE0  0x07  0x06  0xFF  0xFF  0xC0  0x40  
        0x40  0xE0  0xFF  0xFF  0xFF  0x07  0x04  0xFE  0xFF  0x03  0x01  0x10  
        0x18  0x80  0xC0  0x3F  0x30  0x00  0x01  0xFE  0x0F  0x04  0xFC  0x81  
        0x80  0x07  0x02  0x00  0xC0  0xFF  0x3F  0x60  0xC0  0x07  0x82  0xFF  
        0xFF  0x81  0x40  0x40  0xE0  0xFF  0xFF  0xFF  0x0F  0x0E  0xFE  0xFF  
        0x07  0x02  0x10  0x10  0x80  0xC0  0x1F  0x10  0x00  0x02  0xFE  0x0F  
        0x04  0x7C  0xC0  0x80  0x07  0x02  0x00  0x80  0xFF  0x3F  0x40  0xC0  
        0x03  0x83  0xFF  0xFF  0x83  0xC0  0x20  0x00  0x08  0xF0  0xFF  0x0F  
        0x06  0xFE  0xFF  0x07  0x02  0x18  0x00  0xC0  0xC0  0x0F  0x18  0x04  
        0x04  0xFE  0x0F  0x0C  0x00  0x00  0xC0  0x03  0x06  0x00  0x80  0xFF  
        0xFF  0x80  0x80  0x03  0x83  0xFF  0xFF  0x83  0x40  0x00  0x00  0x00  
        0xE0  0xFF  0x07  0x06  0xFE  0xFF  0x0F  0x04  0x08  0x20  0x40  0xE0  
        0x0F  0x0C  0x1E  0x04  0xFC  0x0F  0x04  0x00  0x10  0x70  0x07  0x56  
        0xAA  0x01  0xFF  0xFF  0x80  0x01  0x03  0x81  0xFF  0xFF  0x83  0x61  
        0x60  0x00  0x00  0xE0  0xFF  0x0F  0x04  0xFE  0xFF  0x0F  0x04  0x0C  
        0x40  0x40  0xE0  0x07  0x04  0x1E  0x08  0xF8  0x0F  0x04  0x00  0x04  
        0xF0  0x07  0x06  0x00  0x00  0xFF  0xFF  0x01  0x01  0x03  0x83  0xFF  
        0xFF  0x81  0x60  0xE0  0xDD  0x16  0xE0  0xFF  0x0F  0x06  0xFE  0xFF  
        0x1F  0x08  0x04  0x40  0x60  0xF0  0x07  0x06  0x3F  0x18  0xF8  0x0F  
        0xAC  0xFA  0x00  0xFC  0x07  0x02  0x00  0x00  0xFF  0xFF  0x03  0x02  
        0x06  0x02  0xFF  0xFF  0x81  0xE0  0x60  0x00  0x00  0xE0  0xFF  0x07  
        0x06  0xFF  0xFF  0x1F  0x08  0x02  0x83  0x20  0xF0  0x03  0x02  0x3E  
        0x10  0xF0  0x0F  0x04  0x00  0x01  0xFF  0x07  0x02  0x00  0x00  0xFF  
        0xFF  0x07  0x06  0x04  0x06  0xFE  0x7F  0xC0  0x60  0x20  0x00  0x00  
        0xE0  0xFF  0x0F  0x04  0xFE  0xFF  0x3F  0x10  0x82  0x07  0x20  0xF0  
        0x01  0x01  0x2A  0x20  0xF0  0x0F  0x0C  0x00  0x02  0xFF  0x07  0x02  
        0xBD  0xDB  0xFF  0xFF  0x07  0x04  0x04  0x04  0xF8  0x3F  0x60  0x70  
        0x00  0x00  0x00  0xC0  0xFF  0x07  0x06  0xFE  0xFF  0x3F  0x10  0x82  
        0x07  0x31  0xF8  0x81  0x01  0x00  0x20  0xE0  0x0F  0x04  0x00  0x02  
        0xFA  0x07  0x02  0xFF  0xFE  0xFF  0xFF  0x03  0x04  0x0C  0x08  0xE0  
        0x07  0x20  0x70  0x20  0x00  0x2A  0xE0  0xFF  0x07  0x04  0xFE  0xFF  
        0x7F  0x20  0x81  0x0F  0x12  0xF8  0x80  0x01  0xA2  0x60  0xE0  0x0F  
        0x04  0x0C  0x08  0xFC  0x07  0x02  0xFF  0xFF  0xFF  0xFF  0x03  0x04  
        0x1C  0x30  0x00  0x00  0x18  0x78  0x60  0xE0  0xFF  0xFF  0xFF  0x07  
        0x0E  0xFE  0xFF  0x7F  0xE0  0xC0  0x0F  0x1E  0xF8  0x80  0x95  0x04  
        0xE2  0xC0  0x0F  0x04  0x1C  0x00  0x78  0x07  0x02  0x98  0x5D  0xFE  
        0xFF  0x03  0x04  0x3C  0xC0  0x00  0x00  0x06  0x7C  0x60  0xE0  0xFF  
        0xFF  0xFF  0x07  0x06  0xFE  0xFF  0x7F  0xC0  0xE0  0x0F  0x08  0x7C  
        0x40  0x00  0x00  0x80  0x80  0x0F  0x04  0x7C  0x20  0xF0  0x07  0x06  
        0x00  0x00  0xFC  0xFF  0x01  0x03  0x7E  0x00  0x07  0x80  0x01  0x7C  
        0x00  0xE0  0xFF  0xFF  0xFF  0x07  0x06  0xFE  0xFF  0xFF  0x00  0xE0  
        0x1F  0x08  0x7C  0x20  0x00  0x00  0x00  0x81  0x0F  0x04  0x7E  0x40  
        0xE0  0x07  0x02  0x00  0x00  0xF8  0xFF  0x80  0x01  0xFF  0x00  0xF8  
        0x5F  0x00  0x7F  0x40  0xC0  0xFF  0xFF  0xFF  0x07  0x06  0xFE  0xFF  
        0xFF  0x00  0xF0  0x3F  0x00  0x3E  0x00  0x00  0x00  0x00  0x80  0x0F  
        0x04  0xFE  0x80  0xC0  0x07  0x06  0x00  0x00  0xFC  0x7F  0x00  0x80  
        0xFF  0x03  0x00  0x00  0x80  0x7F  0x00  0xE0  0xFF  0xFF  0xFF  0x07  
        0x00  0xFE  0xFF  0xFF  0x01  0xF0  0x3F  0x00  0x1E  0x00  0xF8  0xFF  
        0x01  0x00  0x07  0x00  0xFE  0x03  0x80  0x07  0x74  0xDD  0x06  0xFC  
        0x1F  0x00  0x80  0xFF  0x0F  0x00  0x00  0xE0  0x7F  0x00  0xC0  0xFF  
        0xFF  0xFF  0x03  0x00  0xFE  0xFF  0xFF  0x01  0xF0  0x7F  0x00  0x1E  
        0x00  0xF8  0xFF  0x03  0x00  0x0F  0x00  0xFE  0x03  0x00  0x07  0x00  
        0x00  0x00  0xFE  0xFF  0x00  0xE0  0xFF  0x7F  0x00  0x00  0xF8  0x7F  
        0x00  0xC0  0xFF  0xFF  0xFF  0x03  0x00  0xFE  0xFF  0xFF  0x03  0xF8  
        0xFF  0x00  0x1F  0x00  0xFC  0xFF  0x03  0x00  0x06  0x00  0xFE  0x0F  
        0x00  0x07  0x00  0x00  0x00  0xFF  0xFF  0x0F  0xF0  0xFF  0xFF  0x67  
        0x80  0xFF  0xFF  0x05  0xE0  0xFF  0xFF  0xFF  0x07  0x00  0xFE  0xFF  
        0xFF  0x47  0xFE  0xFF  0xA9  0xBF  0x2A  0xFF  0xFF  0x2F  0xA2  0xDF  
        0x57  0xFF  0x5F  0x21  0xA7  0x22  0x82  0xA1  0xFF  0xFF  0xFF  0xFE  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFD  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
        0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  0xFF  
    }
    typemethod Width {} {return $width}
    typemethod Height {} {return $height}
    typemethod Bits {} {return $bits}
}

package provide DWSLogo 1.0

