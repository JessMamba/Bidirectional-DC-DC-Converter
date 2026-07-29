# Three-Stage Cubic Bidirectional DC-DC Converter for Renewable Energy & Battery Storage Systems

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status: Hardware Prototype Ready](https://img.shields.io/badge/Status-Prototype%20Fabricated-success.svg)](#9-pcb-design--hardware-implementation)
[![Topology: Three-Stage Cubic](https://img.shields.io/badge/Topology-Three--Stage%20Cubic-orange.svg)](#2-converter-topology--operating-principles)
[![Efficiency: 94.16%](https://img.shields.io/badge/Peak%20Efficiency-94.16%25-brightgreen.svg)](#44-comparative-analysis)

A high-gain, non-isolated, high-efficiency **Three-Stage Cubic Bidirectional DC-DC Converter** designed for renewable energy systems, battery energy storage systems (BESS), and electric vehicle (EV) microgrid interfaces (V2G/G2V). 

This repository contains full theoretical derivations (CCM/DCM), circuit parameter calculations, 3D MATLAB optimization surface scripts, mode-dependent closed-loop PID controller designs, PSCAD simulation models, and KiCad PCB designs/Gerber files with hardware prototype implementation details.

---

## 📌 Table of Contents
- [1. Executive Summary](#1-executive-summary)
- [2. Key Features & Specifications](#2-key-features--specifications)
- [3. Converter Topology & Operating Principles](#3-converter-topology--operating-principles)
  - [3.1 Step-Up (Boost) Mode](#31-step-up-boost-mode)
  - [3.2 Step-Down (Buck) Mode](#32-step-down-buck-mode)
- [4. Mathematical Modeling & Component Calculations](#4-mathematical-modeling--component-calculations)
  - [4.1 Voltage Gain Expressions](#41-voltage-gain-expressions)
  - [4.2 Inductor & Capacitor Dimensioning](#42-inductor--capacitor-dimensioning)
  - [4.3 Switch Voltage and Current Stress Analysis](#43-switch-voltage-and-current-stress-analysis)
  - [4.4 Comparative Analysis](#44-comparative-analysis)
- [5. Mode-Dependent Closed-Loop PID Controller Design](#5-mode-dependent-closed-loop-pid-controller-design)
  - [5.1 Buck Mode Controller](#51-buck-mode-controller)
  - [5.2 Boost Mode Controller](#52-boost-mode-controller)
  - [5.3 MATLAB Closed-Loop Verification](#53-matlab-closed-loop-verification)
- [6. PSCAD Simulation & Results](#6-pscad-simulation--results)
- [7. Hardware Bill of Materials (BOM)](#7-hardware-bill-of-materials-bom)
- [8. PCB Design & Hardware Implementation](#8-pcb-design--hardware-implementation)
- [9. Repository Structure](#9-repository-structure)
- [10. References](#10-references)

---

## 1. Executive Summary

Conventional boost and buck converters suffer from extreme duty cycle requirements, excessive semiconductor stress, and sharp efficiency degradation when operating at large voltage conversion ratios. To eliminate these constraints, this project proposes a **Three-Stage Cubic Bidirectional DC-DC Converter**. 

By leveraging a cubic voltage transfer ratio ($M_{	ext{Boost}} = rac{1}{(1-D)^3}$ and $M_{	ext{Buck}} = D^3$), the converter achieves a wide voltage conversion range (**24V DC $\leftrightarrow$ 300V DC**) at moderate duty cycles ($D_{	ext{Boost}} = 0.57$, $D_{	ext{Buck}} = 0.43$) while maintaining lower voltage and current stresses on power MOSFETs. The topology utilizes **6 MOSFET switches, 4 capacitors, and 3 inductors**, achieving a calculated peak efficiency of **94.16%** due to reduced switching losses (only 1 or 2 switches actively triggered in each sub-interval).

---

## 2. Key Features & Specifications

| Parameter | Symbol | Nominal Value | Unit |
| :--- | :--- | :--- | :--- |
| **Rated Power** | $P_{o}$ | **900** | W |
| **Low Voltage Side (LV)** | $V_{LV}$ | **24** | V |
| **High Voltage Side (HV)** | $V_{HV}$ | **300** | V |
| **Switching Frequency** | $f_s$ | **50** | kHz |
| **Peak Efficiency** | $\eta_{	ext{peak}}$ | **94.16** | % |
| **Boost Duty Cycle ($24	ext{V}	o300	ext{V}$)** | $D_{	ext{boost}}$ | **0.5703** | - |
| **Buck Duty Cycle ($300	ext{V}	o24	ext{V}$)** | $D_{	ext{buck}}$ | **0.4305** | - |
| **Maximum Duty Cycle Limit** | $D_{	ext{max}}$ | **0.90** | - |
| **Ground Topology** | - | **Common Ground** | - |

---

## 3. Converter Topology & Operating Principles

The converter consists of three energy storage inductors ($L_1, L_2, L_3$), two intermediate energy transfer capacitors ($C_1, C_2$), input/output filtering capacitors ($C_L, C_H$), and 6 MOSFET switches ($S_1, S_2, S_3, S_4, S_5, S_6$) configured for bidirectional power flow.

```
                  +--------------------[ S1 ]-------------------+
                  |                                             |
                  |          S2                     S3          |
  [LV Input] -----+---(L1)---[--]---+---(L2)---[--]----+        |
  (24V DC)        |                 |                  |        |
                  |                --- C1             --- C2    |
                 --- CL            ---                ---       |
                 ---                |                  |        |
                  |                GND         [S4]----+---(L3)-+---[S6]---+--- [HV Output]
                  |                             |               |          |    (300V DC)
                  |                            GND             [S5]       --- CH
                  |                                             |         ---
                  +---------------------------------------------+----------+--- GND
```

### 3.1 Step-Up (Boost) Mode
Energy flows from Low Voltage ($V_{LV} = 24	ext{V}$) to High Voltage ($V_{HV} = 300	ext{V}$).
- **State 1 ($0 \le t < D T_s$):** Switches $S_1, S_4, S_5$ are ON; body diodes $D_1, D_2, D_3$ are reverse-biased. $L_1$ is magnetized by $V_{LV}$, while $L_2$ and $L_3$ are magnetized by intermediate capacitors $C_1$ and $C_2$. All inductor currents increase linearly.
- **State 2 ($D T_s \le t < T_s$):** Switches $S_1, S_4, S_5$ are OFF; body diodes $D_1, D_2, D_3$ conduct. Stored energy is transferred forward: $L_1$ charges $C_1$, $L_2$ charges $C_2$, and $L_3$ feeds the HV load and output filtering capacitor $C_H$.

### 3.2 Step-Down (Buck) Mode
Energy flows from High Voltage ($V_{HV} = 300	ext{V}$) to Low Voltage ($V_{LV} = 24	ext{V}$).
- **State 1 ($0 \le t < D T_s$):** Switches $S_2, S_3, S_6$ are ON. $L_3$ is energized by $V_{HV}$, and $L_2, L_1$ are energized by intermediate capacitors $C_2, C_1$. Inductor currents ramp up linearly.
- **State 2 ($D T_s \le t < T_s$):** Switches $S_2, S_3, S_6$ are OFF; body diodes $D_1, D_4, D_5$ conduct. Energy is demagnetized toward the LV side: $L_3 	o C_2$, $L_2 	o C_1$, and $L_1 	o R_{	ext{load}}$ (LV side).

---

## 4. Mathematical Modeling & Component Calculations

### 4.1 Voltage Gain Expressions

#### Continuous Conduction Mode (CCM)
- **Intermediate Capacitor Voltages (Boost):**
  $$V_{C1} = rac{V_{LV}}{1-D}, \quad V_{C2} = rac{V_{LV}}{(1-D)^2}$$
- **Intermediate Capacitor Voltages (Buck):**
  $$V_{C2} = D \cdot V_{HV}, \quad V_{C1} = D^2 \cdot V_{HV}$$
- **Cubic Voltage Transfer Ratio (VTR):**
  $$M_{	ext{CCM, Step-Up}} = rac{V_{HV}}{V_{LV}} = rac{1}{(1-D)^3}$$
  $$M_{	ext{CCM, Step-Down}} = rac{V_{LV}}{V_{HV}} = D^3$$

#### Discontinuous Conduction Mode (DCM)
- **Step-Up Mode DCM Gain:**
  $$M_{	ext{DCM, Step-Up}} = rac{V_{HV}}{V_{LV}} = rac{(D+D_1)(D+D_2)(D+D_3)}{D_1 (D D_2 + D_2 D_3 - D D_3)}$$
- **Step-Down Mode DCM Gain:**
  $$M_{	ext{DCM, Step-Down}} = rac{V_{LV}}{V_{HV}} = rac{D^2 (D + D_3 - D_2)}{(D + D_1)(D + D_2)(D + D_3)}$$

### 4.2 Inductor & Capacitor Dimensioning

Inductances and capacitances are dimensioned analytically to ensure robust CCM operation with current and voltage ripple $<1\%$:

$$L_1 \ge rac{D_{	ext{boost}} V_{LV}}{\Delta i_{L1} f_s}, \quad L_2 \ge rac{D_{	ext{boost}} V_{LV}}{(1-D_{	ext{boost}}) \Delta i_{L2} f_s}, \quad L_3 \ge rac{D_{	ext{boost}} V_{LV}}{(1-D_{	ext{boost}})^2 \Delta i_{L3} f_s}$$

| Component | Minimum Calculated (Boost) | Minimum Calculated (Buck) | Selected Hardware Value |
| :--- | :--- | :--- | :--- |
| **Inductor $L_1$** | $0.3898	ext{ mH}$ | $0.2282	ext{ mH}$ | **$330\ \mu	ext{H}$ / High Current Toroid** |
| **Inductor $L_2$** | $0.7418	ext{ mH}$ | $0.5940	ext{ mH}$ | **$330\ \mu	ext{H}$ / High Current Toroid** |
| **Inductor $L_3$** | $1.1200	ext{ mH}$ | $1.1390	ext{ mH}$ | **$330\ \mu	ext{H}$ / High Current Toroid** |
| **Capacitor $C_1$** | $9.221\ \mu	ext{F}$ | $9.018\ \mu	ext{F}$ | **$110\ \mu	ext{F}$ / 100V Electrolytic** |
| **Capacitor $C_2$** | $9.518\ \mu	ext{F}$ | $9.225\ \mu	ext{F}$ | **$110\ \mu	ext{F}$ / 250V Electrolytic** |
| **Filtering $C_H$** | $4.276\ \mu	ext{F}$ | $1.460\ \mu	ext{F}$ | **$470\ \mu	ext{F}$ / 500V Electrolytic** |
| **Filtering $C_L$** | $25.10\ \mu	ext{F}$ | $7.726\ \mu	ext{F}$ | **$470\ \mu	ext{F}$ / 100V Electrolytic** |

---

### 4.3 Switch Voltage and Current Stress Analysis

Total Voltage Stress (TVS) and Total Current Stress (TCS) are minimized due to intermediate stage capacitor sharing:
$$	ext{TVS} = 3 V_{HV}, \quad 	ext{TCS} = 3 I_{LV}$$

- **High Voltage Switches ($S_1, S_5, S_6$):** Block full output voltage $V_{HV}  pprox 300	ext{V}$. Selected: **SRC65R032FB Super-Junction MOSFETs (650V, 88A, $R_{DS(on)} = 32	ext{m}\Omega$)**.
- **Intermediate Stage Switches ($S_2, S_3, S_4$):** Block reduced stage voltages ($V_{C1}, V_{C2}$). Selected: **IRFP4227PBF Power MOSFETs (200V, 65A, $R_{DS(on)} = 21	ext{m}\Omega$)**.

---

### 4.4 Comparative Analysis

| Feature / Topology | Ref [1] | Ref [2] | Ref [3] | Ref [4] | **Proposed Converter** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Element Count ($S-C-L$)** | $4-1-2$ | $4-2-2$ | $5-3-2$ | $4-3-1$ | **$6-4-3$** |
| **Step-Down Gain** | $D$ | $D/4$ | $D/2$ | $D^2$ | **$D^3$ (Cubic)** |
| **Step-Up Gain** | $rac{1}{1-D}$ | $rac{4}{1-D}$ | $rac{2}{1-D}$ | $rac{1}{(1-D)^2}$ | **$rac{1}{(1-D)^3}$ (Cubic)** |
| **Common Ground** | Yes | Yes | No | Yes | **Yes** |
| **Rated Power [W]** | $500$ | $500$ | $500$ | $1000$ | **$900$** |
| **Switching Freq. [kHz]** | $50$ | $100$ | $50$ | $50$ | **$50$** |
| **Peak Efficiency [%]** | $95.8\%$ | $96.0\%$ | $95.6\%$ | $96.8\%$ | **$94.16\%$** |

---

## 5. Mode-Dependent Closed-Loop PID Controller Design

Since the open-loop transient response exhibits significant overshoot (>135% in Buck, ~48.6% in Boost) and steady-state error, a **Mode-Dependent PID Control Strategy** is implemented with distinct coefficients for Buck and Boost operations.

### 5.1 Buck Mode Controller
- **Plant Transfer Function (Open-Loop Approx.):**
  $$G_{p,	ext{Buck}}(s) = rac{7.90 	imes 10^6}{s^2 + 1158 s + 8.32 	imes 10^6}$$
- **Target Specs:** Overshoot $M_p \le 5\%$, Settling Time $t_s \le 7	ext{ ms}$, $\zeta_d = 0.69$, $\omega_{n,d} = 828	ext{ rad/s}$. Third pole $p_3 = 8280	ext{ rad/s}$.
- **PID Parameters:**
  $$K_{p,	ext{Buck}} = 0.2312, \quad K_{i,	ext{Buck}} = 718.56, \quad K_{d,	ext{Buck}} = 0.001046$$

### 5.2 Boost Mode Controller
- **Plant Transfer Function (Open-Loop Approx.):**
  $$G_{p,	ext{Boost}}(s) = rac{16781.4}{s^2 + 57.73 s + 16624.5}$$
- **Target Specs:** Overshoot $M_p \le 5\%$, Settling Time $t_s \le 50	ext{ ms}$, $\zeta_d = 0.69$, $\omega_{n,d} = 115.94	ext{ rad/s}$. Third pole $p_3 = 579.71	ext{ rad/s}$.
- **PID Parameters:**
  $$K_{p,	ext{Boost}} = 5.338, \quad K_{i,	ext{Boost}} = 464.37, \quad K_{d,	ext{Boost}} = 0.04064$$

### 5.3 MATLAB Closed-Loop Verification

| Metric | Buck Open-Loop | Buck PID Closed-Loop | Boost Open-Loop | Boost PID Closed-Loop |
| :--- | :--- | :--- | :--- | :--- |
| **Reference Voltage** | $24.0	ext{V}$ | **$24.000	ext{V}$** | $300.0	ext{V}$ | **$300.000	ext{V}$** |
| **Peak Voltage** | $54.11	ext{V}$ | **$24.61	ext{V}$** | $453.28	ext{V}$ | **$307.44	ext{V}$** |
| **Maximum Overshoot**| $135.5\%$ | **$2.56\%$** | $48.6\%$ | **$2.48\%$** |
| **Settling Time ($t_s, 2\%$)**| $6.9	ext{ ms}$ | **$7.69	ext{ ms}$** | $138.6	ext{ ms}$ | **$33.87	ext{ ms}$** |
| **Steady-State Error** | $1.236	ext{V}$ (5.15%) | **$ pprox 0	ext{V}$** | $-2.832	ext{V}$ (0.94%)| **$ pprox 0	ext{V}$** |

---

## 6. PSCAD Simulation & Results

Full switching circuit topologies for both **Boost** ($24	ext{V} 	o 300	ext{V}$, $D=0.57$) and **Buck** ($300	ext{V} 	o 24	ext{V}$, $D=0.43$) were modeled in PSCAD.

Key simulation highlights:
1. **Continuous Conduction Mode (CCM):** Inductor currents $I_{L1}, I_{L2}, I_{L3}$ remain strictly positive across all switching cycles without reaching zero.
2. **Capacitor Voltage Stresses:** Intermediate capacitor voltages $V_{C1}$ and $V_{C2}$ align perfectly with quadratic/linear theoretical derivations ($V_{C1}=54	ext{V}$, $V_{C2}=127	ext{V}$).
3. **MOSFET Voltage Blocking:** High-side switches ($S_1, S_5, S_6$) reliably block $300	ext{V}$ peak DC line voltage, whereas intermediate stage switches ($S_2, S_3, S_4$) operate under reduced stress ($<135	ext{V}$).

---

## 7. Hardware Bill of Materials (BOM)

| Designator | Component / Part | Specification / Value | Package | Manufacturer / Link |
| :--- | :--- | :--- | :--- | :--- |
| **Q1, Q5, Q6** | SRC65R032FB | Super-Junction N-Ch MOSFET (650V, 88A, $32	ext{m}\Omega$) | TO-247 | [Datasheet Link](https://www.ulutaselektronik.com/urun/src65r032fb-32m-88a-650v-super-junction-n-channel-power-mosfet) |
| **Q2, Q3, Q4** | IRFP4227PBF | Power N-Ch MOSFET (200V, 65A, $21	ext{m}\Omega$) | TO-247 | [Datasheet Link](https://www.ulutaselektronik.com/urun/irfp4227pbf-to-247-65a-200v-mosfet) |
| **L1, L2, L3** | Custom Toroidal Inductors | $330\ \mu	ext{H}$, High Current Ferrite Core | Radial | Custom Wound |
| **C1, C2** | Electrolytic Capacitors | $110\ \mu	ext{F}$ / 100V & 250V | Radial | Standard Industrial |
| **CL, CH** | Filtering Capacitors | $470\ \mu	ext{F}$ / 100V & 500V | Radial | Standard Industrial |
| **J1-J16** | High Current Screw Terminals | 2-Pin Screw Terminal Connectors | 5.08mm Pitch | Standard |

---

## 8. PCB Design & Hardware Implementation

The hardware prototype was designed using **KiCad Electronic Design Suite**, obeying high-frequency power electronics layout rules:
- **Loop Area Minimization:** Reduced parasitic trace inductance to suppress voltage spikes across switch nodes.
- **Thermal & Current Routing:** Heavy copper pours on power traces to withstand currents up to $22.3	ext{A}$.
- **PCB Fabrication Cost:** Gerber files optimized and manufactured at industrial standards ($15/board).
- **Physical Assembly:** Components hand-soldered in the Electrical & Electronics Engineering Laboratory at Bursa Technical University.

---

## 9. Repository Structure

```
├── docs/
│   ├── Bidirectional_DC_DC_Converter_Project_Report.pdf  # Full Turkish Graduation Project Report
│   └── PCB_Schematics_and_3D_Render.png                  # KiCad 3D layout views
├── hardware/
│   ├── KiCad_Project/                                    # KiCad Schematics & PCB layout files
│   ├── Gerbers/                                          # Production-ready Gerber manufacturing files
│   └── BOM.csv                                           # Bill of Materials
├── matlab/
│   ├── passive_components_3d_surfaces.m                  # 3D parameter optimization scripts
│   ├── PID_Buck_ClosedLoop.m                             # Buck mode PID verification script
│   └── PID_Boost_ClosedLoop.m                            # Boost mode PID verification script
├── simulation/
│   ├── PSCAD_Boost_Circuit.pscx                          # PSCAD Boost mode simulation model
│   └── PSCAD_Buck_Circuit.pscx                           # PSCAD Buck mode simulation model
├── LICENSE                                               # MIT License
└── README.md                                             # Project README file
```

---

## 10. References

1. S. Sarani and X. Liang, "Non-Isolated High Voltage Gain Bidirectional DC-DC Converters: A Review," in *Proceedings of the IEEE Industry Applications Society Annual Meeting (IAS)*, 2024, pp. 1-7, doi: [10.1109/IAS55788.2024.11023749](https://doi.org/10.1109/IAS55788.2024.11023749).
2. K. Zhou, K. Xu, and Y. Sun, "Bidirectional DC/DC Converter Based on Interleaved Parallel Buck/Boost Cascades CLLLC," *International Journal of Circuit Theory and Applications*, vol. 53, no. 8, pp. 4455-4474, 2025, doi: [10.1002/cta.4363](https://doi.org/10.1002/cta.4363).
3. M. T. Talluri and V. Karthikeyan, "Regenerative Switched-Inductor/Capacitor Configuration-Based Cubic Bidirectional DC-DC Converter for EV Applications," *IEEE Journal of Emerging and Selected Topics in Industrial Electronics*, early access, 2025, doi: [10.1109/JESTIE.2025.3607163](https://doi.org/10.1109/JESTIE.2025.3607163).
4. R. Kallelapu, S. Peddapati, and S. V. K. Naresh, "A Family of Non-Isolated Quadratic Buck-Boost Bidirectional Converters With Reduced Current Ripple for EV Charger Applications," *IEEE Transactions on Power Electronics*, early access, 2025, doi: [10.1109/TPEL.2025.3592387](https://doi.org/10.1109/TPEL.2025.3592387).

---
*Developed as a Senior Capstone Project at Bursa Technical University, Department of Electrical & Electronics Engineering.*
