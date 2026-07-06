# AMBA-AHB-Protocol-Controller-Design-Verification
Designed an AMBA-AHB compliant bus architecture including Master, Slave, Decoder, and Multiplexer modules in Verilog HDL. Implemented FSMs for protocol-driven single and burst transactions. Verified functionality using custom testbenches, VCS simulation, and Verdi waveform analysis. Performed RTL linting using SpyGlass.

---

## Project Overview

The AMBA Advanced High-performance Bus (AHB) is a high-speed pipelined bus protocol developed by ARM for efficient communication between processors, memories, and high-performance peripherals in modern SoCs.

This project implements the complete RTL architecture of an AHB subsystem including the Master, Slave, Address Decoder, and Multiplexer modules while supporting protocol-compliant single and burst transfers.

The objective is to gain hands-on experience in RTL design, finite state machine implementation, protocol verification, and ASIC synthesis flow.

---

## Features

- AMBA-AHB compliant RTL implementation
- Parameterized Verilog design
- Modular architecture
- Single Read/Write transactions
- Incrementing Burst Transfers
- Wait State Handling
- Ready/Response Generation
- Address Decoding
- Read Data Multiplexing
- FSM-based protocol control
- Fully synthesizable RTL

---

## Architecture

```
                     +----------------------+
                     |      AHB Master      |
                     +----------+-----------+
                                |
                                |
                HADDR HWRITE HTRANS HSIZE HBURST
                                |
                                |
               +----------------+----------------+
               |                                 |
               |        Address Decoder          |
               |                                 |
               +----------------+----------------+
                                |
            -----------------------------------------
            |                    |                  |
            |                    |                  |
      +------------+      +------------+     +------------+
      |  Slave 0   |      |  Slave 1   | ... |  Slave N   |
      +------------+      +------------+     +------------+
            |                    |                  |
            ----------------+----+------------------
                             |
                      Read Data MUX
                             |
                             |
                        HRDATA Output
```

---

## Project Modules

### AHB Master

- Generates bus transactions
- Controls address and data phase
- Supports single and burst transfers
- Implements protocol FSM

### AHB Slave

- Receives bus requests
- Generates HREADYOUT
- Generates HRESP
- Performs read/write operations

### Address Decoder

- Decodes HADDR
- Selects target slave
- Generates slave select signals

### Read Data Multiplexer

- Selects HRDATA
- Selects HREADY
- Selects HRESP

---

## Supported Transactions

- Single Write
- Single Read
- Incrementing Burst
- Wait State Insertion
- Back-to-back Transfers

---

## Finite State Machine

Master Controller States

```
IDLE
  |
  V
ADDRESS_PHASE
  |
  V
DATA_PHASE
  |
  +------+
  |      |
  V      |
BURST    |
  |      |
  +------+
  |
  V
IDLE
```

---

## Verification

The design is verified using custom Verilog testbenches.

Verification includes

- Single Write
- Single Read
- Burst Transactions
- Address Decoding
- Slave Selection
- Wait State Handling
- Protocol Compliance
- Corner Case Testing

Simulation Tools

- Synopsys VCS
- Verdi Waveform Debugger

---

## RTL Quality Checks

SpyGlass is used for

- RTL Lint
- Coding Style Checks
- Unconnected Signals
- Multiple Driver Detection
- FSM Analysis
- Synthesizability Checks

---

## ASIC Synthesis

The RTL is synthesized using

- Synopsys Design Compiler

Target Technology

- 180 nm Standard Cell Library

Reports Generated

- Area Report
- Timing Report
- Cell Utilization
- QoR Report

---

## Repository Structure

```
AMBA-AHB-Controller/
│
├── rtl/
│   ├── ahb_master.v
│   ├── ahb_slave.v
│   ├── decoder.v
│   ├── mux.v
│   ├── top.v
│
├── tb/
│   ├── ahb_tb.v
│
├── waveforms/
│
├── spyglass/
│
├── synthesis/
│
├── constraints/
│   ├── top.sdc
│
├── reports/
│
├── docs/
│
└── README.md
```

---

## Tools Used

| Category | Tool |
|----------|------|
| RTL Design | Verilog HDL |
| Simulation | Synopsys VCS |
| Debug | Verdi |
| Lint | SpyGlass |
| Synthesis | Synopsys Design Compiler |
| Version Control | Git |

---

## Current Status

- RTL Design ✅
- Master FSM ✅
- Slave RTL ✅
- Decoder ✅
- Multiplexer ✅
- Testbench Development ✅
- Functional Verification ✅
- SpyGlass Linting ✅
- Design Compiler Synthesis 🔄
- Timing Analysis 🔄

---

## Future Improvements

- BUS Matrix Support
- Multiple Masters
- Split Transactions
- Retry Response
- Parameterized Address Width
- Parameterized Data Width
- UVM Testbench
- Functional Coverage
- Assertion-Based Verification
- Gate-Level Simulation

---

## Learning Outcomes

Through this project I gained practical experience in

- RTL Design
- Finite State Machine Design
- AMBA-AHB Protocol
- ASIC Verification Flow
- RTL Linting
- ASIC Synthesis
- Timing Analysis
- Waveform Debugging
- Modular Verilog Design
- Industrial RTL Coding Practices

---

## References

- ARM AMBA 2.0 AHB Specification
- Synopsys Design Compiler Documentation
- SpyGlass User Guide
