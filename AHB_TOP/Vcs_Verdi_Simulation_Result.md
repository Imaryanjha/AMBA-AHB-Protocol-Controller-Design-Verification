# AHB Top-Level Integration and Data Integrity Verification


<img width="1920" height="1080" alt="tb_top" src="https://github.com/user-attachments/assets/6da8d6f5-5ec3-4305-b323-1aef54b363d5" />


## Description

This waveform demonstrates the functional verification of the complete AHB subsystem by integrating the **AHB Master**, **Address Decoder**, **Read Data Multiplexer**, and multiple **AHB Slaves**. The simulation verifies end-to-end communication through single transfers, burst transfers, address decoding, slave selection, and memory access.

Initially, the master performs a **single write** transaction to address `0x00000004`, writing the data value `0xDEADBEEF`. The Address Decoder decodes the incoming address and asserts the appropriate slave select signal (`HSEL`). The selected slave accepts the write request and stores the data successfully.

The simulation then performs an **INCR4 burst write**, where the master writes four consecutive 32-bit words beginning at address `0x00000400`. The address increments automatically by four bytes for every transfer while `HTRANS` changes from `NONSEQ` for the first beat to `SEQ` for the remaining beats.

Next, the design performs **burst read transactions** from the same memory locations. The selected slave returns the stored data through the Read Data Multiplexer, which forwards the corresponding `HRDATA`, `HREADY`, and `HRESP` signals back to the master.

Finally, a **single read** transaction is executed from address `0x00001500`, returning the expected data value `0x12345678`.

Throughout the simulation, the Address Decoder activates only one slave at a time, the multiplexer forwards the correct slave response, and all transfers complete successfully with `HRESP = OKAY`.

---

# Memory Transactions

| Transaction | Address | Data | Description |
|-------------|---------|------|-------------|
| Single Write | `0x00000004` | `0xDEADBEEF` | Write to Slave Memory |
| Burst Write | `0x00000400` | `0x11111111` | INCR4 Burst Beat-1 |
| Burst Write | `0x00000800` | `0x22222222` | INCR4 Burst Beat-2 |
| Burst Write | `0x00000C00` | `0x33333333` | INCR4 Burst Beat-3 |
| Burst Read | `0x00000400` | `0xAAAA0001` | Data returned from Slave |
| Burst Read | `0x00000800` | `0xBBBB0001` | Data returned from Slave |
| Single Read | `0x00001500` | `0x12345678` | Final Read Transaction |

---

# Functional Blocks Verified

| Module | Function Verified |
|---------|-------------------|
| AHB Master | Address generation, control signal generation, read/write operations |
| Address Decoder | Slave selection based on address |
| AHB Slaves | Memory read/write operations |
| Read Data Multiplexer | HRDATA, HREADY and HRESP selection |
| AHB Top | End-to-end system integration |

---

# Features Verified

- Single write transaction
- Single read transaction
- INCR4 burst transfer
- Address decoding
- One-hot slave selection
- Read data multiplexing
- Write data transfer
- Read data transfer
- Multi-slave communication
- HREADY response handling
- HRESP OKAY response
- End-to-end data integrity verification
- Complete AHB subsystem integration

---

# Data Integrity Verification

The data written into the slave memory is successfully retrieved during the corresponding read transactions.

| Write Address | Written Data | Read Data | Status |
|---------------|-------------|-----------|--------|
| `0x00000004` | `0xDEADBEEF` | `0xDEADBEEF` | PASS |
| `0x00000400` | `0x11111111` | `0x11111111` | PASS |
| `0x00000800` | `0x22222222` | `0x22222222` | PASS |
| `0x00000C00` | `0x33333333` | `0x33333333` | PASS |
| `0x00001500` | `0x12345678` | `0x12345678` | PASS |

---

# Observation

The waveform confirms successful integration of the AHB Master, Address Decoder, Read Data Multiplexer, and multiple AHB Slaves. Address decoding correctly selects the target slave, write data is stored in the appropriate memory location, and subsequent read transactions return the same data, confirming end-to-end data integrity. The successful completion of all single and burst transactions with `HRESP = OKAY` demonstrates protocol compliance and functional correctness of the complete AHB subsystem.
