# AHB Slave Module – Architecture Overview

## 1. Architecture

<img width="3772" height="2156" alt="image" src="https://github.com/user-attachments/assets/190e274c-0efb-4522-93de-7a5c42a635bc" />

The AHB slave module interfaces with the AHB bus to respond to read and write transactions from a master. It consists of:

- **FSM Controller**: Manages AHB transaction phases (IDLE, READ, WRITE, BURST, ERROR).
- **Memory Array**: 256 x 32-bit internal storage.
- **Address Decoder**: Maps incoming addresses to memory locations.
- **Control Logic**: Generates response signals (`HREADYOUT`, `HRESP`).
- **Burst Counter**: Tracks burst transfer progress.

---

## 2. Key Signals

### AHB Interface Signals

| Signal       | Direction | Description |
|--------------|-----------|-------------|
| `HCLK`       | Input     | AHB clock |
| `HRESETn`    | Input     | Active-low reset |
| `HSEL`       | Input     | Slave select signal |
| `HADDR`      | Input [31:0] | Address bus |
| `HWDATA`     | Input [31:0] | Write data bus |
| `HRDATA`     | Output [31:0] | Read data bus |
| `HWRITE`     | Input     | 1 = Write, 0 = Read |
| `HSIZE`      | Input [2:0] | Transfer size (byte/halfword/word) |
| `HBURST`     | Input [2:0] | Burst type |
| `HTRANS`     | Input [1:0] | Transfer type (IDLE/BUSY/NONSEQ/SEQ) |
| `HREADYOUT`  | Output    | Slave ready signal |
| `HRESP`      | Output [1:0] | Transfer response (OKAY/ERROR) |

### Parameters

| Parameter   | Default Value | Description |
|-------------|---------------|-------------|
| `BASE_ADDR` | 32'h0000_0000 | Base address of slave |
| `END_ADDR`  | 32'h0000_03FF | End address of slave (1KB space) |

---

## 3. FSM States (5-State)




| State       | Description |
|-------------|-------------|
| `IDLE`      | Waiting for valid transfer (`HTRANS[1]` = 1 and `HSEL` = 1) |
| `READ`      | Single read operation (1 cycle) |
| `WRITE`     | Single write operation (1 cycle) |
| `BURST`     | Burst transfer in progress (up to 4 beats) |
| `ERROR`     | Error state (address out of range) |

---

## 4. State Transition Table

| Current State | Condition                                    | Next State |
|---------------|----------------------------------------------|------------|
| `IDLE`        | `valid_transfer` & `!addr_error` & `HWRITE`  | `WRITE`    |
| `IDLE`        | `valid_transfer` & `!addr_error` & `!HWRITE` | `READ`     |
| `IDLE`        | `valid_transfer` & `addr_error`              | `ERROR`    |
| `WRITE`       | `!burst_mode`                                | `IDLE`     |
| `WRITE`       | `burst_mode`                                 | `BURST`    |
| `READ`        | `!burst_mode`                                | `IDLE`     |
| `READ`        | `burst_mode`                                 | `BURST`    |
| `BURST`       | `burst_count == 3`                           | `IDLE`     |
| `BURST`       | `valid_transfer` & `burst_count < 3`         | `BURST`    |
| `BURST`       | `addr_error`                                 | `ERROR`    |
| `ERROR`       | Always (1 cycle)                             | `IDLE`     |

---

## 5. FSM Diagram 


<img width="1881" height="1237" alt="image" src="https://github.com/user-attachments/assets/d7a8527f-68fa-44ce-a266-a717806476ad" />


---

## 6. Internal Signals

| Signal          | Type   | Description |
|-----------------|--------|-------------|
| `valid_transfer` | Wire   | `HSEL && HTRANS[1]` - Valid transfer indicator |
| `burst_mode`     | Wire   | `HBURST == WRAP4 (010) or INCR4 (011)` |
| `addr_error`     | Wire   | Address outside `BASE_ADDR` to `END_ADDR` range |
| `local_addr`     | Wire   | Mapped memory address `(HADDR - BASE_ADDR) >> 2` |
| `burst_count`    | Reg    | 2-bit counter (0-3) for burst transfers |

---

## 7. Memory Map

| Address Range | Size | Description |
|---------------|------|-------------|
| `BASE_ADDR` to `BASE_ADDR + 0x3FF` | 1KB | Internal memory (256 x 32-bit) |

### Memory Organization
- **Depth**: 256 locations
- **Width**: 32 bits each
- **Access**: Word-aligned only (address offset >> 2)

---

## 8. Burst Types Supported

| HBURST Value | Type | Description | Beats |
|--------------|------|-------------|-------|
| `3'b010`     | WRAP4 | 4-beat wrapping burst | 4 |
| `3'b011`     | INCR4 | 4-beat incrementing burst | 4 |

---

## 9. Response Handling

| Condition | HRESP | HREADYOUT | Description |
|-----------|-------|-----------|-------------|
| Valid address & valid transfer | `0` (OKAY) | `1` | Normal operation |
| Address out of range | `1` (ERROR) | `1` | Error response |
| Invalid transfer | `0` (OKAY) | `1` | Idle state |

---

## 10. Operation Summary

### Single Write
1. **IDLE**: Wait for valid transfer (`HTRANS[1]` = 1).
2. **WRITE**: Write `HWDATA` to memory at `local_addr`.
3. Return to **IDLE** (if single transfer) or go to **BURST** (if burst mode).

### Single Read
1. **IDLE**: Wait for valid transfer (`HTRANS[1]` = 1).
2. **READ**: Read memory at `local_addr` and drive `HRDATA`.
3. Return to **IDLE** (if single transfer) or go to **BURST** (if burst mode).

### Burst Transfer (INCR4/WRAP4)
1. **IDLE** → **BURST**: Enter burst state on first beat.
2. **BURST**: Continue for 4 beats (`burst_count` 0→3).
3. Return to **IDLE** after 4th beat.


