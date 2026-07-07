# AMBA-AHB-Protocol-Controller-Design-Verification
Designed an AMBA-AHB compliant bus architecture including Master, Slave, Decoder, and Multiplexer modules in Verilog HDL. Implemented FSMs for protocol-driven single and burst transactions. Verified functionality using custom testbenches, VCS simulation, and Verdi waveform analysis. Performed RTL linting using SpyGlass.

---

<img width="1920" height="1080" alt="Screenshot from 2026-07-07 04-05-55" src="https://github.com/user-attachments/assets/c08ac9a3-08fd-4e09-88da-9323b92c7f8f" />


## Project Overview

The AMBA Advanced High-performance Bus (AHB) is a high-speed pipelined bus protocol developed by ARM for efficient communication between processors, memories, and high-performance peripherals in modern SoCs.

This project implements the complete RTL architecture of an AHB subsystem including the Master, Slave, Address Decoder, and Multiplexer modules while supporting protocol-compliant single and burst transfers.

The objective is to gain hands-on experience in RTL design, finite state machine implementation, protocol verification, and ASIC synthesis flow.

---

## 📂 Repository Structure

```text
AMBA_AHB_BUS/
│
├── 📁 AHB_DECODE/
│   ├── Verdi_Vcs_Simulation_Results.md
│   ├── ahb_decoder.v
│   └── tb_ahb_decoder.v
│
├── 📁 AHB_MASTER/
│   ├── AHB_MASTER_FSM.pdf
│   ├── Vcs_Verdi_Simulation_Results.md
│   ├── ahb_master.v
│   ├── tb_ahb_master.v
│   └── README.md
│
├── 📁 AHB_MULTIPLEXER/
│   ├── Vcs_Verdi_Simulation_Results.md
│   ├── ahb_mux.v
│   └── tb_ahb_mux.v
│
├── 📁 AHB_SLAVE/
│   ├── README.md
│   ├── Vcs_Verdi_Simulation_Results.md
│   ├── ahb_slave.v
│   └── tb_ahb_slave.v
│
├── 📁 AHB_TOP/
│   ├── Vcs_Verdi_Simulation_Results.md
│   ├── ahb_top.v
│   └── tb_ahb_top.v
│
├── 📁 DC_SYNTHESIS/
│   ├── README.md
│   ├── ahb_top.tcl
│   ├── area.rpt
│   ├── area_hier.rpt
│   ├── constraints.rpt
│   ├── hierarchy.rpt
│   ├── power.rpt
│   ├── qor.rpt
│   ├── timing.rpt
│   └── timing_top20.rpt
│
├── 📁 Spyglass_Linting/
│   ├── README.md
│   ├── elab_summary.rpt
│   ├── summary.rpt
│   ├── spyglass_violations.rpt
│   └── SignalUsageReport.rpt
│
└── 📄 README.md
```

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

<img width="1103" height="425" alt="image" src="https://github.com/user-attachments/assets/1685925f-1a78-44ec-ba9b-6677ae6c73b2" />


## Interconnect Diagram

<img width="1028" height="838" alt="image" src="https://github.com/user-attachments/assets/6c66923e-94f1-47e5-ba86-ce5db7d9f27b" />


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

<img width="1920" height="1080" alt="Screenshot from 2026-07-05 06-25-22 (1)" src="https://github.com/user-attachments/assets/19ff7097-67bb-4155-8ec0-049cc2efcb30" />






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


---

## Tools Used

| Category | Tool |
|----------|------|
| RTL Design | Verilog HDL |
| Simulation | Synopsys VCS |
| Debug | Verdi |
| Lint | SpyGlass |
| Synthesis | Synopsys Design Compiler |


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



---

## References

- ARM AMBA 2.0 AHB Specification
- Synopsys Design Compiler Documentation
- SpyGlass User Guide
