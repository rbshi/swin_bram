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
   reg            data_in_vld;

   wire [8*16-1:0] data_out_line_0;
   wire [8*16-1:0] data_out_line_1;
   wire [8*16-1:0] data_out_line_2;

   wire            data_out_vld;


   // Variables for Simulation
   integer         in_file;
   integer         line0_out_file;
   integer         line1_out_file;
   integer         line2_out_file;
   integer         ii, jj;
   integer         temp;


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
      line0_out_file = $fopen("../../testdata/output_line0.txt", "w");
      line1_out_file = $fopen("../../testdata/output_line1.txt", "w");
      line2_out_file = $fopen("../../testdata/output_line2.txt", "w");
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

      $fclose(line0_out_file);
      $fclose(line1_out_file);
      $fclose(line2_out_file);

   end // initial begin

   // Dump file
   always @(posedge clk) begin
      if(data_out_vld) begin
         $fdisplay(line0_out_file, "%x", data_out_line_0);
         $fdisplay(line1_out_file, "%x", data_out_line_1);
         $fdisplay(line2_out_file, "%x", data_out_line_2);
      end
   end

   // DUT instantition

   swin_wrap u_swin_wrap(
                         .clk(clk),
                         .rst_n(rst_n),
                         .pix_data_in(pix_data_in),
                         .data_in_vld(data_in_vld),
                         .data_out_line_0(data_out_line_0),
                         .data_out_line_1(data_out_line_1),
                         .data_out_line_2(data_out_line_2),
                         .data_out_vld(data_out_vld)
                         );


endmodule // tb_swin_wrap
