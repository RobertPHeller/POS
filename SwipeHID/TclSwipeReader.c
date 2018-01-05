/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Fri Jan 5 14:42:14 2018
 *  Last Modified : <180105.1540>
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
#include <tcl.h>                                                                
#include <string.h>                                                             
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/input.h>

#if !defined(INT2PTR) && !defined(PTR2INT)
#   if defined(HAVE_INTPTR_T) || defined(intptr_t)
#	define INT2PTR(p) ((void*)(intptr_t)(p))
#	define PTR2INT(p) ((int)(intptr_t)(p))
#   else
#	define INT2PTR(p) ((void*)(p))
#	define PTR2INT(p) ((int)(p))
#   endif
#endif
#if !defined(UINT2PTR) && !defined(PTR2UINT)
#   if defined(HAVE_UINTPTR_T) || defined(uintptr_t)
#	define UINT2PTR(p) ((void*)(uintptr_t)(p))
#	define PTR2UINT(p) ((unsigned int)(uintptr_t)(p))
#   else
#	define UINT2PTR(p) ((void*)(p))
#	define PTR2UINT(p) ((unsigned int)(p))
#   endif
#endif

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
   
/*
 * This structure describes per-instance state of a Swipe Reader (really any keyboard event) based channel.
 */

typedef struct SWIPEState {
    Tcl_Channel channel;        /* Channel associated with this file. */
    int fd;                     /* The fd itself. */
    int flags;                  /* ORed combination of the bitfields defined
                                 * below. */
} SWIPEState;

static int        SwipeBlockModeProc(ClientData data, int mode);
static int        SwipeCloseProc(ClientData instanceData, Tcl_Interp *interp);
static int        SwipeGetHandleProc(ClientData instanceData, int direction, 
                                   ClientData *handlePtr);
static int        SwipeGetOptionProc(ClientData instanceData, 
                                   Tcl_Interp *interp, const char *optionName, 
                                   Tcl_DString *dsPtr);
static int        SwipeInputProc(ClientData instanceData, char *buf, int toRead, 
                               int *errorCode);
static void       SwipeWatchProc(ClientData instanceData, int mask);

/*
 * This structure describes the channel type structure for SWIPE socket
 * based IO:
 */

static Tcl_ChannelType canChannelType = {
    "can",                      /* Type name. */
    TCL_CHANNEL_VERSION_5,      /* v5 channel */
    SwipeCloseProc,             /* Close proc. */
    SwipeInputProc,             /* Input proc. */
    NULL,                       /* Output proc. */
    NULL,                       /* Seek proc. */
    NULL,                       /* Set option proc. */
    SwipeGetOptionProc,         /* Get option proc. */
    SwipeWatchProc,             /* Initialize notifier. */
    SwipeGetHandleProc,         /* Get OS handles out of channel. */
    NULL,                       /* close2proc. */
    SwipeBlockModeProc,         /* Set blocking or non-blocking mode.*/
    NULL,                       /* flush proc. */
    NULL,                       /* handler proc. */
    NULL,                       /* wide seek proc. */
    NULL,                       /* thread action proc. */
    NULL,                       /* truncate proc. */
};

/*
 *----------------------------------------------------------------------
 *
 * SwipeBlockModeProc --
 *
 *	This function is invoked by the generic IO level to set blocking and
 *	nonblocking mode on a SWIPE socket based channel.
 *
 * Results:
 *	0 if successful, errno when failed.
 *
 * Side effects:
 *	Sets the device into blocking or nonblocking mode.
 *
 *----------------------------------------------------------------------
 */

	/* ARGSUSED */
static int
SwipeBlockModeProc(
    ClientData instanceData,	/* Socket state. */
    int mode)			/* The mode to set. Can be one of
				 * TCL_MODE_BLOCKING or
				 * TCL_MODE_NONBLOCKING. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;

    int flags = fcntl(statePtr->fd, F_GETFL);
    if (mode == TCL_MODE_BLOCKING) {
        flags &= ~O_NONBLOCK;
    } else {
        flags |= O_NONBLOCK;
    }
    if (fcntl(statePtr->fd, F_SETFL, flags) < 0) {
        return errno;
    } else {
        return 0;
    }
}

/*
 *----------------------------------------------------------------------
 *
 * SwipeInputProc --
 *
 *	This function is invoked by the generic IO level to read input from a
 *	SWIPE socket based channel.
 * 
 *      Note: All SWIPE I/O is encoded as GridConnect format message.
 *
 * Results:
 *	The number of bytes read is returned or -1 on error. An output
 *	argument contains the POSIX error code on error, or zero if no error
 *	occurred.
 *
 * Side effects:
 *	Reads input from the input device of the channel.
 *
 *----------------------------------------------------------------------
 */

	/* ARGSUSED */
static int
SwipeInputProc(
    ClientData instanceData,	/* Socket state. */
    char *buf,			/* Where to store data read. */
    int bufSize,		/* How much space is available in the
				 * buffer? */
    int *errorCodePtr)		/* Where to store error code. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;
    int bytes;
    struct input_event eventBuffer;
    int shift = 0;
    
#ifdef DEBUG
    fprintf(stderr,"*** SwipeInputProc()\n");
#endif
    *errorCodePtr = 0;
    bytes = read(statePtr->fd,&eventBuffer,sizeof(eventBuffer));
    if (bytes < 0) {
        *errorCodePtr = errno;
        return -1;
    }
    while (eventBuffer.type != EV_KEY || eventBuffer.value != 1) {
#ifdef DEBUG
        fprintf(stderr,"*** SwipeInputProc(): eventBuffer.type = %d\n",eventBuffer.type);
#endif
        bytes = read(statePtr->fd,&eventBuffer,sizeof(eventBuffer));
        if (bytes < 0) {
            *errorCodePtr = errno;
            return -1;
        }
    }
#ifdef DEBUG
    fprintf(stderr,"*** SwipeInputProc(): eventBuffer.code = %d\n", eventBuffer.code);
#endif
    if (eventBuffer.code == KEY_LEFTSHIFT || eventBuffer.code == KEY_RIGHTSHIFT) {
        shift = 1;
        bytes = read(statePtr->fd,&eventBuffer,sizeof(eventBuffer));
        if (bytes < 0) {
            *errorCodePtr = errno;
            return -1;
        }
        while (eventBuffer.type != EV_KEY || eventBuffer.value != 1) {
#ifdef DEBUG
            fprintf(stderr,"*** SwipeInputProc(): eventBuffer.type = %d\n",eventBuffer.type);
#endif
            bytes = read(statePtr->fd,&eventBuffer,sizeof(eventBuffer));
            if (bytes < 0) {
                *errorCodePtr = errno;
                return -1;
            }
        }
    }
#ifdef DEBUG
    fprintf(stderr,"*** SwipeInputProc(): shift = %d, eventBuffer.code = %d\n", shift, eventBuffer.code);
#endif
    
    if (eventBuffer.code == KEY_ENTER) {
        *buf++ = '\r';
        *buf++ = '\n';
        *buf++ = '\0';
        return 2;
    }

    if (shift) {
        *buf++ = shiftedkeys[eventBuffer.code];
        *buf++ = '\0';
        return 1;
    } else {
        *buf++ = keys[eventBuffer.code];
        *buf++ = '\0';
        return 1;
    }
}


/*
 *----------------------------------------------------------------------
 *
 * SwipeCloseProc --
 *
 *	This function is invoked by the generic IO level to perform
 *	channel-type-specific cleanup when a SWIPE socket based channel is
 *	closed.
 *
 * Results:
 *	0 if successful, the value of errno if failed.
 *
 * Side effects:
 *	Closes the socket of the channel.
 *
 *----------------------------------------------------------------------
 */

	/* ARGSUSED */
static int
SwipeCloseProc(
    ClientData instanceData,	/* The socket to close. */
    Tcl_Interp *interp)		/* For error reporting - unused. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;
    int errorCode = 0;

    /*
     * Delete a file handler that may be active for this socket if this is a
     * server socket - the file handler was created automatically by Tcl as
     * part of the mechanism to accept new client connections. Channel
     * handlers are already deleted in the generic IO channel closing code
     * that called this function, so we do not have to delete them here.
     */

    Tcl_DeleteFileHandler(statePtr->fd);

    if (close(statePtr->fd) < 0) {
	errorCode = errno;
    }
    ckfree((char *) statePtr);

    return errorCode;
}

/*
 *----------------------------------------------------------------------
 *
 * SwipeGetOptionProc --
 *
 *	Computes an option value for a SWIPE socket based channel, or a list of
 *	all options and their values.
 *
 *	Note: This code is based on code contributed by John Haxby.
 *
 * Results:
 *	A standard Tcl result. The value of the specified option or a list of
 *	all options and their values is returned in the supplied DString. Sets
 *	Error message if needed.
 *
 * Side effects:
 *	None.
 *
 *----------------------------------------------------------------------
 */

static int
SwipeGetOptionProc(
    ClientData instanceData,	/* Socket state. */
    Tcl_Interp *interp,		/* For error reporting - can be NULL. */
    const char *optionName,	/* Name of the option to retrieve the value
				 * for, or NULL to get all options and their
				 * values. */
    Tcl_DString *dsPtr)		/* Where to store the computed value;
				 * initialized by caller. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;
    size_t len = 0;
    /*char buf[TCL_INTEGER_SPACE];*/

    if (optionName != NULL) {
	len = strlen(optionName);
    }

    if (len > 0) {
	return Tcl_BadChannelOption(interp, optionName, "error");
    }

    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * SwipeWatchProc --
 *
 *	Initialize the notifier to watch the fd from this channel.
 *
 * Results:
 *	None.
 *
 * Side effects:
 *	Sets up the notifier so that a future event on the channel will be
 *	seen by Tcl.
 *
 *----------------------------------------------------------------------
 */

static void
SwipeWatchProc(
    ClientData instanceData,	/* The socket state. */
    int mask)			/* Events of interest; an OR-ed combination of
				 * TCL_READABLE, TCL_WRITABLE and
				 * TCL_EXCEPTION. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;

    /*
     * Make sure we don't mess with server sockets since they will never be
     * readable or writable at the Tcl level. This keeps Tcl scripts from
     * interfering with the -accept behavior.
     */

    if (mask) {
        Tcl_CreateFileHandler(statePtr->fd, mask,
                              (Tcl_FileProc *) Tcl_NotifyChannel,
                              (ClientData) statePtr->channel);
    } else {
        Tcl_DeleteFileHandler(statePtr->fd);
    }

}

/*
 *----------------------------------------------------------------------
 *
 * SwipeGetHandleProc --
 *
 *	Called from Tcl_GetChannelHandle to retrieve OS handles from inside a
 *	SWIPE socket based channel.
 *
 * Results:
 *	Returns TCL_OK with the fd in handlePtr, or TCL_ERROR if there is no
 *	handle for the specified direction.
 *
 * Side effects:
 *	None.
 *
 *----------------------------------------------------------------------
 */

	/* ARGSUSED */
static int
SwipeGetHandleProc(
    ClientData instanceData,	/* The socket state. */
    int direction,		/* Not used. */
    ClientData *handlePtr)	/* Where to store the handle. */
{
    SWIPEState *statePtr = (SWIPEState *) instanceData;

    *handlePtr = (ClientData) INT2PTR(statePtr->fd);
    return TCL_OK;
}

/*
 *----------------------------------------------------------------------
 *
 * CreateSwipe --
 *
 *	This function opens a new Swipe Reader (really any keyboard).
 *	initializes the SWIPEState structure.
 *
 * Results:
 *	Returns a new SWIPEState, or NULL with an error in the interp's result,
 *	if interp is not NULL.
 *
 * Side effects:
 *	Opens a fd to a Swipe Reader event device.
 *
 *----------------------------------------------------------------------
 */

static SWIPEState *
CreateSwipe(
   Tcl_Interp *interp,		/* For error reporting; can be NULL. */
   const char *swipeevent)      /* SWIPE device name */
{
    int status, fd/*, curState*/;
    SWIPEState *statePtr;
    const char *errorMsg = NULL;
    
    fd = open(swipeevent,O_RDONLY);
    if (fd < 0) {
	goto addressError;
    }

    /*
     * Set the close-on-exec flag so that the socket will not get inherited by
     * child processes.
     */

    fcntl(fd, F_SETFD, FD_CLOEXEC);

    status = 0;
    /*
     * Allocate a new SWIPEState for this socket.
     */

    statePtr = (SWIPEState *) ckalloc((unsigned) sizeof(SWIPEState));
    statePtr->flags = 0;
    statePtr->fd = fd;

    return statePtr;

  addressError:
    if (fd != -1) {
	close(fd);
    }
    if (interp != NULL) {
	Tcl_AppendResult(interp, "couldn't open event device: ",
		Tcl_PosixError(interp), NULL);
	if (errorMsg != NULL) {
	    Tcl_AppendResult(interp, " (", errorMsg, ")", NULL);
	}
    }
    return NULL;
}


/*
 * Create a TclChannel for a SWIPE Socket.
 * 
 */

int SwipeReader(Tcl_Interp *interp, const char *swipeevent)
{
    SWIPEState *statePtr;
    char channelName[16 + TCL_INTEGER_SPACE];
    
    statePtr = CreateSwipe(interp, swipeevent);
    if (statePtr == NULL) {
        return TCL_ERROR;
    }
    sprintf(channelName, "swipe%d", statePtr->fd);
    statePtr->channel = Tcl_CreateChannel(&canChannelType, channelName,
                                          (ClientData) statePtr, 
                                          TCL_READABLE);
    Tcl_RegisterChannel(interp, statePtr->channel);
    Tcl_AppendResult(interp, channelName, NULL);
    return TCL_OK;          
}
