##-*- makefile -*-############################################################
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sat Dec 23 10:26:40 2017
#  Last Modified : <180104.2224>
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

ACLOCAL_AMFLAGS = -I m4


SUBDIRS = BuildData BuildScripts Doc Scripts SwipeHID tls1.6.7

EXTRA_DIST = bootstrap

bin_SCRIPTS = POS$(EXEEXT)

CLEANFILES = POS$(EXEEXT) POS.kit

TCLKIT = $(top_builddir)/BuildData/tclkit
BUILT_SOURCES = $(TCLKIT)
SDX = $(top_srcdir)/BuildScripts/sdx.kit
AddKitDir = $(top_srcdir)/BuildScripts/AddKitDir.kit
AddKitFile = $(top_srcdir)/BuildScripts/AddKitFile.kit
MakePkgIndex = $(top_srcdir)/BuildScripts/MakePkgIndex.kit

POSScripts = Scripts/IconsAndImages.tcl Scripts/mainwindow.tcl \
	     Scripts/panedw.tcl Scripts/ParseXML.tcl \
	     Scripts/ReadConfiguration.tcl Scripts/snitbuttonbox.tcl \
	     Scripts/snitdialog.tcl Scripts/snitHTMLHelp.tcl \
	     Scripts/snitLFs.tcl Scripts/snitlistbox.tcl \
	     Scripts/snitmainframe.tcl Scripts/snitpagesmanager.tcl \
	     Scripts/snitrotext.tcl Scripts/snitscrollableframe.tcl \
	     Scripts/snitscrollw.tcl Scripts/snitStdMenuBar.tcl \
	     Scripts/splash.tcl Scripts/close.gif Scripts/DeepwoodsBanner.gif \
	     Scripts/new.gif Scripts/open.gif Scripts/print.gif \
	     Scripts/save.gif Scripts/openfold.png Scripts/palette.png \
	     Scripts/gray50.xbm Scripts/info.xbm Scripts/questhead.xbm \
	     Scripts/unknown.xpm Scripts/gettext.tcl Scripts/DynamicHelp.tcl \
	     Scripts/ParseXML.tcl Scripts/ReadConfiguration.tcl \
	     Scripts/Paypal.tcl Scripts/Swipe.tcl Scripts/receiptPrinter.tcl \
	     Scripts/largeHeader.png Scripts/SnitReceiptPrinter.tcl

POS$(EXEEXT) : Scripts/POS.tcl $(POSScripts) \
		tls1.6.7/libtls1.6.7.so tls1.6.7/pkgIndex.tcl
	-rm -rf POS.vfs POS.kit
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit qwrap \
		$(srcdir)/Scripts/POS.tcl
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit unwrap \
		POS.kit
	-rm -rf POS.kit
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit POS \
		lib $(SNITLIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit POS \
		lib $(URILIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit POS \
		lib $(JSONLIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit POS \
		lib $(BASE64LIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit \
		-srcdir $(srcdir)/tls1.6.7 POS lib/tls1.6.7 \
		tls1.6.7/libtls1.6.7.so tls1.6.7/pkgIndex.tcl tls1.6.7/tls.tcl
	$(UNZIP) -qq -d POS.vfs/lib $(top_srcdir)/BuildData/$(TCLXML_ZIP)
	$(UNZIP) -qq -d POS.vfs/lib $(top_srcdir)/BuildData/$(IMG_ZIP)
	$(UNZIP) -qq -d POS.vfs/lib $(top_srcdir)/BuildData/pdf4tcl05.zip
	$(UNZIP) -qq -d POS.vfs/lib $(top_srcdir)/BuildData/$(SQLITE3_ZIP)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
	                POS lib/Common $(POSScripts)
	$(TCLKIT) $(top_srcdir)/BuildScripts/MakePkgIndex.kit \
                        POS Common
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit wrap \
	                POS$(EXEEXT) \
	          -runtime $(top_srcdir)/BuildData/$(TCLKITRUN)
	-rm -rf POS.vfs

		
tls1.6.7/libtls1.6.7.so tls1.6.7/pkgIndex.tcl : FORCE
	$(MAKE) -C tls1.6.7
	
FORCE:
