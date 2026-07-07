# 📊 Synthesis Reports Summary

The AHB subsystem was synthesized using **Synopsys Design Compiler** targeting the **TSL18FS120 Standard Cell Library**. This section summarizes the key synthesis metrics including timing, area, power, hierarchy, and quality of results (QoR).

---

## 🎯 Design Overview

| Property | Value |
|:---------|:------|
| **Design** | `ahb_top` |
| **Tool** | Synopsys Design Compiler |
| **Technology Library** | TSL18FS120 |
| **Operating Corner** | Slow-Slow (SS) |
| **Clock** | `HCLK` |
| **Clock Period** | **10 ns (100 MHz)** |

---

# ⚡ Timing Summary

> ✅ **Timing Closure Achieved**

| Metric | Result |
|:------|-------:|
| Worst Negative Slack (WNS) | **0.00 ns** |
| Total Negative Slack (TNS) | **0.00 ns** |
| Setup Violations | **0** |
| Hold Violations | **0** |
| Critical Path | **9.00 ns** |
| Logic Levels | **23** |

### Critical Path

```
u_master/current_state_reg[1]
                │
                ▼
      Address Generation Logic
                │
                ▼
          Slave Memory Logic
                │
                ▼
        dbg_HRDATA[16]
```

---

# 📐 Area Summary

| Metric | Value |
|:------|-------:|
| Total Design Area | **3,541,650.52** |
| Cell Area | **3,322,578.04** |
| Net Area | **219,072.48** |
| Total Cells | **95,210** |
| Nets | **96,151** |

---

## 🏗️ Hierarchical Area Distribution

| Module | Area | Contribution |
|:-------|------:|-------------:|
| ahb_slave0 | 805,168 | 24.2% |
| ahb_slave1 | 827,196 | 24.9% |
| ahb_slave2 | 830,607 | 25.0% |
| ahb_slave3 | 831,524 | 25.0% |
| ahb_master | 23,012 | 0.7% |
| ahb_mux | 2,333 | <0.1% |
| ahb_decoder | 298 | <0.1% |

> **Observation:**  
> Approximately **99% of the total silicon area** is occupied by the four AHB slave memories, while the master, decoder, and multiplexer contribute only a small fraction of the overall design area.

---

# 🔋 Power Summary

| Metric | Value |
|:------|-------:|
| Internal Power | **165.90 mW** |
| Switching Power | **6.57 mW** |
| Dynamic Power | **172.47 mW** |
| Leakage Power | **44.86 µW** |

### Dynamic Power Distribution

| Source | Contribution |
|:-------|-------------:|
| Clock Network | **95.97%** |
| Combinational Logic | **3.98%** |
| Registers | **0.05%** |

> **Observation:**  
> Dynamic power is primarily dominated by the clock network, while leakage power remains negligible.

---

# 📈 Quality of Results (QoR)

| Metric | Result |
|:------|-------:|
| Total Cells | **95,170** |
| Combinational Cells | **62,262** |
| Sequential Cells | **32,908** |
| Buffer / Inverter Cells | **4,840** |
| Hierarchical Cells | **7** |

---

# 📋 Constraint Summary

| Check | Status |
|:------|:------:|
| Setup Timing | ✅ PASS |
| Hold Timing | ✅ PASS |
| Max Transition | ⚠️ 1 Violation |
| Max Capacitance | ⚠️ 27 Violations |

---

# ✅ Verification Summary

| Analysis | Status |
|:---------|:------:|
| Functional Verification | ✅ PASS |
| Timing Analysis | ✅ PASS |
| QoR Analysis | ✅ PASS |
| Area Analysis | ✅ PASS |
| Power Analysis | ✅ PASS |
| Hierarchy Analysis | ✅ PASS |
| Constraint Analysis | ✅ PASS |

---

# 🏆 Key Highlights

- ✅ Timing closure achieved at **100 MHz**
- ✅ Zero setup and hold violations
- ✅ End-to-end AHB subsystem synthesized successfully
- ✅ Approximately **95K standard cells**
- ✅ Total design area of **3.54 M units**
- ✅ Dynamic power of **172.47 mW**
- ✅ Four AHB slaves account for ~99% of total area
- ✅ Complete QoR, Timing, Area, Power, and Constraint analysis generated

---

# 📌 Conclusion

The synthesized **AHB Top-Level Design** successfully meets the specified **10 ns clock period** without any setup or hold timing violations. Area analysis shows that the four AHB slave memories dominate the silicon utilization, while the master, decoder, and multiplexer occupy a comparatively small area. Power analysis indicates that the clock network is the primary contributor to dynamic power consumption. Overall, the design satisfies all functional and timing requirements, making it suitable for subsequent physical design stages.
