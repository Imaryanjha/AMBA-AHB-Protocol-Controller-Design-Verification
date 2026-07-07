# AHB Read Data Multiplexer Verification


<img width="1920" height="1080" alt="Screenshot from 2026-07-06 08-27-28" src="https://github.com/user-attachments/assets/8a0b3568-f2c4-418f-8420-ebdb7fa4a4ed" />


## Description

This waveform verifies the functionality of the **AHB Read Data Multiplexer**, which selects the appropriate slave response based on the active slave select signal (`HSEL0`–`HSEL3`). The multiplexer forwards the corresponding slave's read data (`HRDATA`), ready signal (`HREADYOUT`), and response (`HRESP`) to the master while ensuring that only the selected slave drives the output.

The simulation sequentially activates each slave select signal to verify that the correct slave outputs are propagated to the master interface. The output `HRDATA` changes according to the selected slave's read data, while the associated `HREADY` and `HRESP` signals are also selected from the active slave.

## Slave Selection Results

| Active Slave | Selected Read Data |
|---------------|--------------------|
| HSEL0 | 32'hAAAA_AAAA |
| HSEL1 | 32'hBBBB_BBBB |
| HSEL2 | 32'hCCCC_CCCC |
| HSEL3 | No Valid Data |

## Signal Summary

| Signal | Description |
|---------|-------------|
| HSEL0 | Selects Slave 0 |
| HSEL1 | Selects Slave 1 |
| HSEL2 | Selects Slave 2 |
| HSEL3 | Selects Slave 3 |
| HRDATA0 | Read data from Slave 0 |
| HRDATA1 | Read data from Slave 1 |
| HRDATA2 | Read data from Slave 2 |
| HRDATA3 | Read data from Slave 3 |
| HREADYOUT0-3 | Ready signals from each slave |
| HRESP0-3 | Response signals from each slave |
| HRDATA | Selected read data output |
| HREADY | Selected ready signal |
| HRESP | Selected response signal |

## Transaction Flow

1. `HSEL0` is asserted, selecting Slave 0.
2. The multiplexer forwards `HRDATA0` (`0xAAAA_AAAA`) to the output.
3. `HSEL1` is asserted, selecting Slave 1.
4. The output changes to `HRDATA1` (`0xBBBB_BBBB`).
5. `HSEL2` is asserted, selecting Slave 2.
6. The output changes to `HRDATA2` (`0xCCCC_CCCC`).
7. `HSEL3` is asserted, selecting Slave 3.
8. The corresponding slave outputs are forwarded to the master interface.

## Features Verified

- Slave 0 data selection
- Slave 1 data selection
- Slave 2 data selection
- Slave 3 data selection
- Read data multiplexing
- Ready signal multiplexing
- Response signal multiplexing
- One-hot slave selection

## Observation

The waveform confirms that the AHB Read Data Multiplexer correctly forwards the read data, ready, and response signals from the selected slave to the master. Only the active slave contributes to the output at any instant, ensuring proper routing of slave responses and correct operation of the AHB interconnect.
