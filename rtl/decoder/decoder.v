//-----------------------------------------------------------------------------
// Title         : Configuration Decoder
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : decoder.v
// Author        : Runbin Shi
// Created       : 11.03.2017
// Last modified : 11.03.2017
//-----------------------------------------------------------------------------
// Description : Decoder module for the Configuration BRAM data
//
//-----------------------------------------------------------------------------
// Modification history :
// 11.03.2017 : created
//-----------------------------------------------------------------------------

module decoder(/*AUTOARG*/
               // Outputs
               conf_bram_rd_addr,
               // Inputs
               clk, rst_n, decoder_en, conf_bram_rd_data_out
               );

   parameter CONF_DATA_WIDTH = 15;
   parameter CONF_ADDR_WIDTH = 9;
   parameter RAMB36_WIDTH = 72;

   input wire clk;
   input wire rst_n;

   // connected to data_in_vld
   input wire data_in_vld;
   input wire decoder_en;
   input wire [RAMB36_WIDTH-1:0] conf_bram_rd_data_out;

   output reg [CONF_ADDR_WIDTH-1:0] conf_bram_rd_addr;

   // config_data_wire
   wire [CONF_DATA_WIDTH-1:0]       conf_data;
   assign conf_data = conf_bram_rd_data_out[CONF_DATA_WIDTH-1:0];

   // Configuration BRAM read related

   // conf_bram_rd_addr
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         conf_bram_rd_addr <= 0;
      end else begin
         if(data_in_vld_d[0]) begin
            case (inline_cnt)
              // inc 1 to read the line_change config
              3: begin
                 conf_bram_rd_addr <= conf_bram_rd_addr + 1;
              end
              2: begin
                 if(ret_flag)
                   conf_bram_rd_addr <= 0;
                 else
                   conf_bram_rd_addr <= conf_bram_rd_addr + 1;
              end
            endcase // case (inline_cnt)
         end // if (data_in_vld_d[0])
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // inline_cnt
   always @(posedge clk or negedge rst_nt) begin
      if(!rst_n) begin
         inline_cnt <= 0;
      end else begin
         if(data_in_vld_d[1]) begin
            if(inline_cnt==0)
              inline_cnt <= conf_cycle;
            else
              inline_cnt <= inline_cnt-1;
         end
      end
   end // always @ (posedge clk or negedge rst_nt)

   //



endmodule // decoder
