/*
 * Copyright (c) 2010, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */
 
#ifndef __TIMESYNCMESSAGELAYER_H__
#define __TIMESYNCMESSAGELAYER_H__

#include <AM.h>

#ifndef AM_TIMESYNCMSG
#define AM_TIMESYNCMSG 0x3D
#endif

// this is sent over the air
typedef nx_int32_t timesync_relative_t;

// this is stored in memory
typedef nx_uint32_t timesync_absolute_t;

typedef nx_struct timesync_footer_t
{
	nx_am_id_t type;	
	nx_union timestamp_t
	{
		timesync_relative_t relative;
		timesync_absolute_t absolute;
	} timestamp;
} timesync_footer_t;

#endif//__TIMESYNCMESSAGELAYER_H__
