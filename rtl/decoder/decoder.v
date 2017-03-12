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

   output wire [8*8*3-1:0]          wr_data;
   output wire [8*3-1:0]            wr_data_mask;
   output wire [9-1:0]              wr_data_en;

   // config_data_wire
   wire [CONF_DATA_WIDTH-1:0]       conf_data;
   wire [3-1:0]                     conf_offset;
   wire [3-1:0]                     conf_order;
   wire [8-1:0]                     conf_cycle;
   wire [1-1:0]                     conf_addr_ret;

   assign conf_data = conf_bram_rd_data_out[CONF_DATA_WIDTH-1:0];

   assign conf_offset = conf_data[2:0];
   assign conf_order = conf_data[5:3];
   assign conf_cycle = conf_data[13:6];
   assign conf_addr_ret = conf_data[14];

   // Configuration BRAM read related

   // conf_bram_rd_addr
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         conf_bram_rd_addr <= 0;
      end else begin
         if(data_in_vld && inline_cnt==1) begin
                 if(ret_flag)
                   conf_bram_rd_addr <= 0;
                 else
                   conf_bram_rd_addr <= conf_bram_rd_addr + 1;
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   // inline_cnt
   always @(posedge clk or negedge rst_n) begin
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

   // ret_flag
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         ret_flag <= 0;
      end else begin
         if(data_in_vld_d[1] && inline_cnt==0 ) begin
            ret_flag <= conf_addr_ret;
         end
      end
   end


   // signal generation

   reg [8*8*3-1:0] reg_wr_data_0;
   reg [8*8*3-1:0] reg_wr_data_1;
   reg [8*3-1:0]   reg_wr_data_mask_0;
   reg [8*3-1:0]   reg_wr_data_mask_1;
   reg [9-1:0]     reg_wr_data_en_0;
   reg [9-1:0]     reg_wr_data_en_1;

   reg [2:0]       shuf_flag;

   reg [2:0]       group_wr_en;

   // group_wr_en
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         group_wr_en <= 3'b010;
      end else begin
         if(data_in_vld[1] && inline_cnt==0)
           group_wr_en <= {group_wr_en[0], group_wr_en[2:1]};
      end
   end

   // shuf_flag
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         shuf_flag <= 0;
      end else begin
         if(data_in_vld_d[1]) begin
            if(inline_cnt==0)
              shuf_flag <= conf_order;
            else
              // cror shuf_flag
              shuf_flag <= {shuf_flag[0], shuf_flag[2:1]};
         end
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // level_0 ctl_sig
   // reg_wr_data_0
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_0 <= 0;
      end else begin
         case (conf_offset)
           1: reg_wr_data_0 <= { 56'b0, pix_data_in_d1, 8'b0 };
           2: reg_wr_data_0 <= { 48'b0, pix_data_in_d1, 16'b0 };
           3: reg_wr_data_0 <= { 40'b0, pix_data_in_d1, 24'b0 };
           4: reg_wr_data_0 <= { 32'b0, pix_data_in_d1, 32'b0 };
           5: reg_wr_data_0 <= { 24'b0, pix_data_in_d1, 40'b0 };
           6: reg_wr_data_0 <= { 16'b0, pix_data_in_d1, 48'b0 };
           7: reg_wr_data_0 <= { 8'b0, pix_data_in_d1, 56'b0 };
           default: reg_wr_data_0 <= { 64'b0, pix_data_in_d1, 0'b0 };
         endcase // case (conf_offset)
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // reg_wr_data_mask_0
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_mask_0 <= 0;
      end else begin
         case (conf_offset)
           0: reg_wr_data_maks_0 <= { 8'b0, 16'hFFFF, 0'b0 };
           1: reg_wr_data_maks_0 <= { 7'b0, 16'hFFFF, 1'b0 };
           2: reg_wr_data_maks_0 <= { 6'b0, 16'hFFFF, 2'b0 };
           3: reg_wr_data_maks_0 <= { 5'b0, 16'hFFFF, 3'b0 };
           4: reg_wr_data_maks_0 <= { 4'b0, 16'hFFFF, 4'b0 };
           5: reg_wr_data_maks_0 <= { 3'b0, 16'hFFFF, 5'b0 };
           6: reg_wr_data_maks_0 <= { 2'b0, 16'hFFFF, 6'b0 };
           7: reg_wr_data_maks_0 <= { 1'b0, 16'hFFFF, 7'b0 };
         endcase // case (conf_offset)
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)





endmodule // decoder
