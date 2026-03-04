1. Introduction

Universal Asynchronous Receiver Transmitter (UART) is a widely used serial communication protocol for transmitting and receiving data between digital systems. UART operates asynchronously, meaning that the communicating devices do not share a common clock signal. Instead, the receiver samples incoming data based on a predefined baud rate.

This project implements a basic UART communication system using Verilog HDL. The design consists of three main modules: a baud rate generator, a transmitter, and a receiver. The receiver uses a 16× oversampling technique to improve the reliability of detecting incoming serial data.

The design was verified using simulation in Vivado, where the transmitter output was connected to the receiver input in a loopback configuration.

2. UART Frame Format

UART communication uses a fixed frame structure to transmit data serially.

Each frame consists of:

Start Bit
Data Bits
Stop Bit

For this implementation the frame format is:

Start Bit: 1 bit (logic 0)
Data Bits: 8 bits (LSB first)
Stop Bit: 1 bit (logic 1)

Total frame size = 10 bits

Example frame:

Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop
1 | 0 | Data Bits | 1

(Insert UART frame diagram here)

3. System Architecture

The UART system is composed of three modules:

Baud Rate Generator

Transmitter (TX)

Receiver (RX)

The baud rate generator produces timing signals used by the transmitter and receiver. The transmitter converts parallel data into serial form. The receiver samples the incoming serial signal and reconstructs the transmitted data.

System architecture:

Baud Rate Generator
↓
Transmitter → Serial Line → Receiver

(Insert RTL schematic image exported from Vivado here)

4. Baud Rate Generator

The baud rate generator produces enable signals used to control the timing of data transmission and reception.

The transmitter operates at the actual baud rate, while the receiver uses 16× oversampling. Oversampling improves reliability by allowing the receiver to detect the middle of each bit period more accurately.

Two enable signals are generated:

tx_en → enables transmitter bit updates
rx_en → enables receiver sampling

This approach ensures accurate synchronization between transmitter and receiver operations.

5. Transmitter Design

The transmitter is implemented using a finite state machine (FSM). The FSM controls the sequential transmission of start bit, data bits, and stop bit.

The transmitter consists of the following states:

IDLE
START
DATA
STOP

State descriptions:

IDLE
The transmitter waits for a valid transmission request signal. The transmission line remains high during this state.

START
A start bit (logic 0) is transmitted to indicate the beginning of a frame.

DATA
Eight data bits are transmitted sequentially. The least significant bit (LSB) is transmitted first.

STOP
A stop bit (logic 1) is transmitted to indicate the end of the frame.

After the stop bit, the FSM returns to the IDLE state.

(Insert transmitter FSM diagram here)

6. Receiver Design

The receiver reconstructs the transmitted data from the incoming serial stream.

The receiver first detects the falling edge of the start bit. Once the start bit is detected, the receiver validates it by sampling the signal near the middle of the bit period.

The receiver uses 16× oversampling to improve sampling accuracy.

Receiver operation steps:

Detect falling edge of start bit

Wait until the middle of the start bit

Sample each data bit at the center of its bit period

Store received bits in a shift register

Verify the stop bit

Output the received data and assert data_valid signal

(Insert receiver FSM diagram here)

7. Simulation and Verification

The UART system was verified using a simulation testbench.

In the testbench, the transmitter output was directly connected to the receiver input, creating a loopback system. Several test bytes were transmitted to verify correct operation.

Example transmitted and received values:

A5 → A5
3C → 3C
F0 → F0
0F → 0F
AB → AB

The receiver successfully reconstructed all transmitted bytes.

(Insert simulation waveform screenshot here)

8. Results

Simulation results confirm that the UART implementation operates correctly. The transmitted bytes were received without any data corruption.

The receiver accurately detected the start bit, sampled the data bits at the correct time, and validated the stop bit. The data_valid signal was asserted correctly when a complete frame was received.

9. Conclusion

This project demonstrates the design and implementation of a UART communication system using Verilog HDL. The system includes a transmitter, receiver, and baud rate generator. Oversampling was used in the receiver to improve the reliability of data sampling.

Simulation results confirmed correct operation of the system.

10. Future Improvements

The current implementation can be extended with additional features such as:

Parity bit support
Configurable baud rate
TX and RX FIFO buffers
Framing error detection
Integration with FPGA hardware for real-world communication
