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

### parameter_gen.m
Used to generate configuration mif file.

### xilinx_mif_gen.m
generate xilinx memory initialization file format.



## 3x3 sliding window design method

**N_bram** per line can be calcuated with ceil(**N_in** / **N_bram_width**)+1, where **N_bram_width** = 8 with the 72x512 SDP RAMB36E1 configuration. Here, we choose that **N_in** is multiple of 8 (16).

With **N_in** =16, we should set 3x3 BRAM for 3x3 sliding window implementation. BRAM0 -> BRAM8; They all have corresponding control signal as following,

- Input: wr_data_en; wr_data_mask; wr_addr; wr_data_in; | rd_addr;
- Output: rd_data_out;

The function of control logic is generating standalone signals for these BRAMs.

At first, a configuration BRAM is set to store some parameters calculated offline that can avoid complex calculation logic. The signal slot definition as following,

### Configuration BRAM signal definition

| slot_name   | len(bit) | useage                                                  |
|-------------+----------+---------------------------------------------------------|
| S0,offset   |        3 | offset in BRAM, the same for the whole                  |
|             |          | image line (because input batch size 16                 |
|             |          | is multiple to BRAM size 8 ),from 0 to 7;               |
|             |          | Used to do data shuffling and wr_en_mask.               |
|-------------+----------+---------------------------------------------------------|
| S1,order    |        3 | indicate which BRAM working fisrt,                      |
|             |          | with S0, decide the addr_inc and shuffling.             |
|-------------+----------+---------------------------------------------------------|
| S2,cycle    |        8 | indicate the cycling times, MAX 255 for 4096 pix/line.  |
|-------------+----------+---------------------------------------------------------|
| S4,addr_ret |        1 | Address return to zero, control signal of the outermost |
|             |          | loop.                                                   |


## Hardware Working Timing

### Decoder
| data_in_vld_d0  | d1              | d2            | d3            | ... |                 |                 |               |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
| conf_bram_addr0 |                 |               |               | ... | conf_bram_addr1 |                 |               |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
|                 | conf_data_line0 |               |               | ... |                 | conf_data_line1 |               |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
|                 | inline_cnt=0    | inline_cnt=79 | inline_cnt=78 | ... | inline_cnt=1    | inline_cnt=0    | inline_cnt=79 |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
|                 |                 | return setted |               |     |                 |                 | return setted |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
|                 |                 | ctl_sig_l0_0  |               | ... |                 |                 | ctl_sig_l1_0  |
|-----------------+-----------------+---------------+---------------+-----+-----------------+-----------------+---------------|
|                 |                 |               | ctl_sig_l0_1  |     |                 |                 |               |



### BRAM Data Arrangment

| pix23   ...    | ...  | Pix0 |        |
|----------------+------+------+--------|
| HSB  RAM2  LSB | RAM1 | RAM0 | group0 |
|----------------+------+------+--------|
| HSB  RAM5  LSB | RAM4 | RAM3 | group1 |
|----------------+------+------+--------|
| HSB  RAM8  LSB | RAM7 | RAM6 | group2 |
|----------------+------+------+--------|


## RTL
### sdp_ram
An implementation of a simple dual port ram with Xilinx Primitive;
* Resource
  | RAMB36 | FF | Slice | LUT |
  |--------+----+-------+-----|
  |      1 | 0  | 0     | 0   |
* Pin
  | Input        | BitWidth | Useage               |
  |--------------+----------+----------------------|
  | clk          |        1 | clock                |
  | rst_n        |        1 | reset@negedge        |
  | rd_addr      |        9 | memory read address  |
  | rd_data_out  |       64 | memory read output   |
  | wr_addr      |        9 | memory write address |
  | wr_data_in   |       64 | memory write input   |
  | wr_data_mask |        8 | byte-wide write mask |
  | wr_data_en   |        1 | memory write enable  |
* key parameter
  MIF_FILE: Xilinx styled .mif file used to initialize the BRAM

  ### mux16_w8
  A pixel-wide (8bits) 16 to 1 Multiplexer
* Resource
  | RAMB36 | FF | Slice | LUT |
  |--------+----+-------+-----|
  |      0 |  0 |     9 |  33 |
* Pin
  | Input    | BitWidth | Useage               |
  |----------+----------+----------------------|
  | clk      |        1 | clock                |
  | rst_n    |        1 | reset@negedge        |
  | sel      |        4 | select signal of MUX |
  | data_in  |     16*8 | pixel data input     |
  | data_out |        8 | pixel data output    |

  ###
