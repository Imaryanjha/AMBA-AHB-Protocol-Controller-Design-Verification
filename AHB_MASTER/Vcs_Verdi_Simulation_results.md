## Single Read

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/25bcf2af-e7e9-449d-9884-32ebfdebccef" />


## Signal Summary

| Signal | Value | Description |
|--------|-------|-------------|
| HADDR | 32'h00001000 | Target read address |
| HWRITE | 0 | Read operation |
| HTRANS | NONSEQ (2'b10) | Start of a new transfer |
| HSIZE | 3'b010 | 32-bit word transfer |
| HBURST | SINGLE (3'b000) | Single transfer |
| HRDATA | 32'h12345678 | Data returned by the slave |
| HREADY | 1 | Slave is ready; no wait states |
| HRESP | 0 (OKAY) | Successful transfer |

## Transaction Flow

1. Master drives the address `0x1000` along with the control signals.
2. `HWRITE = 0` indicates a read operation.
3. `HTRANS = NONSEQ` marks the beginning of a new transfer.
4. The slave decodes the address and prepares the requested data.
5. Since `HREADY = 1`, the transfer proceeds without any wait states.
6. The slave places `0x12345678` on the `HRDATA` bus.
7. The master samples the data and the transaction completes successfully.
8. The bus returns to the `IDLE` state.

## Multiple Write

<img width="1920" height="1080" alt="Screenshot from 2026-07-05 08-46-45" src="https://github.com/user-attachments/assets/f0973d42-0f65-4a60-a3e6-91ff6f07b43e" />



This waveform illustrates **multiple single write transactions** performed sequentially on the AHB bus. The master writes four different 32-bit data values to four consecutive memory locations. Each write transaction is independent and is initiated with `HTRANS = NONSEQ`, indicating the start of a new transfer rather than a burst operation.

For every transaction, the master first drives the target address and control signals during the **address phase**. In the following clock cycle, the corresponding write data is placed on the `HWDATA` bus during the **data phase**. Since `HWRITE` remains asserted throughout each transaction, all transfers are write operations.

The slave keeps `HREADY` high for every transfer, indicating that it is always ready to accept the data. Consequently, no wait states are inserted, and each write completes successfully with an `OKAY` response (`HRESP = 0`). After each transfer, the bus returns to the `IDLE` state before initiating the next write transaction.

## Transaction Details

| Transaction | Address | Write Data | HTRANS |
|-------------|---------|------------|---------|
| Write 1 | 32'h00001000 | 32'h11111111 | NONSEQ |
| Write 2 | 32'h00002000 | 32'h22222222 | NONSEQ |
| Write 3 | 32'h00003000 | 32'h33333333 | NONSEQ |
| Write 4 | 32'h00004000 | 32'h44444444 | NONSEQ |

## Signal Summary

| Signal | Value | Description |
|--------|-------|-------------|
| HWRITE | 1 | Write operation |
| HTRANS | NONSEQ (2'b10) | Start of each new transfer |
| HSIZE | 3'b010 | 32-bit word transfer |
| HBURST | SINGLE (3'b000) | Independent single transfers |
| HADDR | 0x1000, 0x2000, 0x3000, 0x4000 | Target write addresses |
| HWDATA | 0x11111111, 0x22222222, 0x33333333, 0x44444444 | Data written to memory |
| HREADY | 1 | Slave always ready; no wait states |
| HRESP | 0 (OKAY) | Successful completion of every transfer |

## Transaction Flow

1. The master drives the first address (`0x1000`) with `HWRITE = 1` and `HTRANS = NONSEQ`.
2. In the next clock cycle, the master places `0x11111111` on the `HWDATA` bus.
3. The slave accepts the data immediately since `HREADY = 1`.
4. The transfer completes successfully with `HRESP = OKAY`.
5. The bus returns to the `IDLE` state.
6. The same sequence is repeated for addresses `0x2000`, `0x3000`, and `0x4000` with data values `0x22222222`, `0x33333333`, and `0x44444444`, respectively.
7. After the final write transaction, the bus returns to the `IDLE` state, completing the sequence.

## Observation

- Four independent **single write** transactions are performed.
- Every transaction begins with `HTRANS = NONSEQ`.
- `HWRITE` remains high, indicating write operations.
- `HBURST = SINGLE`, confirming that these are **not burst transfers**.
- `HREADY` remains asserted throughout, resulting in zero wait states.
- All transactions complete successfully with an `OKAY` response (`HRESP = 0`).

## Burst Transfer
<img width="1920" height="1080" alt="Screenshot from 2026-07-06 06-55-39" src="https://github.com/user-attachments/assets/f1c1f00c-1f65-4dce-b6f6-944929e92dab" />

# AHB Master Functional Verification

## Description

This waveform demonstrates the functional verification of the AHB Master by executing different types of AHB transactions, including single write, incrementing burst write (INCR4), wrapping burst write (WRAP4), wait-state handling, and a final single read operation. The objective is to verify that the master correctly generates all address, control, and data signals according to the AHB protocol.

Initially, the master performs a **single write** transaction by writing `0xDEADBEEF` to address `0x1000`. The transfer is initiated with `HTRANS = NONSEQ`, `HWRITE = 1`, `HBURST = SINGLE`, and `HSIZE = 32-bit`.

The master then performs an **INCR4 burst write** starting from address `0x2000`. During this burst, `HBURST` is configured as `INCR4` and the addresses automatically increment by four bytes for each transfer:

- 0x2000
- 0x2004
- 0x2008
- 0x200C

The first transfer uses `HTRANS = NONSEQ`, while the remaining transfers use `HTRANS = SEQ`, demonstrating the pipelined burst operation defined by the AHB protocol.

Next, a **WRAP4 burst write** begins at address `0x1008`. Since the burst must remain within the same 16-byte boundary, the generated addresses are:

- 0x1008
- 0x100C
- 0x1000
- 0x1004

This verifies the correct implementation of address wrapping within the burst boundary.

Following the burst transfers, the master performs additional **single write** operations to addresses `0x3000` and `0x4000`, writing `0xDEADBEEF` while using `HBURST = SINGLE` and `HTRANS = NONSEQ`.

The waveform also verifies the master's ability to handle **wait states**. During one transaction, the slave deasserts `HREADY`, forcing the master to stall and hold all address and control signals until the slave becomes ready again. Once `HREADY` returns high, the transfer resumes normally without violating the protocol.

Finally, the master performs a **single read** from address `0x5000`. The master drives `HWRITE = 0` and `HTRANS = NONSEQ`, while the slave returns the data value `0xCAFEBABE` on the `HRDATA` bus. Since `HREADY` is asserted and `HRESP = OKAY`, the read transaction completes successfully.

Throughout the simulation, `HRESP` remains low, indicating that all transfers complete successfully without any protocol errors.

## Transactions Performed

| Transaction | Start Address | Burst Type | Operation |
|-------------|---------------|------------|-----------|
| Single Write | 0x1000 | SINGLE | Write |
| Burst Write | 0x2000 | INCR4 | Write |
| Burst Write | 0x1008 | WRAP4 | Write |
| Single Write | 0x3000 | SINGLE | Write |
| Single Write | 0x4000 | SINGLE | Write |
| Single Read | 0x5000 | SINGLE | Read |

## Features Verified

- Single write transaction
- INCR4 burst address generation
- WRAP4 burst address generation
- NONSEQ and SEQ transfer types
- 32-bit word transfers
- Write and read operations
- Wait-state handling using `HREADY`
- Successful transfer completion using `HRESP = OKAY`
- Correct read data capture (`0xCAFEBABE`)
- Proper return to IDLE state after each completed transaction

## Observation

The simulation confirms that the AHB Master correctly implements the AMBA AHB protocol by generating valid address, control, and data signals for single and burst transfers. Address incrementing, wrap-around addressing, wait-state handling, and read/write operations all behave as expected, demonstrating successful protocol compliance and functional correctness of the master design.
