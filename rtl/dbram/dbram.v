//-----------------------------------------------------------------------------
// Title         : Distuibuted RAM
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : dbram.v
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

module dbram(/*AUTOARG*/
   // Outputs
   rd_data_out,
   // Inputs
   clk, rst_n, wr_data_in, wr_addr, wr_data_en, rd_addr
   );

   parameter DATA_WIDTH = 8;
   parameter DEPTH = 16;
   parameter ADDR_WIDTH = 4;

   input wire clk;
   input wire rst_n;

   input wire [DATA_WIDTH-1:0] wr_data_in;
   input wire [ADDR_WIDTH-1:0] wr_addr;
   input wire                  wr_data_en;


   input wire [ADDR_WIDTH-1:0] rd_addr;
   output reg [DATA_WIDTH-1:0]  rd_data_out;

   reg [DATA_WIDTH-1:0]         ram [DEPTH-1:0];

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
        rd_data_out <= 0;
      else
        rd_data_out <= ram[rd_addr];
   end

   always @(posedge clk) begin
      if(wr_data_en)
        ram[wr_addr] <= wr_data_in;
   end

endmodule // dbram
