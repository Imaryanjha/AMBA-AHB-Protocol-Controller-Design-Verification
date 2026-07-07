
# AHB Address Decoder Verification

## Description

<img width="1920" height="1080" alt="Screenshot from 2026-07-06 08-27-15" src="https://github.com/user-attachments/assets/b986698c-d18c-4d60-873f-a308075decba" />


This waveform verifies the functionality of the **AHB Address Decoder**, which selects the appropriate slave based on the incoming address (`HADDR`). The decoder monitors the address bus and asserts only one slave select signal (`HSEL0`–`HSEL3`) corresponding to the configured address range. This ensures that only the targeted slave responds to the current AHB transaction.

The simulation applies multiple test addresses to verify that each address range correctly activates its respective slave select signal. For addresses outside the defined memory map, none of the slave select signals are asserted, indicating that no valid slave is selected.

## Address Decoding Results

| Address | Selected Slave |
|----------|----------------|
| 32'h00001234 | HSEL0 |
| 32'h10005678 | HSEL1 |
| 32'h2000ABCD | HSEL2 |
| 32'h30001111 | HSEL3 |
| 32'h80000000 | No Slave Selected |

## Signal Summary

| Signal | Description |
|---------|-------------|
| HADDR | Input address bus |
| HSEL0 | Slave 0 select signal |
| HSEL1 | Slave 1 select signal |
| HSEL2 | Slave 2 select signal |
| HSEL3 | Slave 3 select signal |

## Transaction Flow

1. The decoder receives an address on the `HADDR` bus.
2. The address is compared against the predefined address ranges.
3. Depending on the address, one corresponding `HSEL` signal is asserted.
4. Only one slave select signal remains active at any time.
5. When an address falls outside the valid address space, all `HSEL` signals remain deasserted.

## Features Verified

- Address decoding based on `HADDR`
- Slave 0 selection (`HSEL0`)
- Slave 1 selection (`HSEL1`)
- Slave 2 selection (`HSEL2`)
- Slave 3 selection (`HSEL3`)
- One-hot slave selection
- Invalid address handling (no slave selected)

