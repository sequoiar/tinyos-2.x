/**
 * "Copyright (c) 2009 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * The hardware presentation layer for the SAM3U SPI.
 *
 * @author Thomas Schmid
 */

#include "sam3uspihardware.h"

module HplSam3uSpiP
{
    provides
    {
       interface HplSam3uSpiConfig; 
       interface HplSam3uSpiControl; 
       interface HplSam3uSpiInterrupts; 
       interface HplSam3uSpiStatus; 
    }
}
implementation
{
    /**
     * Set the SPI interface to Master mode (default).
     */
    async command error_t HplSam3uSpiConfig.setMaster()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.mstr = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Set the SPI interface to Slave mode.
     */
    async command error_t HplSam3uSpiConfig.setSlave()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.mstr = 0;
        SPI->mr = mr;
        return SUCCESS;
    }
    
    /**
     * Set fixed peripherel select.
     */
    async command error_t HplSam3uSpiConfig.setFixedCS()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.ps = 0;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Set variable peripheral select.
     */
    async command error_t HplSam3uSpiConfig.setVariableCS()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.ps = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Set the Chip Select pins to be directly connected to the chips
     * (default).
     */
    async command error_t HplSam3uSpiConfig.setDirectCS()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.pcsdec = 0;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Set the Chip Select pins to be connected to a 4- to 16-bit decoder
     */
    async command error_t HplSam3uSpiConfig.setMultiplexedCS()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.pcsdec = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Enable mode fault detection (default).
     */
    async command error_t HplSam3uSpiConfig.enableModeFault()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.modfdis = 0;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Disable mode fault detection.
     */
    async command error_t HplSam3uSpiConfig.disableModeFault()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.modfdis = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Disable suppression of transmit if receive register is not empty
     * (default).
     */
    async command error_t HplSam3uSpiConfig.disableWaitTx()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.wdrbt = 0;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Enable suppression of transmit if receive register is not empty.
     */
    async command error_t HplSam3uSpiConfig.enableWaitTx()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.wdrbt = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Disable local loopback
     */
    async command error_t HplSam3uSpiConfig.disableLoopBack()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.llb = 0;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Enable local loopback
     */
    async command error_t HplSam3uSpiConfig.enableLoopBack()
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.llb = 1;
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Select peripheral chip
     */
    async command error_t HplSam3uSpiConfig.selectChip(uint8_t pcs)
    {
        spi_mr_t mr = SPI->mr;
        if(SPI->mr.bits.pcsdec == 0)
        {
            switch(pcs)
            {
                case 0:
                    mr.bits.pcs = 0;
                    break;
                case 1:
                    mr.bits.pcs = 1;
                    break;
                case 2:
                    mr.bits.pcs = 3;
                    break;
                case 3:
                    mr.bits.pcs = 7;
                    break;
                default:
                    return EINVAL;
            }
        } else {
            if(pcs > 15)
                return EINVAL;
            mr.bits.pcs = pcs;
        }
        SPI->mr = mr;
        return SUCCESS;
    }

    /**
     * Set the delay between chip select changes in MCK clock ticks.
     */
    async command error_t HplSam3uSpiConfig.setChipSelectDelay(uint8_t n)
    {
        spi_mr_t mr = SPI->mr;
        mr.bits.dlybcs = n;
        SPI->mr = mr;
        return SUCCESS;
    }


    async command void HplSam3uSpiControl.resetSpi()
    {
        spi_cr_t cr = SPI->cr;
        cr.bits.swrst = 1;
        SPI->cr = cr;
    }

    async command void HplSam3uSpiControl.enableSpi()
    {
        spi_cr_t cr = SPI->cr;
        cr.bits.spien = 1;
        SPI->cr = cr;
    }

    async command void HplSam3uSpiControl.disableSpi()
    {
        spi_cr_t cr = SPI->cr;
        cr.bits.spidis = 1;
        SPI->cr = cr;
    }

    async command void HplSam3uSpiControl.lastTransfer()
    {
        spi_cr_t cr = SPI->cr;
        cr.bits.lastxfer = 1;
        SPI->cr = cr;
    }

    __attribute__((interrupt)) void SpiIrqHandler() @C() @spontaneous()
    {
        if((call HplSam3uSpiInterrupts.isEnabledRxFullIrq() == TRUE) &&
                (call HplSam3uSpiStatus.isRxFull() == TRUE))
        {
            uint16_t data = call HplSam3uSpiStatus.getReceivedData();
            signal HplSam3uSpiInterrupts.receivedData(data);
        }
    }

    async command void HplSam3uSpiInterrupts.disableAllSpiIrqs()
    {
        call HplSam3uSpiInterrupts.disableRxFullIrq();
        call HplSam3uSpiInterrupts.disableTxDataEmptyIrq();
        call HplSam3uSpiInterrupts.disableModeFaultIrq();
        call HplSam3uSpiInterrupts.disableOverrunIrq();
        call HplSam3uSpiInterrupts.disableNssRisingIrq();
        call HplSam3uSpiInterrupts.disableTxEmptyIrq();
        call HplSam3uSpiInterrupts.disableUnderrunIrq();
    }

    // RDRF
    async command void HplSam3uSpiInterrupts.enableRxFullIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.rdrf = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableRxFullIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.rdrf = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledRxFullIrq()
    {
        return (SPI->imr.bits.rdrf == 1);
    }

    // TDRE
    async command void HplSam3uSpiInterrupts.enableTxDataEmptyIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.tdre = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableTxDataEmptyIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.tdre = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledTxDataEmptyIrq()
    {
        return (SPI->imr.bits.tdre == 1);
    }

    // MODF
    async command void HplSam3uSpiInterrupts.enableModeFaultIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.modf = 1;
        SPI->ier = ier;

    }
    async command void HplSam3uSpiInterrupts.disableModeFaultIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.modf = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledModeFaultIrq()
    {
        return (SPI->imr.bits.modf == 1);
    }

    // OVRES
    async command void HplSam3uSpiInterrupts.enableOverrunIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.ovres = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableOverrunIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.ovres = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledOverrunIrq()
    {
        return (SPI->imr.bits.ovres == 1);
    }

    // NSSR
    async command void HplSam3uSpiInterrupts.enableNssRisingIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.nssr = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableNssRisingIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.nssr = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledNssRisingIrq()
    {
        return (SPI->imr.bits.nssr == 1);
    }

    // TXEMPTY
    async command void HplSam3uSpiInterrupts.enableTxEmptyIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.txempty = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableTxEmptyIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.txempty = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledTxEmptyIrq()
    {
        return (SPI->imr.bits.txempty == 1);
    }

    // UNDES
    async command void HplSam3uSpiInterrupts.enableUnderrunIrq()
    {
        spi_ier_t ier = SPI->ier;
        ier.bits.undes = 1;
        SPI->ier = ier;
    }
    async command void HplSam3uSpiInterrupts.disableUnderrunIrq()
    {
        spi_idr_t idr = SPI->idr;
        idr.bits.undes = 1;
        SPI->idr = idr;
    }
    async command bool HplSam3uSpiInterrupts.isEnabledUnderrunIrq()
    {
        return (SPI->imr.bits.undes == 1);
    }


    async command uint16_t HplSam3uSpiStatus.getReceivedData()
    {
        return SPI->rdr.bits.rd;
    }

    async command error_t HplSam3uSpiStatus.setDataToTransmitCS(uint16_t txchr, uint8_t pcs, bool lastXfer)
    {
        spi_tdr_t tdr;

        if(SPI->mr.bits.ps == 1)
        {
            if(SPI->mr.bits.pcsdec == 0)
            {
                switch(pcs)
                {
                    case 0:
                        tdr.bits.pcs = 0;
                        break;
                    case 1:
                        tdr.bits.pcs = 1;
                        break;
                    case 2:
                        tdr.bits.pcs = 3;
                        break;
                    case 3:
                        tdr.bits.pcs = 7;
                        break;
                    default:
                        return EINVAL;
                }
            } else {
                if(pcs > 15)
                    return EINVAL;
                tdr.bits.pcs = pcs;
            }
            tdr.bits.td = txchr;
            tdr.bits.lastxfer = lastXfer;
            SPI->tdr = tdr;
        } else {
            if(call HplSam3uSpiConfig.selectChip(pcs) != SUCCESS)
                return EINVAL;
            call HplSam3uSpiStatus.setDataToTransmit(txchr);
        }
        return SUCCESS;
    }

    async command void HplSam3uSpiStatus.setDataToTransmit(uint16_t txchr)
    {
        spi_tdr_t tdr = SPI->tdr;
        tdr.bits.td = txchr;
        SPI->tdr = tdr;
    }

    async command bool HplSam3uSpiStatus.isRxFull()
    {
        return (SPI->sr.bits.rdrf == 1);
    }
    async command bool HplSam3uSpiStatus.isTxDataEmpty()
    {
        return (SPI->sr.bits.tdre == 1);
    }
    async command bool HplSam3uSpiStatus.isModeFault()
    {
        return (SPI->sr.bits.modf == 1);
    }
    async command bool HplSam3uSpiStatus.isOverrunError()
    {
        return (SPI->sr.bits.ovres == 1);
    }
    async command bool HplSam3uSpiStatus.isNssRising()
    {
        return (SPI->sr.bits.nssr == 1);
    }
    async command bool HplSam3uSpiStatus.isTxEmpty()
    {
        return (SPI->sr.bits.txempty == 1);
    }
    async command bool HplSam3uSpiStatus.isUnderrunError()
    {
        return (SPI->sr.bits.undes == 1);
    }
    async command bool HplSam3uSpiStatus.isSpiEnabled()
    {
        return (SPI->sr.bits.spiens == 1);
    }
}


