//-----------------------------------------------------------------------------
// Title         : Pixel-wide 16to1 Multiplexer
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : mux16_w8.v
// Author        : Runbin Shi
// Created       : 10.03.2017
// Last modified : 10.03.2017
//-----------------------------------------------------------------------------
// Description :
//------------------------------------------------------------------------------
// Modification history :
// 10.03.2017 : created
//-----------------------------------------------------------------------------

module mux16_w8(/*AUTOARG*/
   // Outputs
   data_out,
   // Inputs
   clk, rst_n, sel, data_in
   );

   input wire clk;
   input wire rst_n;

   input wire [3:0] sel;
   input wire [16*8-1:0] data_in;

   output reg [8-1:0]    data_out;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         data_out <= 8'b0;
      end else begin
         case (sel)

           // Generated
           0: data_out <= data_in[8*1-1:8*0];
           1: data_out <= data_in[8*2-1:8*1];
           2: data_out <= data_in[8*3-1:8*2];
           3: data_out <= data_in[8*4-1:8*3];
           4: data_out <= data_in[8*5-1:8*4];
           5: data_out <= data_in[8*6-1:8*5];
           6: data_out <= data_in[8*7-1:8*6];
           7: data_out <= data_in[8*8-1:8*7];
           8: data_out <= data_in[8*9-1:8*8];
           9: data_out <= data_in[8*10-1:8*9];
           10: data_out <= data_in[8*11-1:8*10];
           11: data_out <= data_in[8*12-1:8*11];
           12: data_out <= data_in[8*13-1:8*12];
           13: data_out <= data_in[8*14-1:8*13];
           14: data_out <= data_in[8*15-1:8*14];
           15: data_out <= data_in[8*16-1:8*15];
           // EndGen
         endcase // case (sel)
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

endmodule // mux16_w8
