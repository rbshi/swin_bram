//-----------------------------------------------------------------------------
// Title         : Configuration Decoder
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : decoder.v
// Author        : Runbin Shi
// Created       : 11.03.2017
// Last modified : 13.03.2017
//-----------------------------------------------------------------------------
// Description : Decoder module for the Configuration BRAM data
//
//-----------------------------------------------------------------------------
// Modification history :
// 11.03.2017 : created
// 12.03.2017 : revised with line end and start action
//-----------------------------------------------------------------------------

module decoder(/*AUTOARG*/
   // Outputs
   conf_bram_rd_addr, wr_data, wr_data_mask, wr_data_group_en,
   wr_addr_inc, wr_addr_reset, rd_addr_sel, data_out_line_0,
   data_out_line_1, data_out_line_2, data_out_vld,
   // Inputs
   clk, rst_n, data_in_vld, pix_data_in, conf_bram_rd_data_out,
   rd_data_out_gp0, rd_data_out_gp1, rd_data_out_gp2
   );

   parameter CONF_DATA_WIDTH = 19;
   parameter CONF_ADDR_WIDTH = 9;

   input wire clk;
   input wire rst_n;

   // connected to data_in_vld
   input wire data_in_vld;
   // connected to the pix_data_in
   input wire [16*8-1:0] pix_data_in;

   input wire [CONF_DATA_WIDTH-1:0] conf_bram_rd_data_out;

   output reg [CONF_ADDR_WIDTH-1:0] conf_bram_rd_addr;

   output wire [8*8*3*3-1:0]        wr_data;
   output wire [8*3*3-1:0]          wr_data_mask;
   output wire [3-1:0]              wr_data_group_en;

   output wire [3*3-1:0]            wr_addr_inc;
   output wire [3-1:0]              wr_addr_reset;

   // rd_data_related
   input wire [8*8*3-1:0]                 rd_data_out_gp0;
   input wire [8*8*3-1:0]                 rd_data_out_gp1;
   input wire [8*8*3-1:0]                 rd_data_out_gp2;

   output wire [3-1:0]                    rd_addr_sel;

   output reg [8*16-1:0]                 data_out_line_0;
   output reg [8*16-1:0]                 data_out_line_1;
   output reg [8*16-1:0]                 data_out_line_2;

   output wire                            data_out_vld;

   wire [CONF_DATA_WIDTH-1:0]       conf_data;
   wire [3-1:0]                     conf_offset;
   wire [3-1:0]                     conf_order;
   wire [8-1:0]                     conf_cycle;
   wire [1-1:0]                     conf_addr_ret;
   wire [4-1:0]                     conf_split;

   // ----------------------------------------------------------------
   // Delay Signal

   integer ii;

   // data_in_vld
   reg [9-1:0] data_in_vld_d;
   always @(posedge clk) begin
      data_in_vld_d[0] <= data_in_vld;
      for(ii=1;ii<9;ii=ii+1) begin
         data_in_vld_d[ii] <= data_in_vld_d[ii-1];
      end
   end

   // group_wr_en
   reg [3-1:0] group_wr_en;

   reg [3-1:0]       group_wr_en_d0;
   reg [3-1:0]       group_wr_en_d1;
   reg [3-1:0]       group_wr_en_d2;
   reg [3-1:0]       group_wr_en_d3;
   reg [3-1:0]       group_wr_en_d4;
   always @(posedge clk) begin
      group_wr_en_d0 <= group_wr_en;
      group_wr_en_d1 <= group_wr_en_d0;
      group_wr_en_d2 <= group_wr_en_d1;
      group_wr_en_d3 <= group_wr_en_d2;
      group_wr_en_d4 <= group_wr_en_d3;
   end

   // inline_cnt
   reg [9-1:0] inline_cnt;
   reg [9-1:0] inline_cnt_d0;
   reg [9-1:0] inline_cnt_d1;
   reg [9-1:0] inline_cnt_d2;

   always @(posedge clk) begin
      inline_cnt_d0 <= inline_cnt;
      inline_cnt_d1 <= inline_cnt_d0;
      inline_cnt_d2 <= inline_cnt_d1;
   end

   // shuf_flag
   reg [3-1:0]       shuf_flag;
   reg [3-1:0]       shuf_flag_d0;
   reg [3-1:0]       shuf_flag_d1;
   reg [3-1:0]       shuf_flag_d2;

   always @(posedge clk) begin
      shuf_flag_d0 <= shuf_flag;
      shuf_flag_d1 <= shuf_flag_d0;
      shuf_flag_d2 <= shuf_flag_d1;
   end

   // offset
   reg [3-1:0] offset_d0;
   reg [3-1:0] offset_d1;
   reg [3-1:0] offset_d2;
   reg [3-1:0] offset_d3;
   reg [3-1:0] offset_d4;

   always @(posedge clk) begin
      offset_d0 <= conf_offset;
      offset_d1 <= offset_d0;
      offset_d2 <= offset_d1;
      offset_d3 <= offset_d2;
      offset_d4 <= offset_d3;
   end

   // pix_data_in
   reg [16*8-1:0] pix_data_in_d0;
   reg [16*8-1:0] pix_data_in_d1;
   reg [16*8-1:0] pix_data_in_d2;
   reg [16*8-1:0] pix_data_in_d3;
   reg [16*8-1:0] pix_data_in_d4;
   reg [16*8-1:0] pix_data_in_d5;
   reg [16*8-1:0] pix_data_in_d6;
   reg [16*8-1:0] pix_data_in_d7;

   always @(posedge clk) begin
      pix_data_in_d0 <= pix_data_in;
      pix_data_in_d1 <= pix_data_in_d0;
      pix_data_in_d2 <= pix_data_in_d1;
      pix_data_in_d3 <= pix_data_in_d2;
      pix_data_in_d4 <= pix_data_in_d3;
      pix_data_in_d5 <= pix_data_in_d4;
      pix_data_in_d6 <= pix_data_in_d5;
      pix_data_in_d7 <= pix_data_in_d6;
   end

   // ----------------------------------------------------------------
   // config_data_wire

   assign conf_data = conf_bram_rd_data_out;

   assign conf_offset = conf_data[2:0];
   assign conf_order = conf_data[5:3];
   assign conf_cycle = conf_data[13:6];
   assign conf_addr_ret = conf_data[14];
   assign conf_split = conf_data[18:15];

   // Configuration BRAM read related

   // ret_flag

   reg ret_flag;

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         ret_flag <= 0;
      end else begin
         if(data_in_vld_d[1] && inline_cnt==0 ) begin
            ret_flag <= conf_addr_ret;
         end
      end
   end

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

   // ----------------------------------------------------------------
   // norm write signal generation

   reg [8*8*3-1:0] reg_wr_data_0;
   reg [8*8*3-1:0] reg_wr_data_1;
   reg [8*3-1:0]   reg_wr_data_mask_0;
   reg [8*3-1:0]   reg_wr_data_mask_1;
   //   reg [9-1:0]     reg_wr_data_en_0;
   //   reg [9-1:0]     reg_wr_data_en_1;

   // group_wr_en
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         group_wr_en <= 3'b100;
      end else begin
         if(data_in_vld_d[1] && inline_cnt==0)
           group_wr_en <= {group_wr_en[1:0], group_wr_en[2]};
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
           default: reg_wr_data_0 <= { 64'b0, pix_data_in_d1};
         endcase // case (conf_offset)
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // reg_wr_data_mask_0
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_mask_0 <= 0;
      end else begin
         case (conf_offset)
           0: reg_wr_data_mask_0 <= { 8'b0, 16'hFFFF };
           1: reg_wr_data_mask_0 <= { 7'b0, 16'hFFFF, 1'b0 };
           2: reg_wr_data_mask_0 <= { 6'b0, 16'hFFFF, 2'b0 };
           3: reg_wr_data_mask_0 <= { 5'b0, 16'hFFFF, 3'b0 };
           4: reg_wr_data_mask_0 <= { 4'b0, 16'hFFFF, 4'b0 };
           5: reg_wr_data_mask_0 <= { 3'b0, 16'hFFFF, 5'b0 };
           6: reg_wr_data_mask_0 <= { 2'b0, 16'hFFFF, 6'b0 };
           7: reg_wr_data_mask_0 <= { 1'b0, 16'hFFFF, 7'b0 };
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
           3'b101: reg_wr_data_1 <= {reg_wr_data_0[8*8-1:0], reg_wr_data_0[8*8*3-1:8*8]};
           3'b110: reg_wr_data_1 <= {reg_wr_data_0[8*8*2-1:0], reg_wr_data_0[8*8*3-1:8*8*2]};
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
           3'b101: reg_wr_data_mask_1 <= {reg_wr_data_mask_0[8-1:0], reg_wr_data_mask_0[8*3-1:8]};
           3'b110: reg_wr_data_mask_1 <= {reg_wr_data_mask_0[8*2-1:0], reg_wr_data_mask_0[8*3-1:8*2]};
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
        default: reg_wr_data_s0 <= 128'b0;
      endcase // case (conf_split)
      reg_wr_data_s1 <= reg_wr_data_s0;
   end // always @ (posedge clk)

   // reg_wr_addr_inc_s0&1
   always @(posedge clk) begin
      // conf_split[2] stands for 8
      case(conf_split[2])
        1: reg_wr_addr_inc_s0 <= 3'b001;
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
      reg_wr_data_mask_tail_0 <= reg_wr_data_mask_0;

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
        default: reg_wr_data_tail_0 <= { 64'b0, pix_data_in_d1 };
      endcase // case (reg_conf_offset_tail)
   end // always @ (posedge clk)

   // reg_wr_data_tail_1
   always @(posedge clk) begin
      case (reg_shuf_flag_tail)
        3'b100: reg_wr_data_tail_1 <= {reg_wr_data_tail_0[8*8-1:0], reg_wr_data_tail_0[8*8*3-1:8*8]};
        3'b010: reg_wr_data_tail_1 <= {reg_wr_data_tail_0[8*8*2-1:0], reg_wr_data_tail_0[8*8*3-1:8*8*2]};
        default: reg_wr_data_tail_1 <= reg_wr_data_tail_0;
      endcase // case (reg_shuf_flag_tail)
   end

   // reg_wr_data_mask_1
   always @(posedge clk) begin
      case (reg_shuf_flag_tail)
        3'b100: reg_wr_data_mask_tail_1 <= {reg_wr_data_mask_tail_0[8-1:0], reg_wr_data_mask_tail_0[8*3-1:8]};
        3'b010: reg_wr_data_mask_tail_1 <= {reg_wr_data_mask_tail_0[8*2-1:0], reg_wr_data_mask_tail_0[8*3-1:8*2]};
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

   reg [3-1:0]     wr_data_en_gp;
   wire [3-1:0]    wr_data_en_line_end;
   wire [3-1:0]    wr_data_en_line_start;

   reg [3-1:0]     wr_addr_inc_gp0;
   reg [3-1:0]     wr_addr_inc_gp1;
   reg [3-1:0]     wr_addr_inc_gp2;

   reg [3-1:0]     reg_wr_addr_reset;

   // connect the output wire to the intermediate result registers
   assign wr_data = {wr_data_gp2, wr_data_gp1, wr_data_gp0};
   assign wr_data_mask = {wr_data_mask_gp2, wr_data_mask_gp1, wr_data_mask_gp0};
   assign wr_data_group_en = wr_data_en_gp;
   assign wr_addr_inc = {wr_addr_inc_gp2, wr_addr_inc_gp1, wr_addr_inc_gp0};

   assign wr_addr_reset = reg_wr_addr_reset;

   // generate wr_en_mask for wr_data_en_line_end & start;
   // line_end mask is crol
   assign wr_data_en_line_end = { group_wr_en_d0[1:0], group_wr_en_d0[2] };
   // line_start mask is cror
   assign wr_data_en_line_start = { group_wr_en_d0[0], group_wr_en_d0[2:1] };


   wire            flag_write;
   // insert the split part to the next BRAM
   wire            flag_write_line_end;
   // insert the
   wire            flag_write_line_start;

   assign flag_write = data_in_vld_d[2];
   assign flag_write_line_end = data_in_vld_d[2] && (inline_cnt_d0==0);
   // Even d4 corresponds to inline_cnt_d2, but d3 here represents the next batch of input
   assign flag_write_line_start = data_in_vld_d[2] && (inline_cnt_d1==0);

   // wr_data_gpx
   // connection to wr_data_gpx are totally decided by group_wr_en_d0
   always @(posedge clk) begin
      case (group_wr_en_d0)
        3'b001: begin
           wr_data_gp0 <= reg_wr_data_1;
           wr_data_gp1 <= reg_wr_data_s1;
           wr_data_gp2 <= reg_wr_data_tail_1;
        end
        3'b010: begin
           wr_data_gp1 <= reg_wr_data_1;
           wr_data_gp2 <= reg_wr_data_s1;
           wr_data_gp0 <= reg_wr_data_tail_1;
        end
        3'b100: begin
           wr_data_gp2 <= reg_wr_data_1;
           wr_data_gp0 <= reg_wr_data_s1;
           wr_data_gp1 <= reg_wr_data_tail_1;
        end
      endcase // case (group_wr_en_d0)
   end // always @ (posedge clk)

   // wr_data_mask_gpx
   always @(posedge clk) begin
      case (group_wr_en_d0)
        3'b001: begin
           wr_data_mask_gp0 <= reg_wr_data_mask_1;
           wr_data_mask_gp1 <= 24'hFFFFFF;
           wr_data_mask_gp2 <= reg_wr_data_mask_tail_1;
        end
        3'b010: begin
           wr_data_mask_gp1 <= reg_wr_data_mask_1;
           wr_data_mask_gp2 <= 24'hFFFFFF;
           wr_data_mask_gp0 <= reg_wr_data_mask_tail_1;
        end
        3'b100: begin
           wr_data_mask_gp2 <= reg_wr_data_mask_1;
           wr_data_mask_gp0 <= 24'hFFFFFF;
           wr_data_mask_gp1 <= reg_wr_data_mask_tail_1;
        end
      endcase // case (group_wr_en_d0)
   end // always @ (posedge clk)

   // wr_data_en_gpx
   // strict, key controller on BRAM writing
   always @(posedge clk) begin
      case({ flag_write, flag_write_line_end, flag_write_line_start })
        3'b100: wr_data_en_gp <= group_wr_en_d0;
        3'b110: wr_data_en_gp <= group_wr_en_d0 | wr_data_en_line_end;
        3'b101: wr_data_en_gp <= group_wr_en_d0 | wr_data_en_line_start;
        default: wr_data_en_gp <= 3'b000;
      endcase // case ({ flag_write, flag_write_line_end, flag_write_line_start })
   end

   // wr_addr_inc
   // strict, key controller of BRAM writing address
   always @(posedge clk) begin
      // flag_write_line_start situation is the same with normal write, not needed
      case({ flag_write, flag_write_line_end })

        2'b10: begin
           wr_addr_inc_gp0 <= shuf_flag_d0 & {3{group_wr_en_d0[0]}};
           wr_addr_inc_gp1 <= shuf_flag_d0 & {3{group_wr_en_d0[1]}};
           wr_addr_inc_gp2 <= shuf_flag_d0 & {3{group_wr_en_d0[2]}};
        end

        2'b11: begin
           case (group_wr_en_d0)
             3'b001: begin
                wr_addr_inc_gp0 <= shuf_flag_d0;
                // MAX writing will occur in the first 2 BRAM of the next group
                wr_addr_inc_gp1 <= reg_wr_addr_inc_s1;
                wr_addr_inc_gp2 <= 3'b000;
             end
             3'b010: begin
                wr_addr_inc_gp1 <= shuf_flag_d0;
                // MAX writing will occur in the first 2 BRAM of the next group
                wr_addr_inc_gp2 <= reg_wr_addr_inc_s1;
                wr_addr_inc_gp0 <= 3'b000;
             end
             3'b100: begin
                wr_addr_inc_gp2 <= shuf_flag_d0;
                // MAX writing will occur in the first 2 BRAM of the next group
                wr_addr_inc_gp0 <= reg_wr_addr_inc_s1;
                wr_addr_inc_gp1 <= 3'b000;
             end
             default: begin
                wr_addr_inc_gp0 <= 3'b000;
                wr_addr_inc_gp1 <= 3'b000;
                wr_addr_inc_gp2 <= 3'b000;
             end
           endcase // case (group_wr_en_d0)
        end // case: 3'b110

        default: begin
           wr_addr_inc_gp0 <= 3'b000;
           wr_addr_inc_gp1 <= 3'b000;
           wr_addr_inc_gp2 <= 3'b000;
        end

      endcase // case ({ flag_write, flag_write_line_end })
   end // always @ (posedge clk)


   // wr_addr_reset sig

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_addr_reset <= 3'b111;
      end else begin
         if(flag_write_line_start) begin
            case (group_wr_en_d0)
              3'b010: reg_wr_addr_reset <= 3'b001;
              3'b100: reg_wr_addr_reset <= 3'b010;
              3'b001: reg_wr_addr_reset <= 3'b100;
              default: reg_wr_addr_reset <= 3'b000;
            endcase // case (group_wr_en_d0)
         end else
           reg_wr_addr_reset <= 3'b000;
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)


   // rd_data_related
   // rd_addr_sel is the same with group_wr_en and output at the same clock with
   // wr_data_group_en
   assign rd_addr_sel = group_wr_en_d1;

   // out stage 0
   reg [8*8*3-1:0] rd_data_deshuf_gp0;
   reg [8*8*3-1:0] rd_data_deshuf_gp1;
   reg [8*8*3-1:0] rd_data_deshuf_gp2;

   always @(posedge clk) begin
      // don't care about data vld, just intermediate result
      case (shuf_flag_d2)
        3'b011: begin
           rd_data_deshuf_gp0 <= rd_data_out_gp0;
           rd_data_deshuf_gp1 <= rd_data_out_gp1;
           rd_data_deshuf_gp2 <= rd_data_out_gp2;
        end
        3'b110: begin
           rd_data_deshuf_gp0 <= {rd_data_out_gp0[8*8*1-1:8*8*0],rd_data_out_gp0[8*8*3-1:8*8*1]};
           rd_data_deshuf_gp1 <= {rd_data_out_gp1[8*8*1-1:8*8*0],rd_data_out_gp1[8*8*3-1:8*8*1]};
           rd_data_deshuf_gp2 <= {rd_data_out_gp2[8*8*1-1:8*8*0],rd_data_out_gp2[8*8*3-1:8*8*1]};
        end
        3'b101: begin
           rd_data_deshuf_gp0 <= {rd_data_out_gp0[8*8*2-1:8*8*0],rd_data_out_gp0[8*8*3-1:8*8*2]};
           rd_data_deshuf_gp1 <= {rd_data_out_gp1[8*8*2-1:8*8*0],rd_data_out_gp1[8*8*3-1:8*8*2]};
           rd_data_deshuf_gp2 <= {rd_data_out_gp2[8*8*2-1:8*8*0],rd_data_out_gp2[8*8*3-1:8*8*2]};
        end
      endcase // case (shuf_flag_d2)
   end // always @ (posedge clk)

   // out stage 1
   reg [8*8*2-1:0] rd_data_deoffset_gp0;
   reg [8*8*2-1:0] rd_data_deoffset_gp1;
   reg [8*8*2-1:0] rd_data_deoffset_gp2;

   always @(posedge clk) begin
      case (offset_d4)
        0: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*16-1-:8*16];
        1: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*17-1-:8*16];
        2: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*18-1-:8*16];
        3: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*19-1-:8*16];
        4: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*20-1-:8*16];
        5: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*21-1-:8*16];
        6: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*22-1-:8*16];
        7: rd_data_deoffset_gp0 <= rd_data_deshuf_gp0[8*23-1-:8*16];
      endcase // case (offset_d4)
   end // always @ (posedge clk)
   always @(posedge clk) begin
      case (offset_d4)
        0: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*16-1-:8*16];
        1: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*17-1-:8*16];
        2: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*18-1-:8*16];
        3: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*19-1-:8*16];
        4: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*20-1-:8*16];
        5: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*21-1-:8*16];
        6: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*22-1-:8*16];
        7: rd_data_deoffset_gp1 <= rd_data_deshuf_gp1[8*23-1-:8*16];
      endcase // case (offset_d4)
   end // always @ (posedge clk)
   always @(posedge clk) begin
      case (offset_d4)
        0: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*16-1-:8*16];
        1: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*17-1-:8*16];
        2: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*18-1-:8*16];
        3: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*19-1-:8*16];
        4: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*20-1-:8*16];
        5: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*21-1-:8*16];
        6: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*22-1-:8*16];
        7: rd_data_deoffset_gp2 <= rd_data_deshuf_gp2[8*23-1-:8*16];
      endcase // case (offset_d4)
   end // always @ (posedge clk)

   // out stage 2
   always @(posedge clk) begin
      case(group_wr_en_d4)
        3'b001: begin
           data_out_line_0 <= rd_data_deoffset_gp1;
           data_out_line_1 <= rd_data_deoffset_gp2;
           data_out_line_2 <= pix_data_in_d7;
        end
        3'b010: begin
           data_out_line_0 <= rd_data_deoffset_gp2;
           data_out_line_1 <= rd_data_deoffset_gp0;
           data_out_line_2 <= pix_data_in_d7;
        end
        3'b100: begin
           data_out_line_0 <= rd_data_deoffset_gp0;
           data_out_line_1 <= rd_data_deoffset_gp1;
           data_out_line_2 <= pix_data_in_d7;
        end
      endcase // case (group_wr_en_d4)
   end // always @ (posedge clk)

   // data_out_vld
   assign data_out_vld = data_in_vld_d[8];

endmodule // decoder
