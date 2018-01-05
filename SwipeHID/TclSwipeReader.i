/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Fri Jan 5 14:38:30 2018
 *  Last Modified : <180105.1525>
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


%module TclSwipereader
%{
    static const char rcsid[] = "@(#) : $Id$";
    SWIGEXPORT int Tclswipereader_SafeInit(Tcl_Interp *);
    int SwipeReader(Tcl_Interp *interp, const char *swipeevent);
%}


%include typemaps.i


%{
#undef SWIG_name
#define SWIG_name "Tclswipereader"
#undef SWIG_version
#define SWIG_version "1.0.0"
%}

%apply int Tcl_Result { int SwipeReader };

int SwipeReader(Tcl_Interp *interp, const char *swipeevent);


