//-----------------------------------------------------------------------------
// Title         : Testbench of Simple Dual Port BRAM
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : tb_sdp_ram.v
// Author        : Runbin Shi
// Created       : 09.03.2017
//-----------------------------------------------------------------------------
// Description : Testbench of Simple Dual Port BRAM with Xilinx Primitives,
//               configured as RAMB36E1 => 64 widthx512 depth
//-----------------------------------------------------------------------------
// Modification history :
// 09.03.2017 : created
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module tb_sdp_ram();

   parameter MEM_ADDR_WIDTH = 9;
   parameter MEM_WORD_WIDTH = 64;
   parameter MEM_WR_MASK_WIDTH = MEM_WORD_WIDTH/8;

   // Parameters for Simulation
   parameter clk_period = 10; // ns, 100MHz
   parameter start_delay = 100; // clk cycle
   parameter rst_delay = 20;
   parameter rst_period = 5;

   parameter STREAM_LEN = 512;

   reg clk;
   reg rst_n;
   reg [MEM_ADDR_WIDTH-1:0] rd_addr;
   reg [MEM_ADDR_WIDTH-1:0] wr_addr;
   reg [MEM_WORD_WIDTH-1:0] wr_data_in;
   reg [MEM_WR_MASK_WIDTH-1:0] wr_data_mask;
   reg                         wr_data_en;


   wire [MEM_WORD_WIDTH-1:0]   rd_data_out;


   // Variables for Simulation
   integer                    in_file, out_file;
   integer                    ii, jj;
   integer                    temp;


   // clk generate
   initial begin
      #(clk_period) clk = 0;
      forever begin
         #(clk_period/2) clk = ~clk;
      end
   end

   // rst generate
   initial begin
      #(clk_period) rst_n = 1;
      #(clk_period*rst_delay) rst_n = 0;
      #(clk_period*rst_period) rst_n = 1;
   end

   // Sim data generate

   initial begin
      $vcdpluson;
   end

   reg [MEM_WORD_WIDTH-1:0] input_data [STREAM_LEN-1:0];

   // Load the input file
   initial begin
      in_file = $fopen("../../testdata/input_sdp_ram.txt", "r");
      out_file = $fopen("../../testdata/output_sdp_ram.txt", "w");
   end

   initial begin
      for (ii=0;ii<STREAM_LEN;ii=ii+1) begin
         temp = $fscanf(in_file, "%x", input_data[ii]);
      end
   end

   initial begin
      #(clk_period*start_delay);
      wr_addr = -1;
      rd_addr = -1;
      wr_data_mask = 8'b11111111;

      // Send the data and enable signal
      for (jj=0;jj<STREAM_LEN;jj=jj+1) begin
         @(posedge clk);
         wr_addr <= wr_addr + 1;
         wr_data_en <= 1;
         wr_data_in <= input_data[jj];
      end

      @(posedge clk);
      wr_data_en <= 0;

      #(clk_period*10);

      // Begin read from BRAM
      for (jj=0;jj<STREAM_LEN;jj=jj+1) begin
         @(posedge clk);
         rd_addr <= rd_addr + 1;
         if(jj>1) begin
            $fdisplay(out_file, "%x", rd_data_out);
         end
      end

      @(posedge clk);
      $fdisplay(out_file, "%x", rd_data_out);
      @(posedge clk);
      $fdisplay(out_file, "%x", rd_data_out);

      #(clk_period*10);
      $finish;

   end // initial begin

   // DUT instantition
   sdp_ram u_sdp_ram(
                     .clk(clk),
                     .rst_n(rst_n),
                     .rd_addr(rd_addr),
                     .wr_addr(wr_addr),
                     .wr_data_in(wr_data_in),
                     .wr_data_mask(wr_data_mask),
                     .wr_data_en(wr_data_en),
                     .rd_data_out(rd_data_out)
                     );

endmodule // tb_sdp_ram
