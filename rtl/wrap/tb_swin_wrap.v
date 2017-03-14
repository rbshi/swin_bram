//-----------------------------------------------------------------------------
// Title         : Testbench for SWIN WRAP
// Project       : SWIN_BRAM
//-----------------------------------------------------------------------------
// File          : tb_swin_wrap.v
// Author        : Runbin Shi  <rbshi@rbshi-MAC>
// Created       : 13.03.2017
// Last modified : 13.03.2017
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Modification history :
// 13.03.2017 : created
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module tb_swin_wrap();

   // Parameters for Simulation
   parameter clk_period = 10; // ns, 100MHz
   parameter start_delay = 30; // clk cycle
   parameter rst_delay = 20;
   parameter rst_period = 5;

   // Simulation Input Config
   parameter WORD_WIDTH = 16*8;
   parameter STREAM_LEN = 512;

   // configuration RAM Related
   parameter CONF_DATA_WIDTH = 19;
   parameter CONF_ADDR_WIDTH = 9;
   parameter CONF_MIF_FILE = "../../testdata/conf_file.mif";

   //
   reg clk;
   reg rst_n;

   reg [16*8-1:0] pix_data_in;
   reg              data_in_vld;

   wire [16*8*3-1:0] pix_data_out;
   wire              data_out_vld;


   // Variables for Simulation
   integer                     in_file, out_file;
   integer                     ii, jj;
   integer                     temp;


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

   reg [WORD_WIDTH-1:0] input_data [STREAM_LEN-1:0];

   // Open file
   initial begin
      in_file = $fopen("../../testdata/input_swin.txt", "r");
      out_file = $fopen("../../testdata/output_swin.txt", "w");
   end

   initial begin
      for (ii=0;ii<STREAM_LEN;ii=ii+1) begin
         temp = $fscanf(in_file, "%x", input_data[ii]);
      end
   end

   initial begin

      // initialize the Config RAM with MIF file
      $readmemh(CONF_MIF_FILE, u_swin_wrap.u_conf_ram.ram);

      #(clk_period*start_delay);

      // Send the data and enable signal
      for (jj=0;jj<STREAM_LEN;jj=jj+1) begin
         @(posedge clk);
         data_in_vld <= 1;
         pix_data_in <= input_data[jj];
      end

      @(posedge clk);
      data_in_vld <= 0;

      #(clk_period*10);
/* -----\/----- EXCLUDED -----\/-----

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
 -----/\----- EXCLUDED -----/\----- */

      #(clk_period*10);
      $finish;

   end // initial begin

   // DUT instantition

   swin_wrap u_swin_wrap(
                         .clk(clk),
                         .rst_n(rst_n),
                         .pix_data_in(pix_data_in),
                         .data_in_vld(data_in_vld),
                         .pix_data_out(pix_data_out),
                         .data_out_vld(data_out_vld)
                         );


endmodule // tb_swin_wrap
