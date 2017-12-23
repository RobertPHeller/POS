#* 
#* ------------------------------------------------------------------
#* ax_tcl_libraries.m4 - Checks for Tcl Libraries
#* Created by Robert Heller on Sat Mar  2 15:25:28 2013
#* ------------------------------------------------------------------
#* Modification History: $Log: headerfile.text,v $
#* Modification History: Revision 1.1  2002/07/28 14:03:50  heller
#* Modification History: Add it copyright notice headers
#* Modification History:
#* ------------------------------------------------------------------
#* Contents:
#* ------------------------------------------------------------------
#*  
#*     Generic Project
#*     Copyright (C) 2010  Robert Heller D/B/A Deepwoods Software
#* 			51 Locke Hill Road
#* 			Wendell, MA 01379-9728
#* 
#*     This program is free software; you can redistribute it and/or modify
#*     it under the terms of the GNU General Public License as published by
#*     the Free Software Foundation; either version 2 of the License, or
#*     (at your option) any later version.
#* 
#*     This program is distributed in the hope that it will be useful,
#*     but WITHOUT ANY WARRANTY; without even the implied warranty of
#*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#*     GNU General Public License for more details.
#* 
#*     You should have received a copy of the GNU General Public License
#*     along with this program; if not, write to the Free Software
#*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#* 
#*  
#* 

AC_DEFUN([AX_SNIT],[
AC_MSG_CHECKING(snit dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/snit* ${dir}/tcllib*/snit*"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      SNITLIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(snitlib, [  --with-snitlib=DIR          use snit from DIR], SNITLIB=$withval,)
if test x$SNITLIB != x -a -d $SNITLIB; then
   AC_MSG_RESULT([using snit library in $SNITLIB])
else
   AC_MSG_ERROR(Snit library directory not found)
fi
AC_SUBST(SNITLIB)
])

AC_DEFUN([AX_JSON],[
AC_MSG_CHECKING(json dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/json* ${dir}/tcllib*/json*"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      JSONLIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(jsonlib, [  --with-jsonlib=DIR          use json from DIR], JSONLIB=$withval,)
if test x$JSONLIB != x -a -d $JSONLIB; then
   AC_MSG_RESULT([using json library in $JSONLIB])
else
   AC_MSG_ERROR(Json library directory not found)
fi
AC_SUBST(JSONLIB)
])

AC_DEFUN([AX_SHA1],[
AC_MSG_CHECKING(sha1 dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/sha1* ${dir}/tcllib*/sha1*"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      SHA1LIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(sha1lib, [  --with-sha1lib=DIR          use sha1 from DIR], SHA1LIB=$withval,)
if test x$SHA1LIB != x -a -d $SHA1LIB; then
   AC_MSG_RESULT([using sha1 library in $SHA1LIB])
else
   AC_MSG_ERROR(Sha1 library directory not found)
fi
AC_SUBST(SHA1LIB)
])

AC_DEFUN([AX_MD5],[
AC_MSG_CHECKING(md5 dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/md5 ${dir}/tcllib*/md5"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      MD5LIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(md5lib, [  --with-md5lib=DIR          use md5 from DIR], MD5LIB=$withval,)
if test x$MD5LIB != x -a -d $MD5LIB; then
   AC_MSG_RESULT([using md5 library in $MD5LIB])
else
   AC_MSG_ERROR(Md5 library directory not found)
fi
AC_SUBST(MD5LIB)
])

AC_DEFUN([AX_BASE64],[
AC_MSG_CHECKING(base64 dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/base64* ${dir}/tcllib*/base64*"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      BASE64LIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(base64lib, [  --with-base64lib=DIR          use base64 from DIR], BASE64LIB=$withval,)
if test x$BASE64LIB != x -a -d $BASE64LIB; then
   AC_MSG_RESULT([using base64 library in $BASE64LIB])
else
   AC_MSG_ERROR(Base64 library directory not found)
fi
AC_SUBST(BASE64LIB)
])


AC_DEFUN([AX_URI],[
AC_MSG_CHECKING(uri dir)
searchdirs=`echo 'puts $auto_path'|${TCLSH_PROG}`
for dir in $searchdirs ; do
  dirs="${dir}/uri* ${dir}/tcllib*/uri*"
  for i in $dirs ; do
    if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
      URILIB=`cd $i; pwd`
    fi
  done
done
AC_ARG_WITH(urilib, [  --with-urilib=DIR          use uri from DIR], URILIB=$withval,)
if test x$URILIB != x -a -d $URILIB; then
   AC_MSG_RESULT([using uri library in $URILIB])
else
   AC_MSG_ERROR(Uri library directory not found)
fi
AC_SUBST(URILIB)
])

