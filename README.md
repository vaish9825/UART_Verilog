# Verilog UART with 16x Oversampling

A robust UART (Universal Asynchronous Receiver-Transmitter) implementation in Verilog. This project features a parameterized baud rate generator and uses **16x oversampling** logic for the receiver to ensure stable data synchronization and noise immunity.

## Features
* **Modular Design:** Separate TX, RX, and Baud Rate Generator modules.
* **Robust Synchronization:** Receiver uses 16x oversampling to capture data at the center of the bit period.
* **Configurable:** Baud rate and Clock frequency are parameterized.
* **Verified:** Validated via simulation at 115200 Baud.

## Simulation Results
The design was verified using a self-checking testbench.
![UART Waveform](simlation/sim_wf.jpeg)
*Figure 1: Simulation waveform showing successful transmission and reception of ASCII 'A' (0x41) at 115200 baud.*

## Module Description
### 1. Baud Rate Generator
Generates a "tick" signal 16 times faster than the baud rate. This allows the RX module to subdivide a bit period into 16 slices for precise sampling.

### 2. UART RX (Receiver)
* **Idle State:** Waits for the RX line to go low (Start Bit).
* **Start Bit Detection:** verifies the start bit by checking the middle of the pulse (Tick 7/15).
* **Data Sampling:** Samples each data bit at the exact center (Tick 15/15) to avoid edge instability.

### 3. UART TX (Transmitter)
Maintains standard RS-232 timing by holding each bit for 16 ticks before transitioning.

## How to Run
1.  Add all files in `src/` and `tb/` to your simulator (Vivado, ModelSim, Icarus Verilog).
2.  Set `tb_uart` as the top module.
3.  Run simulation for 200us.