# swin_bram
A BRAM microstructure for sliding window liked pattern access on Xilinx FPGA

## Features
Differences between this microstructure and the general memory partition approach are listed as the following

### Ultra-fast

Multi-pixeles (**N_in**) input per clock;

### Pixel Aggregation

Put several pixeles in one BANK to increase the standalone BRAM ultilization;

### Line Alignment

**N_x** is #pixel per image line; In the multi-pixels input mode, it may not be interger divided by N<sub>in</sub>; Then each line will have an offset while writing and fetching. The offset chages periodically.

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
| Input        | BitWidth | Useage               |
|--------------+----------+----------------------|
| clk          |        1 | clock                |
| rst_n        |        1 | reset@negedge        |
| rd_addr      |        9 | memory read address  |
| rd_data_out  |       64 | memory read output   |
| wr_addr      |        9 | memory write address |
| wr_data_in   |       64 | memory write input   |
| wr_data_mask |        8 | Byte-wide write mask |
| wr_data_en   |        1 | memory write enable  |
