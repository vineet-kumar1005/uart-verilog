# UART Implementation in Verilog

This project implements a UART transmitter and receiver in Verilog.

## Features

- 8-bit data
- 1 start bit
- 1 stop bit
- 16x oversampling receiver
- Loopback simulation testbench

## Modules

- `transmitter.v` – UART TX FSM
- `receiver.v` – UART RX with 16x oversampling
- `baud_rate_generator.v` – Generates TX and RX enable ticks

## RTL Schematic

![RTL Diagram](docs/rtl_diagram.png)

## Simulation

The testbench performs loopback verification.

Example transmitted values:

A5 → A5  
3C → 3C  
F0 → F0  
0F → 0F  
AB → AB  

### Simulation Waveform

![Waveform](sim/waveform.png)

## Directory Structure

- rtl/ → RTL modules  
- tb/ → Testbench  
- sim/ → Waveform screenshots  
- docs/ → RTL schematic
