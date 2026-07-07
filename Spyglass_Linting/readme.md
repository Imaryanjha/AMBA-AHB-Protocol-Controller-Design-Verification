<div align="center">

<<img width="1920" height="1080" alt="Screenshot from 2026-07-07 05-23-54" src="https://github.com/user-attachments/assets/ca3d3188-cd98-42a3-af2e-32b3b7271a33" />


**Figure Hirearchy.**

</div>



# 🔍 SpyGlass RTL Analysis Report

## Project Information

| Item | Description |
|------|-------------|
| **Top-Level Design** | `ahb_top` |
| **Tool** | Synopsys SpyGlass |
| **Version** | SpyGlass_vU-2023.03-SP2 |
| **Analysis Type** | RTL Lint, Clock-Reset, ERC, Latch, Power, STARC, Simulation |
| **Report Date** | 07 July 2026 |

---

# 📊 SpyGlass Summary

| Metric | Value |
|---------|------:|
| Total Messages Generated | **11** |
| Reported Messages | **11** |
| Errors | **8** |
| Information Messages | **3** |
| Waived Messages | **0** |
| Overlimit Messages | **0** |

---

# 📌 Design Hierarchy (Elaboration)

The elaborated design consists of the following RTL modules.

| Module | Instance |
|---------|----------|
| `ahb_master` | `ahb_top.u_master` |
| `ahb_decoder` | `ahb_top.u_decoder` |
| `ahb_mux` | `ahb_top.u_mux` |
| `ahb_slave` | `ahb_top.u_slave0` |
| `ahb_slave` | `ahb_top.u_slave1` |
| `ahb_slave` | `ahb_top.u_slave2` |
| `ahb_slave` | `ahb_top.u_slave3` |

---

# 🧩 Address Map (Elaborated Instances)

| Slave | Address Range |
|--------|---------------|
| Slave 0 | `0x0000_0000 – 0x0000_03FF` |
| Slave 1 | `0x0000_0400 – 0x0000_07FF` |
| Slave 2 | `0x0000_0800 – 0x0000_0BFF` |
| Slave 3 | `0x0000_0C00 – 0x0000_0FFF` |

---

# ⚠️ Reported Violations

## 1. Black Box Resolution Errors

SpyGlass reports that the four slave instances were treated as **unsynthesizable black boxes** because synthesis stopped before elaboration.

| Rule | Count |
|------|------:|
| ErrorAnalyzeBBox | **4** |

Affected Instances

- `u_slave0`
- `u_slave1`
- `u_slave2`
- `u_slave3`

---

## 2. SYNTH_5273 Errors

SpyGlass detected that the internal memory array inside `ahb_slave` exceeds the default synthesis threshold (`mthresh`).

| Rule | Count |
|------|------:|
| SYNTH_5273 | **4** |

### Cause

```
Memory 'mem'

Size = 8192 bits

Default mthresh = 4096 bits
```

Since

```
8192 > 4096
```

SpyGlass stopped synthesizing the slave module and marked it as a **black box**.

---

# ✅ Signal Usage Report

The Signal Usage Report shows **no multibit signal usage violations**.

| Rule | Status |
|------|--------|
| W123 | ✅ No Violations |
| W240 | ✅ No Violations |
| W528 | ✅ No Violations |

---

# 📌 Important Observation

The reported SpyGlass errors are **tool configuration related** rather than RTL functional errors.

The slave memory

```
reg [31:0] mem [0:255]
```

contains

```
256 × 32 = 8192 bits
```

which exceeds SpyGlass's default synthesis threshold (`mthresh = 4096`).

As a result,

- the slave modules were not synthesized,
- they were converted into black boxes,
- and cascading `ErrorAnalyzeBBox` messages were generated.

Increasing the `mthresh` value or excluding the memory from synthesis resolves these messages.

---

# ✅ Overall Assessment

| Check | Status |
|--------|--------|
| RTL Elaboration | ✅ Successful |
| Top Module Detected | ✅ `ahb_top` |
| Module Hierarchy | ✅ Correct |
| Address Mapping | ✅ Correct |
| Signal Usage | ✅ Clean |
| Functional RTL Issues | ✅ None Reported |
| SpyGlass Errors | ⚠️ Memory threshold (`mthresh`) limitation |

---

# 📌 Conclusion

The SpyGlass analysis successfully identified the complete RTL hierarchy of the AHB interconnect. The reported errors are caused by the default memory synthesis threshold (`mthresh`) rather than logic or protocol implementation issues. Apart from these configuration-related messages, the RTL hierarchy, module elaboration, address mapping, and signal usage reports are clean and consistent.
