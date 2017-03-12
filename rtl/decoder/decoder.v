//-----------------------------------------------------------------------------
// Title         : Configuration Decoder
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : decoder.v
// Author        : Runbin Shi
// Created       : 11.03.2017
// Last modified : 11.04.2017
//-----------------------------------------------------------------------------
// Description : Decoder module for the Configuration BRAM data
//
//-----------------------------------------------------------------------------
// Modification history :
// 11.03.2017 : created
// 11.04.2017 : revised with line end and start action
//-----------------------------------------------------------------------------

module decoder(/*AUTOARG*/
               // Outputs
               conf_bram_rd_addr, wr_data, wr_data_mask, wr_data_en,
               // Inputs
               clk, rst_n, data_in_vld, decoder_en, conf_bram_rd_data_out
               );

   parameter CONF_DATA_WIDTH = 19;
   parameter CONF_ADDR_WIDTH = 9;
   parameter RAMB36_WIDTH = 72;

   input wire clk;
   input wire rst_n;

   // connected to data_in_vld
   input wire data_in_vld;
   input wire decoder_en;
   input wire [CONF_ADDR_WIDTH-1:0] conf_bram_rd_data_out;

   output reg [CONF_ADDR_WIDTH-1:0] conf_bram_rd_addr;

   output wire [8*8*3*3-1:0]          wr_data;
   output wire [8*3*3-1:0]            wr_data_mask;
   output wire [3-1:0]              wr_data_group_en;

   output wire [3*3-1:0]            wr_addr_inc;

   // ----------------------------------------------------------------
   // config_data_wire
   wire [CONF_DATA_WIDTH-1:0]       conf_data;
   wire [3-1:0]                     conf_offset;
   wire [3-1:0]                     conf_order;
   wire [8-1:0]                     conf_cycle;
   wire [1-1:0]                     conf_addr_ret;
   wire [4-1:0]                     conf_split;

   assign conf_data = conf_bram_rd_data_out;

   assign conf_offset = conf_data[2:0];
   assign conf_order = conf_data[5:3];
   assign conf_cycle = conf_data[13:6];
   assign conf_addr_ret = conf_data[14];
   assign conf_split = conf_data[18:15];

   // Configuration BRAM read related

   // conf_bram_rd_addr
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         conf_bram_rd_addr <= 0;
      end else begin
         if(data_in_vld && inline_cnt==2) begin
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

   // ----------------------------------------------------------------
   // norm write signal generation

   reg [8*8*3-1:0] reg_wr_data_0;
   reg [8*8*3-1:0] reg_wr_data_1;
   reg [8*3-1:0]   reg_wr_data_mask_0;
   reg [8*3-1:0]   reg_wr_data_mask_1;
   reg [9-1:0]     reg_wr_data_en_0;
   reg [9-1:0]     reg_wr_data_en_1;

   reg [2:0]       shuf_flag;

   reg [2:0]       group_wr_en;
   reg [2:0]       group_wr_en_d0;

   // group_wr_en
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         group_wr_en <= 3'b010;
      end else begin
         if(data_in_vld[1] && inline_cnt==0)
           group_wr_en <= {group_wr_en[0], group_wr_en[2:1]};
         group_wr_en_d0 = group_wr_en;
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

   // level_1 ctl_sig
   // reg_wr_data_1
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_1 <= 0;
      end else begin
         case (shuf_flag)
           3'b100: reg_wr_data_1 <= {reg_wr_data_0[8*8-1:0], reg_wr_data_0[8*8*3-1:8*8]};
           3'b010: reg_wr_data_1 <= {reg_wr_data_0[8*8*2-1:0], reg_wr_data_0[8*8*3-1:8*8*2-1]};
           default: reg_wr_data_1 <= reg_wr_data_0;
         endcase // case (shuf_flag)
      end
   end // always @ (posedge clk or negedge rst_n)

   // reg_wr_data_mask_1
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_mask_1 <= 0;
      end else begin
         case (shuf_flag)
           3'b100: reg_wr_data_mask_1 <= {reg_wr_data_mask_0[8-1:0], reg_wr_data_mask_0[8*3-1:8]};
           3'b010: reg_wr_data_mask_1 <= {reg_wr_data_mask_0[8*2-1:0], reg_wr_data_mask_0[8*3-1:8*2-1]};
           default: reg_wr_data_mask_1 <= reg_wr_data_mask_0;
         endcase // case (shuf_flag)
      end
   end // always @ (posedge clk or negedge rst_n)

   // ----------------------------------------------------------------
   // Special sig for Line End and Start
   // Line End , Split
   reg [8*8*2-1:0] reg_wr_data_s0;
   reg [8*8*2-1:0] reg_wr_data_s1;
   // No mask & wr_en signal for split part writing; coz the rest part will be overwirted, just write 16 pixels
   reg [3-1:0]     reg_wr_addr_inc_s0;
   reg [3-1:0]     reg_wr_addr_inc_s1;

   // reg_wr_data_s0&s1
   always @(posedge clk) begin
      case(conf_split)
        1: reg_wr_data_s0 <= { 120'b0, pix_data_in_d1[8*16-1:8*15] };
        2: reg_wr_data_s0 <= { 112'b0, pix_data_in_d1[8*16-1:8*14] };
        3: reg_wr_data_s0 <= { 104'b0, pix_data_in_d1[8*16-1:8*13] };
        4: reg_wr_data_s0 <= { 96'b0, pix_data_in_d1[8*16-1:8*12] };
        5: reg_wr_data_s0 <= { 88'b0, pix_data_in_d1[8*16-1:8*11] };
        6: reg_wr_data_s0 <= { 80'b0, pix_data_in_d1[8*16-1:8*10] };
        7: reg_wr_data_s0 <= { 72'b0, pix_data_in_d1[8*16-1:8*9] };
        8: reg_wr_data_s0 <= { 64'b0, pix_data_in_d1[8*16-1:8*8] };
        9: reg_wr_data_s0 <= { 56'b0, pix_data_in_d1[8*16-1:8*7] };
        10: reg_wr_data_s0 <= { 48'b0, pix_data_in_d1[8*16-1:8*6] };
        11: reg_wr_data_s0 <= { 40'b0, pix_data_in_d1[8*16-1:8*5] };
        12: reg_wr_data_s0 <= { 32'b0, pix_data_in_d1[8*16-1:8*4] };
        13: reg_wr_data_s0 <= { 24'b0, pix_data_in_d1[8*16-1:8*3] };
        14: reg_wr_data_s0 <= { 16'b0, pix_data_in_d1[8*16-1:8*2] };
        15: reg_wr_data_s0 <= { 8'b0, pix_data_in_d1[8*16-1:8*1] };
        default: reg_wr_data_s0 <= { 128'b0, pix_data_in_d1[8*16-1:8*16] };
      endcase // case (conf_split)
      reg_wr_data_s1 <= reg_wr_data_s0;
   end // always @ (posedge clk)

   // reg_wr_addr_inc_s0&1
   always @(posedge clk) begin
      // conf_split[2] stands for 8
      case(conf_split[2])
        1: reg_wr_inc_s0 <= 3'b001;
        default: reg_wr_addr_inc_s0 <= 3'b000;
      endcase // case (conf_split[2])
      reg_wr_addr_inc_s1 <= reg_wr_addr_inc_s0;
   end

   // ----------------------------------------------------------------
   // Line Start, tailappend
   reg [3-1:0] reg_shuf_flag_tail;
   reg [3-1:0] reg_conf_offset_tail;
   reg [8*24-1:0] reg_wr_data_tail_0;
   reg [8*24-1:0] reg_wr_data_tail_1;

   reg [8*3-1:0]  reg_wr_data_mask_tail_0;
   reg [8*3-1:0]  reg_wr_data_mask_tail_1;

   // shuf_flag_tail
   always @(posedge clk) begin
      reg_shuf_flag_tail <= {shuf_flag[0], shuf_flag[2:1]};
      reg_conf_offset_tail <= conf_offset;
      reg_wr_data_maks_tail_0 <= reg_wr_data_mask_0;

   end

   // reg_wr_data_tail_0
   always @(posedge clk) begin
      case (reg_conf_offset_tail)
        1: reg_wr_data_tail_0 <= { 56'b0, pix_data_in_d1, 8'b0 };
        2: reg_wr_data_tail_0 <= { 48'b0, pix_data_in_d1, 16'b0 };
        3: reg_wr_data_tail_0 <= { 40'b0, pix_data_in_d1, 24'b0 };
        4: reg_wr_data_tail_0 <= { 32'b0, pix_data_in_d1, 32'b0 };
        5: reg_wr_data_tail_0 <= { 24'b0, pix_data_in_d1, 40'b0 };
        6: reg_wr_data_tail_0 <= { 16'b0, pix_data_in_d1, 48'b0 };
        7: reg_wr_data_tail_0 <= { 8'b0, pix_data_in_d1, 56'b0 };
        default: reg_wr_data_0 <= { 64'b0, pix_data_in_d1, 0'b0 };
      endcase // case (reg_conf_offset_tail)
   end // always @ (posedge clk)

   // reg_wr_data_tail_1
   always @(posedge clk) begin
      case (reg_shuf_flag_tail)
        3'b100: reg_wr_data_tail_1 <= {reg_wr_data_tail_0[8*8-1:0], reg_wr_data_tail_0[8*8*3-1:8*8]};
        3'b010: reg_wr_data_tail_1 <= {reg_wr_data_tail_0[8*8*2-1:0], reg_wr_data_tail_0[8*8*3-1:8*8*2-1]};
        default: reg_wr_data_tail_1 <= reg_wr_data_tail_0;
      endcase // case (reg_shuf_flag_tail)
   end

   // reg_wr_data_mask_1
   always @(posedge clk) begin
      case (reg_shuf_flag_tail)
        3'b100: reg_wr_data_mask_tail_1 <= {reg_wr_data_mask_tail_0[8-1:0], reg_wr_data_mask_tail_0[8*3-1:8]};
        3'b010: reg_wr_data_mask_tail_1 <= {reg_wr_data_mask_tail_0[8*2-1:0], reg_wr_data_mask_tail_0[8*3-1:8*2-1]};
        default: reg_wr_data_mask_tail_1 <= reg_wr_data_mask_tail_0;
      endcase // case (reg_shuf_flag_tail)
   end

   // ----------------------------------------------------------------
   // BRAM Group Control Signal

   reg [8*8*3-1:0] wr_data_gp0;
   reg [8*8*3-1:0] wr_data_gp1;
   reg [8*8*3-1:0] wr_data_gp2;

   reg [8*3-1:0]   wr_data_mask_gp0;
   reg [8*3-1:0]   wr_data_mask_gp1;
   reg [8*3-1:0]   wr_data_mask_gp2;

   reg             wr_data_en_gp0;
   reg             wr_data_en_gp1;
   reg             wr_data_en_gp2;

   reg [3-1:0]     wr_addr_inc_gp0;
   reg [3-1:0]     wr_addr_inc_gp1;
   reg [3-1:0]     wr_addr_inc_gp2;

   wire            flag_write;
   // insert the split part to the next BRAM
   wire            flag_write_line_end;
   // insert the
   wire            flag_write_line_start;

   assign flag_write =








endmodule // decoder
