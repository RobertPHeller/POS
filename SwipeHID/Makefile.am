##-*- makefile -*-############################################################
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sat Dec 23 11:02:08 2017
#  Last Modified : <180105.1532>
#
#  Description	
#
#  Notes
#
#  History
#	
#  $Log$
#
##############################################################################
#
#    Copyright (C) 2017  Robert Heller D/B/A Deepwoods Software
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
##############################################################################


EXTRA_DIST = hid.c hidapi.h swipetest.c swipeevent.c

lib_LTLIBRARIES = libswipereader.la
libswipereader_la_SOURCES = TclSwipeReader.c TclSwipeReader_wrap.c
libswipereader_la_LDFLAGS = -g -version-info 0:0:0
INCLUDES = -I$(top_builddir) -I$(srcdir) -I$(srcdir)/.. $(TCL_INCLUDES)
libswipereader_la_CFLAGS = -g -DUSE_TCL_STUBS $(INCLUDES) -Wall -DDEBUG
libswipereader_la_LIBADD   = $(TCL_STUB_LIB_SPEC)
BUILT_SOURCES = TclSwipeReader_wrap.c
noinst_SCRIPTS = pkgIndex.tcl
EXTRA_DIST += TclSwipeReader.i
CLEANFILES = $(BUILT_SOURCES) pkgIndex.tcl
SWIG_FLAGS = -tcl8 $(INCLUDES)

TclSwipeReader_wrap.c : TclSwipeReader.i $(pkginclude_HEADERS) \
	$(top_builddir)/config.status
	$(SWIG) $(SWIG_FLAGS) $(INCLUDES) -o TclSwipeReader_wrap.c \
	$(srcdir)/TclSwipeReader.i
                
pkgIndex.tcl: libswipereader.la $(top_builddir)/config.status
	echo 'package ifneeded Swipereader 1.0.0 [list load [file join $$dir libswipereader[info sharedlibextension]]]' > pkgIndex.tcl

        
