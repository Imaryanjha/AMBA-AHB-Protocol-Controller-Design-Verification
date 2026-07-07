# AHB Master Module – Architecture Overview

## 1. Architecture
The AHB master module interfaces with the AHB bus to perform read and write transactions. It consists of:

- **FSM Controller**: Manages AHB transaction phases (Address, Data).
- **Address/Data Registers**: Store transaction information.
- **Control Logic**: Generates AHB control signals (`HWRITE`, `HSIZE`, `HBURST`, etc.).
- **Response Handler**: Monitors `HRESP` and manages retry/error conditions.

<img width="3821" height="2203" alt="image" src="https://github.com/user-attachments/assets/6e3d5d8e-f0f9-40c3-b015-4e47201dce60" />
  

---

## 2. Key Signals

### AHB Interface Signals

| Signal       | Direction | Description |
|--------------|-----------|-------------|
| `HCLK`       | Input     | AHB clock |
| `HRESETn`    | Input     | Active-low reset |
| `HADDR`      | Output [31:0] | Address bus |
| `HWDATA`     | Output [31:0] | Write data bus |
| `HRDATA`     | Input [31:0] | Read data bus |
| `HWRITE`     | Output    | 1 = Write, 0 = Read |
| `HSIZE`      | Output [2:0] | Transfer size (byte/halfword/word) |
| `HBURST`     | Output [2:0] | Burst type |
| `HPROT`      | Output [3:0] | Protection control |
| `HTRANS`     | Output [1:0] | Transfer type (IDLE/BUSY/NONSEQ/SEQ) |
| `HREADY`     | Input     | Slave ready signal |
| `HRESP`      | Input [1:0] | Transfer response (OKAY/ERROR/RETRY/SPLIT) |
| `HSELx`      | Output    | Slave select (decoded from address) |

### Internal Control Signals

| Signal       | Direction | Description |
|--------------|-----------|-------------|
| `start`      | Input     | Initiate transaction |
| `addr_in`    | Input [31:0] | Target address |
| `wdata_in`   | Input [31:0] | Data to write |
| `rdata_out`  | Output [31:0] | Data read |
| `busy`       | Output    | High during active transaction |
| `done`       | Output    | Pulse when transaction completes |
| `error`      | Output    | High if transaction fails |

---

## 3. FSM States

| State       | Description |
|-------------|-------------|
| `IDLE`      | Waiting for `start`. All outputs idle. |
| `ADDRESS`   | Drive address and control signals on the bus. |
| `DATA`      | Drive write data or sample read data. Wait for `HREADY`. |
| `RESPONSE`  | Check `HRESP`. Handle OKAY/ERROR/RETRY/SPLIT. |
| `COMPLETE`  | Assert `done`. Latch read data. Return to `IDLE`. |

---

## 4. State Transition Table

| Current State | Condition                    | Next State |
|---------------|------------------------------|------------|
| `IDLE`        | `start` = 1                  | `ADDRESS`  |
| `ADDRESS`     | Always (1 cycle)             | `DATA`     |
| `DATA`        | `HREADY` = 0                 | `DATA`     |
| `DATA`        | `HREADY` = 1                 | `RESPONSE` |
| `RESPONSE`    | `HRESP` = OKAY               | `COMPLETE` |
| `RESPONSE`    | `HRESP` = RETRY/SPLIT        | `ADDRESS`  |
| `RESPONSE`    | `HRESP` = ERROR              | `COMPLETE` |
| `COMPLETE`    | Always (1 cycle)             | `IDLE`     |

---

## 5. FSM Diagram

<img width="1280" height="848" alt="image" src="https://github.com/user-attachments/assets/80bec93a-5238-4903-bfd6-cbbc9b5aa028" />



---

## 6. Operation Summary

1. **IDLE**: Wait for `start` = 1.
2. **ADDRESS**: Drive `HADDR`, `HWRITE`, `HSIZE`, `HTRANS` = NONSEQ.
3. **DATA**: 
   - **Write**: Drive `HWDATA`, wait for `HREADY`.
   - **Read**: Sample `HRDATA` when `HREADY` = 1.
4. **RESPONSE**: 
   - **OKAY**: Proceed to COMPLETE.
   - **RETRY/SPLIT**: Restart address phase.
   - **ERROR**: Set error flag, proceed to COMPLETE.
5. **COMPLETE**: Assert `done`, store read data, return to IDLE.

---

## 7. Transaction Types Supported

| Type        | Description |
|-------------|-------------|
| Single      | One data phase per address phase |
| Incremental | Consecutive addresses (burst) |
| Wrapped     | Address wraps on boundary (burst) |

---

## 8. Control Signal Encoding

| Signal   | Value | Description |
|----------|-------|-------------|
| `HTRANS` | 00    | IDLE |
|          | 01    | BUSY |
|          | 10    | NONSEQ |
|          | 11    | SEQ |
| `HSIZE`  | 000   | Byte (8-bit) |
|          | 001   | Halfword (16-bit) |
|          | 010   | Word (32-bit) |
| `HRESP`  | 00    | OKAY |
|          | 01    | ERROR |
|          | 10    | RETRY |
|          | 11    | SPLIT |

---

**Note**: This is a basic AHB master supporting single and burst transfers. Can be extended to support locked transfers, exclusive access, and multiple bus masters with arbitration logic.
