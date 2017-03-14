//-----------------------------------------------------------------------------
// Title         : SWIN WRAP
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : swin_wrap.v
// Author        : Runbin Shi
// Created       : 13.03.2017
// Last modified : 13.03.2017
//-----------------------------------------------------------------------------
// Description :
//
//------------------------------------------------------------------------------
// Modification history :
// 13.03.2017 : created
//-----------------------------------------------------------------------------

module swin_wrap(/*AUTOARG*/
   // Outputs
   pix_data_out, data_out_vld,
   // Inputs
   clk, rst_n, pix_data_in, data_in_vld, conf_bram_wr_addr,
   conf_bram_wr_data_in, conf_bram_wr_data_en
   );


   // parameter CONF_MIF_FILE = "NONE";

   parameter CONF_DATA_WIDTH = 19;
   parameter CONF_ADDR_WIDTH = 4;

   input wire clk;
   input wire rst_n;

   input wire [16*8-1:0] pix_data_in;
   input wire            data_in_vld;

   input wire [CONF_ADDR_WIDTH-1:0] conf_bram_wr_addr;
   input wire [CONF_DATA_WIDTH-1:0] conf_bram_wr_data_in;
   input wire                       conf_bram_wr_data_en;

   output wire [16*8*3-1:0]         pix_data_out;
   output wire                      data_out_vld;

   wire [CONF_DATA_WIDTH-1:0]       conf_bram_rd_data_out;
   wire [CONF_ADDR_WIDTH-1:0]       conf_bram_rd_addr;

   wire [8*8*3*3-1:0]               wr_data;
   wire [8*3*3-1:0]                 wr_data_mask;
   wire [3-1:0]                     wr_data_group_en;

   wire [3*3-1:0]                   wr_addr_inc;
   wire [3-1:0]                     wr_addr_reset;

   decoder #(
             .CONF_DATA_WIDTH(CONF_DATA_WIDTH),
             .CONF_ADDR_WIDTH(CONF_ADDR_WIDTH)
             )
   u_decoder(
             .clk(clk),
             .rst_n(rst_n),
             .data_in_vld(data_in_vld),
             .pix_data_in(pix_data_in),
             .conf_bram_rd_data_out(conf_bram_rd_data_out),
             .conf_bram_rd_addr(conf_bram_rd_addr),
             .wr_data(wr_data),
             .wr_data_mask(wr_data_mask),
             .wr_data_group_en(wr_data_group_en),
             .wr_addr_inc(wr_addr_inc),
             .wr_addr_reset(wr_addr_reset)
             );


   dbram #(
           .DATA_WIDTH(CONF_DATA_WIDTH),
           .DEPTH(16),
           .ADDR_WIDTH(4)
           )
   u_conf_ram(
              .clk(clk),
              .rst_n(rst_n),
              .wr_data_in(conf_bram_wr_data_in),
              .wr_data_en(conf_bram_wr_data_en),
              .wr_addr(conf_bram_wr_addr),
              .rd_addr(conf_bram_rd_addr),
              .rd_data_out(conf_bram_rd_data_out)
              );

   // 3 instanses of BRAM group
   bram_group u2_bram_group(

                            .clk(clk),
                            .rst_n(rst_n),
                            .wr_data(wr_data[8*8*3*3-1:8*8*3*2]),
                            .wr_data_mask(wr_data_mask[8*3*3-1:8*3*2]),
                            .wr_data_group_en(wr_data_group_en[2]),
                            .wr_addr_inc(wr_addr_inc[3*3-1:3*2]),
                            .wr_addr_reset(wr_addr_reset[2])
                            );

   bram_group u1_bram_group(
                            .clk(clk),
                            .rst_n(rst_n),
                            .wr_data(wr_data[8*8*3*2-1:8*8*3*1]),
                            .wr_data_mask(wr_data_mask[8*3*2-1:8*3*1]),
                            .wr_data_group_en(wr_data_group_en[1]),
                            .wr_addr_inc(wr_addr_inc[3*2-1:3*1]),
                            .wr_addr_reset(wr_addr_reset[1])
                            );

   bram_group u0_bram_group(

                            .clk(clk),
                            .rst_n(rst_n),
                            .wr_data(wr_data[8*8*3*1-1:8*8*3*0]),
                            .wr_data_mask(wr_data_mask[8*3*1-1:8*3*0]),
                            .wr_data_group_en(wr_data_group_en[0]),
                            .wr_addr_inc(wr_addr_inc[3*1-1:3*0]),
                            .wr_addr_reset(wr_addr_reset[0])
                            );

endmodule // swin_wrap
