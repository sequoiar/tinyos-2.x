/// $Id$

/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */

/**
 * HPL Interface to Atmega128 8-bit timer control registers
 *
 * @author Martin Turon <mturon@xbow.com>
 */

#include <Atm128Timer.h>

interface HplAtm128TimerCtrl8
{
  /// Timer control register: Direct access
  async command Atm128TimerControl_t getControl();
  async command void setControl( Atm128TimerControl_t control );

  /// Interrupt mask register: Direct access
  async command Atm128_TIMSK_t getInterruptMask();
  async command void setInterruptMask( Atm128_TIMSK_t mask);

  /// Interrupt flag register: Direct access
  async command Atm128_TIFR_t getInterruptFlag();
  async command void setInterruptFlag( Atm128_TIFR_t flags );
}
