# swin_bram
A BRAM microstructure for sliding window liked pattern access on Xilinx FPGA

## Features
Differences between this microstructure and the general memory partition approach are listed as the following

### Ultra-fast

Multi-pixeles (N<sub>in</sub>) input per clock;

### Pixel Aggregation

Put several pixeles in one BANK to increase the standalone BRAM ultilization;

### Line Alignment

N<sub>x</sub> is #pixel per image line; In the multi-pixels input mode, it may not be interger divided by N<sub>in</sub>; Then each line will have an offset while writing and fetching. The offset chages periodically.

## Project Structure
- matlab: theoritical analysis and test data generation
- rtl: hardware modules with testbench
- testdata: testdata used in verification
- syn: PlanAhead Project folder


## Matlab
### latency_compare.m

The first comparison is to the original video frame buffer scheme.


## RTL
### sdp_ram
An implementation of a simple dual port ram with Xilinx Primitive;


