//-----------------------------------------------------------------------------
// Title         : Simple Dual Port BRAM
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : sdp_ram.v
// Author        : Runbin Shi
// Created       : 09.03.2017
//-----------------------------------------------------------------------------
// Description : Simple Dual Port BRAM with Xilinx Primitives, configured as
//               RAMB36E1 => 64 widthx512 depth
//-----------------------------------------------------------------------------
// Modification history :
// 09.03.2017 : created
//-----------------------------------------------------------------------------

`default_nettype none

  module sdp_ram(/*AUTOARG*/
                 // Outputs
                 rd_data_out,
                 // Inputs
                 clk, rst_n, rd_addr, wr_addr, wr_data_in, wr_data_mask, wr_data_en
                 );

   parameter MEM_ADDR_WIDTH = 9;
   parameter MEM_WORD_WIDTH = 64;
   parameter MEM_WR_MASK_WIDTH = MEM_WORD_WIDTH/8;
   parameter MIF_FILE = "NONE";

   input wire clk;
   input wire rst_n;
   input wire [MEM_ADDR_WIDTH-1:0] rd_addr;
   input wire [MEM_ADDR_WIDTH-1:0] wr_addr;
   input wire [MEM_WORD_WIDTH-1:0] wr_data_in;
   input wire [MEM_WR_MASK_WIDTH-1:0] wr_data_mask;
   input wire                         wr_data_en;


   output wire [MEM_WORD_WIDTH-1:0]   rd_data_out;

   RAMB36E1 #(
              // Address Collision Mode: "PERFORMANCE" or "DELAYED_WRITE"
              .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
              // Collision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
              .SIM_COLLISION_CHECK("ALL"),
              // DOA_REG, DOB_REG: Optional output register (0 or 1)
              .DOA_REG(0),
              .DOB_REG(0),
              .EN_ECC_READ("FALSE"),                                                            // Enable ECC decoder,
              // FALSE, TRUE
              .EN_ECC_WRITE("FALSE"),                                                           // Enable ECC encoder,
              // FALSE, TRUE
              // INIT_A, INIT_B: Initial values on output ports
              .INIT_A(36'h000000000),
              .INIT_B(36'h000000000),

              // Initialization File: RAM initialization file
              .INIT_FILE(MIF_FILE),
              // RAM Mode: "SDP" or "TDP"
              .RAM_MODE("SDP"),
              // RAM_EXTENSION_A, RAM_EXTENSION_B: Selects cascade mode ("UPPER", "LOWER", or "NONE")
              //.RAM_EXTENSION_A("NONE"),
              //.RAM_EXTENSION_B("NONE"),
              // READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
              .READ_WIDTH_A(72),                                                                 // 0-72
              .READ_WIDTH_B(0),                                                                 // 0-36
              .WRITE_WIDTH_A(0),                                                                // 0-36
              .WRITE_WIDTH_B(72),                                                                // 0-72
              // RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
              //.RSTREG_PRIORITY_A("RSTREG"),
              //.RSTREG_PRIORITY_B("RSTREG"),
              // SRVAL_A, SRVAL_B: Set/reset value for output
              .SRVAL_A(36'h000000000),
              .SRVAL_B(36'h000000000),
              // Simulation Device: Must be set to "7SERIES" for simulation behavior
              .SIM_DEVICE("7SERIES"),
              // WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
              .WRITE_MODE_A("WRITE_FIRST"),
              .WRITE_MODE_B("WRITE_FIRST")
              )
   RAMB36E1_inst (
                  // Cascade Signals: 1-bit (each) output: BRAM cascade ports (to create 64kx1)
                  //.CASCADEOUTA(CASCADEOUTA),     // 1-bit output: A port cascade
                  //.CASCADEOUTB(CASCADEOUTB),     // 1-bit output: B port cascade
                  // ECC Signals: 1-bit (each) output: Error Correction Circuitry ports
                  //.DBITERR(DBITERR),             // 1-bit output: Double bit error status
                  //.ECCPARITY(ECCPARITY),         // 8-bit output: Generated error correction parity
                  //.RDADDRECC(RDADDRECC),         // 9-bit output: ECC read address
                  //.SBITERR(SBITERR),             // 1-bit output: Single bit error status
                  // Port A Data: 32-bit (each) output: Port A data
                  .DOADO(rd_data_out[31:0]),                 // 32-bit output: A port data/LSB data
                  //.DOPADOP(DOPADOP),             // 4-bit output: A port parity/LSB parity
                  // Port B Data: 32-bit (each) output: Port B data
                  .DOBDO(rd_data_out[63:32]),                 // 32-bit output: B port data/MSB data
                  //.DOPBDOP(DOPBDOP),             // 4-bit output: B port parity/MSB parity
                  // Cascade Signals: 1-bit (each) input: BRAM cascade ports (to create 64kx1)
                  //.CASCADEINA(CASCADEINA),       // 1-bit input: A port cascade
                  //.CASCADEINB(CASCADEINB),       // 1-bit input: B port cascade
                  // ECC Signals: 1-bit (each) input: Error Correction Circuitry ports
                  //.INJECTDBITERR(INJECTDBITERR), // 1-bit input: Inject a double bit error
                  //.INJECTSBITERR(INJECTSBITERR), // 1-bit input: Inject a single bit error
                  // Port A Address/Control Signals: 16-bit (each) input: Port A address and control signals (read port
                  // when RAM_MODE="SDP")
                  .ADDRARDADDR({1'b0,rd_addr,6'b0}),     // 16-bit input: A port address/Read address
                  .CLKARDCLK(clk),         // 1-bit input: A port clock/Read clock
                  .ENARDEN(1'b1),             // 1-bit input: A port enable/Read enable
                  //.REGCEAREGCE(REGCEAREGCE),     // 1-bit input: A port register enable/Register enable
                  .RSTRAMARSTRAM(~rst_n), // 1-bit input: A port set/reset
                  //.RSTREGARSTREG(RSTREGARSTREG), // 1-bit input: A port register set/reset
                  //.WEA(WEA),                     // 4-bit input: A port write enable
                  // Port A Data: 32-bit (each) input: Port A data
                  .DIADI(wr_data_in[31:0]),                 // 32-bit input: A port data/LSB data
                  //.DIPADIP(DIPADIP),             // 4-bit input: A port parity/LSB parity
                  // Port B Address/Control Signals: 16-bit (each) input: Port B address and control signals (write port
                  // when RAM_MODE="SDP")
                  .ADDRBWRADDR({1'b0,wr_addr,6'b0}),     // 16-bit input: B port address/Write address
                  .CLKBWRCLK(clk),         // 1-bit input: B port clock/Write clock
                  .ENBWREN(wr_data_en),             // 1-bit input: B port enable/Write enable
                  //.REGCEB(REGCEB),               // 1-bit input: B port register enable
                  .RSTRAMB(~rst_n),             // 1-bit input: B port set/reset
                  //.RSTREGB(RSTREGB),             // 1-bit input: B port register set/reset
                  .WEBWE(wr_data_mask),                 // 8-bit input: B port write enable/Write enable
                  // Port B Data: 32-bit (each) input: Port B data
                  .DIBDI(wr_data_in[63:32])                 // 32-bit input: B port data/MSB data
                  //.DIPBDIP(DIPBDIP)              // 4-bit input: B port parity/MSB parity
                  );

   // End of RAMB36E1_inst instantiation

   /* BRAM_SDP_MACRO only effective in Vivado
    BRAM_SDP_MACRO #(
    .BRAM_SIZE("36Kb"), // Target BRAM, "18Kb" or "36Kb"
    .DEVICE("7SERIES"), // Target device: "7SERIES"
    .WRITE_WIDTH(64),    // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .READ_WIDTH(64),     // Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
    .DO_REG(0),         // Optional output register (0 or 1)
    .INIT_FILE ("NONE"),
    .SIM_COLLISION_CHECK ("ALL"), // Collision check enable "ALL", "WARNING_ONLY",
    //   "GENERATE_X_ONLY" or "NONE"
    .SRVAL(72'h000000000000000000), // Set/Reset value for port output
    .INIT(72'h000000000000000000),  // Initial values on output port
    .WRITE_MODE("WRITE_FIRST")  // Specify "READ_FIRST" for same clock or synchronous clocks
    //   Specify "WRITE_FIRST for asynchronous clocks on ports
    )
    BRAM_SDP_MACRO_inst (
    .DO(rd_data_out),         // Output read data port, width defined by READ_WIDTH parameter
    .DI(wr_data_in),         // Input write data port, width defined by WRITE_WIDTH parameter
    .RDADDR(rd_addr), // Input read address, width defined by read port depth
    .RDCLK(clk),   // 1-bit input read clock
    .RDEN(1'b1),     // 1-bit input read port enable
    .REGCE(1'b0),   // 1-bit input read output register enable
    .RST(~rst_n),       // 1-bit input reset
    .WE(wr_data_mask),         // Input write enable, width defined by write port depth
    .WRADDR(wr_addr), // Input write address, width defined by write port depth
    .WRCLK(clk),   // 1-bit input write clock
    .WREN(wr_data_en)      // 1-bit input write port enable
    );

    // End of RAMB36E1_inst instantiation
    */
endmodule // sdp_ram

`default_nettype wire
