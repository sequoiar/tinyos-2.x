// $Id$
/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Internal mica-family timer component. Sets up hardware timer 1 to run
 * at cpu clock / 256, at boot time. Assumes an ~8MHz CPU clock, replace
 * this component if you are running at a radically different frequency.
 *
 * @author David Gay
 */

#include <MicaTimer.h>

configuration InitOneP { }
implementation {
  components PlatformC, HplAtm128Timer1C as HWTimer,
    new Atm128TimerInitC(uint16_t, MICA_PRESCALER_ONE) as InitOne;

  PlatformC.SubInit -> InitOne;
  InitOne.Timer -> HWTimer;
}
