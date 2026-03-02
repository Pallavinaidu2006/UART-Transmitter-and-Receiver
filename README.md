## UART Transmission and Receiving


## Modules

1. **top.v** – Top-level module connecting transmitter, receiver, and debouncer.  
2. **transmitter.v** – UART transmitter module; sends 8-bit data with start and stop bits.  
3. **transmit_debouncing.v** – Debounces a push-button input before sending a transmit signal.  
4. **receiver.v** – UART receiver module; samples incoming serial data and outputs 8-bit value.  



## How it Works

1. User presses a **button** to transmit data.  
2. The **debouncer** ensures a clean trigger signal.  
3. The **transmitter** module frames the data (`start + 8 data bits + stop`) and shifts it out at 9600 baud on `TxD`.  
4. The **receiver** module oversamples the `RxD` line 4× per bit and captures the 10-bit frame, outputting the 8-bit data.  


## Requirements

- Vivado 2018.x (or any compatible FPGA IDE)  
- FPGA development board (tested on Basys3 , 100 MHz clock)



## Usage

1. Open Vivado and create a new project.  
2. Add all **Verilog files** from `src/` and constraints from `constraints/`.  
3. Synthesize and implement the design on your FPGA.  
4. Connect buttons and switches as defined in `top.xdc`.  
5. Press the button to transmit data from switches. Observe `TxD` output or connect to UART-to-USB module.  



## Simulation

Simulation testbenches are available:  
- `transmitter_tb.v` – tests the transmitter module.
- Block diagram and implementation image are given.

Run the simulation in Vivado or any Verilog simulator and view `.vcd` waveforms in `results/`.  

