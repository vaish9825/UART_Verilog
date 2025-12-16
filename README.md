# Verilog UART 

A robust **UART (Universal Asynchronous Receiver–Transmitter)** implementation written in Verilog.  
This design features a **parameterized baud rate generator** and a **16× oversampling receiver**, ensuring reliable data synchronization, accurate bit sampling, and improved noise immunity.

---

## ✨ Key Features
- **Modular Architecture:** Clean separation of Transmitter (TX), Receiver (RX), and Baud Rate Generator modules.
- **Reliable Synchronization:** RX module uses **16× oversampling** to sample data at the center of each bit period.
- **Highly Configurable:** Baud rate and system clock frequency are fully parameterized.
- **Simulation Verified:** Validated at **115200 baud** using a self-checking testbench.

---

## 🧪 Simulation Results
The design was verified through functional simulation using a self-checking testbench.

![UART Waveform](sim_wf.jpeg)

*Figure: Simulation waveform demonstrating successful transmission and reception of ASCII character **'A' (0x41)** at 115200 baud.*

---

## 🧩 Module Overview

### 1️⃣ Baud Rate Generator
Generates a timing **tick at 16× the configured baud rate**, enabling precise subdivision of each bit period.  
This tick signal drives both the TX timing and RX oversampling logic.

---

### 2️⃣ UART RX (Receiver)
- **Idle Detection:** Monitors the RX line for a low transition indicating a start bit.
- **Start Bit Validation:** Confirms a valid start bit by sampling at the midpoint (**tick 7/15**).
- **Data Sampling:** Samples each data bit at the center of the bit window (**tick 15/15**) to minimize edge-related instability.
- **Stop Bit Check:** Ensures correct frame completion before asserting data valid.

---

### 3️⃣ UART TX (Transmitter)
- Serializes parallel input data according to the UART frame format.
- Maintains standard UART timing by holding each transmitted bit for **16 tick cycles**.
- Ensures accurate and consistent bit transitions.

---

## ▶️ How to Run
1. Add all Verilog source files from `src/` and testbench files from `tb/` to your simulator  
   *(Vivado, ModelSim, or Icarus Verilog)*.
2. Set `tb_uart` as the top-level module.
3. Run the simulation for **~200 µs** to observe complete TX/RX operation.

