AC_INIT(POS,0.0,[support@deepsoft.com],POS)
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SUBST(build)
AC_CANONICAL_TARGET
AC_SUBST(target)
AC_CONFIG_SRCDIR(Scripts/POS.tcl)
AM_INIT_AUTOMAKE([-Wno-portability])

AC_CONFIG_MACRO_DIR([m4])
if test "x${prefix}" = "xNONE"; then
    prefix=/usr/local
    fi
    if test "x${exec_prefix}" = "xNONE"; then
        exec_prefix="${prefix}"
        fi
                
BUILD_DIR=`pwd`
TOP_DIR=${BUILD_DIR}

AC_SUBST(TOP_DIR)
AC_SUBST(BUILD_DIR)

srcdir=`dirname $0`
cd $srcdir
SRC_DIR=`pwd`
cd $BUILD_DIR

AC_SUBST(SRC_DIR)
AC_SUBST(target)

m4_pattern_allow(PKG_)

AX_PKG_DOXYGEN(1.6.0, [], [ AC_MSG_ERROR([DOXYGEN 1.6.0 or later is required to build..]) ])


AC_PATH_PROG(PDFLATEX,pdflatex,/bin/true)
AC_PATH_PROG(LATEX,latex,/bin/true)
AC_PATH_PROG(MAKEINDEX,makeindex,/bin/true)
AC_PATH_PROG(BIBTEX,bibtex,/bin/true)

AC_CONFIG_HEADERS([config.h])

TEA_INIT([3.5])
TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG
TEA_PREFIX
TEA_SETUP_COMPILER
TEA_ADD_SOURCES([])
TEA_ADD_HEADERS([])
TEA_ADD_INCLUDES([])
TEA_ADD_LIBS([])
TEA_ADD_CFLAGS([])
TEA_ADD_STUB_SOURCES([])
TEA_ADD_TCL_SOURCES([])
TEA_PUBLIC_TCL_HEADERS
TEA_ENABLE_THREADS
TEA_ENABLE_SHARED
TEA_CONFIG_CFLAGS
TEA_ENABLE_SYMBOLS
AC_DEFINE([USE_TCL_STUBS],[1],[Use the Tcl Stubs library])
OPENSSL="1"

TLS_CHECK_SSL

#--------------------------------------------------------------------
# Determine if we should use the patented encryption code
#--------------------------------------------------------------------

AC_ARG_ENABLE(patents, [  --enable-patents        Use patented code.  Default is enabled], PATENTS=${enableval}, PATENTS=yes)  

if test ${PATENTS} = no; then
    AC_DEFINE([NO_PATENTS],[1],[Don't use patented code.])
fi

TEA_MAKE_LIB

# Subst runtime dir here, use -R and -L where necessary. [Bug 1742859]
LIB_RUNTIME_DIR=${SSL_LIB_DIR}
eval "LD_SEARCH_FLAGS=\"${LD_SEARCH_FLAGS}\""
if test -n "${OPENSSL}"; then
    TEA_ADD_LIBS([${LD_SEARCH_FLAGS} -L${SSL_LIB_DIR} -lssl -lcrypto ${GCCPATH} ${GCCLIB}])
else
    TEA_ADD_LIBS([${LD_SEARCH_FLAGS} -L${SSL_LIB_DIR} -lsslc])
fi

TEA_PROG_TCLSH


dnl SWIG Check
AX_PKG_SWIG(1.3)

dnl Check for external Tcl/Tk libraries
AX_SNIT
AX_JSON
#AX_SHA1
#AX_MD5
AX_BASE64
AX_URI

AC_PATH_PROGS(UNZIP,unzip)


AC_MSG_CHECKING([Checking target tclkit and Tclxml])
case $target_cpu in 
    x86_64)
        AC_SUBST(TCLKITRUN, tclkit-linux-x86_64)
        AC_SUBST(TCLXML_ZIP, Tclxml3.1-Linux64.zip)
        AC_SUBST(IMG_ZIP, Img-1.4-Linux64.zip)
        ;;
    i*86)
        AC_SUBST(TCLKITRUN, tclkit-linux-x86)
        AC_SUBST(TCLXML_ZIP, Tclxml3.1-Linux32.zip)
        AC_SUBST(IMG_ZIP, Img-1.4-Linux32.zip)
        ;;
    *)
        AC_MSG_ERROR([Unsupported Linux arch: $target_cpu])
        ;;
esac
AC_MSG_RESULT([TCLXML_ZIP is $TCLXML_ZIP, IMG_ZIP is $IMG_ZIP, and TCLKITRUN is $TCLKITRUN])


                                        
AC_MSG_CHECKING([Checking build tclkit])
case $build_cpu in
    x86_64)
        AC_SUBST(TCLKITBSRC, tclkit-linux-x86_64)
        ;;
    i*86)
        AC_SUBST(TCLKITBSRC, tclkit-linux-x86)
        ;;
    *)
        AC_MSG_ERROR([Unsupported Linux arch: $build_cpu])
        ;;
esac
AC_MSG_RESULT([TCLKITBSRC is $TCLKITBSRC])




AC_CONFIG_FILES([Scripts/Makefile BuildData/Makefile Doc/Makefile \
          Doc/Doxyfile BuildScripts/Makefile SwipeHID/Makefile \
          BuildScripts/tcldoxyfilter.sh Makefile])
                    
AC_CONFIG_SUBDIRS([tls1.6.7])

AC_CONFIG_COMMANDS([default],[chmod +x BuildScripts/tcldoxyfilter.sh])
AC_OUTPUT

