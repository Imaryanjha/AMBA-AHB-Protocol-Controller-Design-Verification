# AHB Slave Single Read Transaction

## Description

<img width="1920" height="1080" alt="Screenshot from 2026-07-06 08-57-05" src="https://github.com/user-attachments/assets/b2259d99-4331-46e4-b7d1-4e00755e2b64" />


This waveform illustrates the operation of the **AHB Slave** during a **single read transaction**. The slave is selected by asserting `HSEL`, while the master initiates the transfer by driving the target address and control signals. Since `HWRITE` is deasserted, the transaction is identified as a read operation. The transfer type is `NONSEQ`, indicating the start of a new transfer, and `HSIZE` is configured for a 32-bit word transfer with `HBURST` set to `SINGLE`.

After decoding the address (`0x10`), the slave accesses the corresponding memory location and places the stored data (`0x12345678`) onto the `HRDATA` bus. Throughout the transaction, `HREADY` remains asserted, indicating that the slave is ready to complete the transfer without inserting any wait states. The response signal `HRESP` remains low (`OKAY`), confirming successful completion of the read operation.

## Signal Summary

| Signal | Value | Description |
|---------|-------|-------------|
| HSEL | 1 | Slave selected |
| HADDR | 32'h00000010 | Target read address |
| HWRITE | 0 | Read operation |
| HTRANS | NONSEQ (2'b10) | Start of a new transfer |
| HSIZE | 3'b010 | 32-bit word transfer |
| HBURST | SINGLE (3'b000) | Single transfer |
| HRDATA | 32'h12345678 | Data returned by the slave |
| HREADY | 1 | Slave ready; no wait states |
| HRESP | 0 (OKAY) | Successful transfer |

## Transaction Flow

1. The master selects the slave by asserting `HSEL`.
2. The address `0x10` is driven on the `HADDR` bus.
3. `HWRITE = 0` indicates a read transaction.
4. `HTRANS = NONSEQ` marks the beginning of the transfer.
5. The slave decodes the address and accesses the requested memory location.
6. The stored data `0x12345678` is placed on the `HRDATA` bus.
7. Since `HREADY = 1`, the transfer completes without any wait states.
8. `HRESP = OKAY` confirms successful completion of the transaction.




