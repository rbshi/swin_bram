//-----------------------------------------------------------------------------
// Title         : BRAM Group
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : bram_group.v
// Author        : Runbin Shi
// Created       : 13.03.2017
// Last modified : 13.03.2017
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Modification history :
// 13.03.2017 : created
//-----------------------------------------------------------------------------

module bram_group(/*AUTOARG*/
   // Outputs
   cur_addr, rd_data_out,
   // Inputs
   clk, rst_n, wr_data, wr_data_mask, wr_data_group_en, wr_addr_inc,
   wr_addr_reset, rd_addr
   );

   input wire clk;
   input wire rst_n;

   input wire [8*8*3-1:0] wr_data;
   input wire [8*3-1:0]   wr_data_mask;
   input wire             wr_data_group_en;
   input wire [3-1:0]     wr_addr_inc;
   input wire             wr_addr_reset;

   input wire [9*3-1:0]   rd_addr;

   output wire [9*3-1:0]    cur_addr;
   output wire [8*8*3-1:0]  rd_data_out;

   reg [9-1:0]              wr_addr_bram0;
   reg [9-1:0]              wr_addr_bram1;
   reg [9-1:0]              wr_addr_bram2;


   assign cur_addr = {wr_addr_bram2, wr_addr_bram1, wr_addr_bram0};

   // wr_addr_bram
   always @(posedge clk) begin
      if(wr_addr_reset) begin
         wr_addr_bram0 <= 0;
      end else begin
         if(wr_addr_inc[0])
           wr_addr_bram0 <= wr_addr_bram0 + 1;
      end
   end
   always @(posedge clk) begin
      if(wr_addr_reset) begin
         wr_addr_bram1 <= 0;
      end else begin
         if(wr_addr_inc[1])
           wr_addr_bram1 <= wr_addr_bram1 + 1;
      end
   end
   always @(posedge clk) begin
      if(wr_addr_reset) begin
         wr_addr_bram2 <= 0;
      end else begin
         if(wr_addr_inc[2])
           wr_addr_bram2 <= wr_addr_bram2 + 1;
      end
   end

   // Instance of RAMB36
   sdp_ram
   bram2 (
          .clk(clk),
          .rst_n(rst_n),
          .rd_addr(rd_addr[9*3-1:9*2]),
          .wr_addr(wr_addr_bram2),
          .wr_data_in(wr_data[8*8*3-1:8*8*2]),
          .wr_data_mask(wr_data_mask[8*3-1:8*2]),
          .wr_data_en(wr_data_group_en),
          .rd_data_out(rd_data_out[8*8*3-1:8*8*2])
          );
   sdp_ram
   bram1 (
          .clk(clk),
          .rst_n(rst_n),
          .rd_addr(rd_addr[9*2-1:9*1]),
          .wr_addr(wr_addr_bram1),
          .wr_data_in(wr_data[8*8*2-1:8*8*1]),
          .wr_data_mask(wr_data_mask[8*2-1:8*1]),
          .wr_data_en(wr_data_group_en),
          .rd_data_out(rd_data_out[8*8*2-1:8*8*1])
          );
   sdp_ram
   bram0 (
          .clk(clk),
          .rst_n(rst_n),
          .rd_addr(rd_addr[9*1-1:9*0]),
          .wr_addr(wr_addr_bram0),
          .wr_data_in(wr_data[8*8*1-1:8*8*0]),
          .wr_data_mask(wr_data_mask[8*1-1:8*0]),
          .wr_data_en(wr_data_group_en),
          .rd_data_out(rd_data_out[8*8*1-1:8*8*0])
          );

endmodule // bram_group
