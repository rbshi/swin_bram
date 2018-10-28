module decoder(/*AUTOARG*/
               // Outputs
               conf_bram_rd_addr, wr_data, wr_data_mask, wr_data_en, wr_addr_inc,
               wr_addr_reset, rd_addr_sel, pix_out, pix_out_vld,
               // Inputs
               clk, rst_n, pix_in_vld, pix_in, conf_bram_rd_data_out,
               rd_data_out_grp
               );

   // user-defined parameters
   parameter LEN_PIX = 8;
   parameter LEN_BLK = 16;
   parameter H_WIN = 3;
   // W_BRAM should be auto
   parameter W_BRAM = 8;
   parameter W_ADDR_BRAM = $clog2(32768/W_BRAM/LEN_PIX);
   parameter N_BRAM_GRP = $ceil(LEN_BLK/LEN_PIX)+1;

   // width of config words
   parameter W_CONF_OFFSET = $clog2(W_BRAM);
   parameter W_CONF_SHUF_VAL = 3; // fixed, the most shuffle value is 7
   parameter W_CONF_SHUF_FLAG = N_BRAM_GRP;
   parameter W_CONF_SPLIT = $clog2(LEN_BLK);
   parameter W_CONF_CYCLE = W_ADDR_BRAM;

   parameter CONF_DATA_WIDTH = W_CONF_OFFSET + W_CONF_SHUF_VAL + W_CONF_SHUF_FLAG + W_CONF_CYCLE + 1 + W_CONF_SPLIT;
   // fixed in SWIN framework
   parameter CONF_ADDR_WIDTH = 9;


   // I/O wires
   input wire clk;
   input wire rst_n;
   input wire pix_in_vld;
   input wire [LEN_BLK*LEN_PIX-1:0] pix_in;

   // Configure BRAM
   input wire [CONF_DATA_WIDTH-1:0] conf_bram_rd_data_out;
   output reg [CONF_ADDR_WIDTH-1:0] conf_bram_rd_addr;

   // BRAM R/W signal
   // 3 here is fixed as each buffer grp is composed of 3 BRAMs
   output wire [LEN_PIX*W_BRAM*H_WIN*N_BRAM_GRP-1:0] wr_data;
   output wire [W_BRAM*H_WIN*N_BRAM_GRP-1:0]         wr_data_mask;
   output wire [H_WIN-1:0]                           wr_data_en;

   // wr-address increase signal
   output wire [W_BRAM*N_BRAM_GRP-1:0]               wr_addr_inc;
   output reg [H_WIN-1:0]                            wr_addr_reset;

   // rd_data_related
   input wire [LEN_PIX*LEN_BLK*N_BRAM_GRP*H_WIN-1:0] rd_data_out_grp;
   output wire [H_WIN-1:0]                           rd_addr_sel;
   output wire [LEN_PIX*LEN_BLK*H_WIN-1:0]           pix_out;
   output wire                                       pix_out_vld;

   // config-bram related
   wire [W_CONF_OFFSET-1:0]                          conf_offset;
   wire [W_CONF_SHUF_VAL-1:0]                        conf_shuf_val;
   wire [W_CONF_SHUF_FLAG-1:0]                       conf_shuf_flag;
   wire [W_CONF_CYCLE-1:0]                           conf_cycle;
   wire                                              conf_addr_ret;
   wire [W_CONF_SPLIT-1:0]                           conf_split;


   // ----------------------------------------------------------------
   // Delay Signal

   integer                                           ii;
   genvar                                            g;   

   // pix_in_vld
   reg [8:0]                                         pix_in_vld_d;
   always @(posedge clk) begin
      pix_in_vld_d[0] <= pix_in_vld;
      for(ii=0;ii<8;ii=ii+1) begin
         pix_in_vld_d[ii+1] <= pix_in_vld_d[ii];
      end
   end

   // grp_wr_en
   reg [H_WIN-1:0] grp_wr_en;
   reg [H_WIN-1:0] grp_wr_en_d[4:0];
   always @(posedge clk) begin
      grp_wr_en_d[0] <= grp_wr_en;
      for(ii=0;ii<4;ii=ii+1) begin
         grp_wr_en_d[ii+1] <= grp_wr_en_d[ii];
      end
   end

   // inline_cnt
   reg [W_ADDR_BRAM-1:0] inline_cnt;
   reg [W_ADDR_BRAM-1:0] inline_cnt_d[2:0];
   always @(posedge clk) begin
      inline_cnt_d[0] <= inline_cnt;
      inline_cnt_d[1] <= inline_cnt_d[0];
      inline_cnt_d[2] <= inline_cnt_d[1];
   end

   // shuf_flag
   reg [NUM_BRAM_GRP-1:0]       shuf_flag;
   reg [NUM_BRAM_GRP-1:0]       shuf_flag_d[2:0];
   always @(posedge clk) begin
      shuf_flag_d[0] <= shuf_flag;
      shuf_flag_d[1] <= shuf_flag_d[0];
      shuf_flag_d[2] <= shuf_flag_d[1];
   end

   // shuf_flag
   reg [NUM_BRAM_GRP-1:0]       shuf_val;
   reg [NUM_BRAM_GRP-1:0]       shuf_val_d[2:0];
   always @(posedge clk) begin
      shuf_val_d[0] <= shuf_val;
      shuf_val_d[1] <= shuf_val_d[0];
      shuf_val_d[2] <= shuf_val_d[1];
   end

   // offset
   reg [W_CONF_OFFSET-1:0] offset_d[4:0];
   always @(posedge clk) begin
      offset_d[0] <= conf_offset;
      for(ii=0;ii<4;ii=ii+1) begin
         offset_d[ii+1] <= offset_d[ii];
      end
   end

   // pix_in delay
   // TODO: can be removed with a cost of losing the heading blocks
   reg [LEN_BLK*LEN_PIX-1:0] pix_in_d[8:0];

   always @(posedge clk) begin
      pix_in_d[0] <= pix_in;
      for(ii=0;ii<8;ii=ii+1) begin
         pix_in_d[ii+1] <= pix_in_d[ii];
      end
   end

   // ----------------------------------------------------------------
   // config data read
   assign {conf_split, conf_addr_ret, conf_cycle, conf_shuf, conf_offset} = conf_bram_rd_data_out;

   // config works memory related
   reg ret_flag;
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         ret_flag <= 0;
      end else begin
         if(pix_in_vld_d[1] && inline_cnt==0) begin
            ret_flag <= conf_addr_ret;
         end
      end
   end

   // conf_bram_rd_addr
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         conf_bram_rd_addr <= 0;
      end else begin
         if(pix_in_vld && inline_cnt==2) begin
            if(ret_flag)
              conf_bram_rd_addr <= 0;
            else
              conf_bram_rd_addr <= conf_bram_rd_addr + 1;
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   // ----------------------------------------------------------------
   // norm write signal generation

   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] reg_wr_data_0;
   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] reg_wr_data_1;
   reg [W_BRAM*N_BRAM_GRP-1:0]         reg_wr_data_mask_0;
   reg [W_BRAM*N_BRAM_GRP-1:0]         reg_wr_data_mask_1;

   // inline_cnt (this is a counter that indicates the blk index in one image line)
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         inline_cnt <= 0;
      end else begin
         if(pix_in_vld_d[1]) begin
            if(inline_cnt==0)
              inline_cnt <= conf_cycle;
            else
              inline_cnt <= inline_cnt-1;
         end
      end
   end // always @ (posedge clk or negedge rst_nt)

   // grp_wr_en
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         grp_wr_en <= {1'b1, (H_WIN-1)'b0};
      end else begin
         if(pix_in_vld_d[1] && inline_cnt==0)
           // cyclic left shift
           grp_wr_en <= {grp_wr_en[H_WIN-2:0], grp_wr_en[H_WIN]};
      end
   end

   // shuf_flag & shuf value
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         shuf_flag <= 0;
         shuf_val <= 0;
      end else begin
         if(pix_in_vld_d[1]) begin
            if(inline_cnt==0) begin
               shuf_flag <= conf_shuf_flag;
               shuf_val <= conf_shuf_val;
            end else
              shuf_val <= (shuf_val==N_BRAM_GRP)? 0 : (shuf_val+1);
            // cyclic left shift
            shuf_flag <= {shuf_flag[N_BRAM_GRP-2:0], shuf_flag[N_BRAM_GRP-1]};
         end
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)


   // level_0 ctl_sig
   // reg_wr_data_0
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_0 <= 0;
      end else begin
         for (int j=0; j<W_BRAM; j=j+1) begin
            if (conf_offset == j)
              reg_wr_data_0 <= {{LEN_PIX*(N_BRAM_GRP*W_BRAM-LEN_BLK-j){1'b0}}, pix_in_d[1],{LEN_PIX*j{1'b0}}};
         end
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // reg_wr_data_mask_0
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_mask_0 <= 0;
      end else begin
         for (int j=0; j<W_BRAM; j=j+1) begin
            if (conf_offset == j)
              reg_wr_data_mask_0 <= {{(N_BRAM_GRP*W_BRAM-LEN_BLK-j){1'b0}}, {LEN_BLK{1'b0}} ,{j{1'b0}}};
         end
      end // else: !if(!rst_n)
   end // always @ (posedge clk or negedge rst_n)

   // level_1 ctl_sig
   // reg_wr_data_1
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_1 <= 0;
      end else begin
         for (int j=0; j<N_BRAM_GRP; j=j+1) begin
            if (shuf_val == j)
              reg_wr_data_1 <= {reg_wr_data_0[0+:(N_BRAM_GRP-j)*W_BRAM*LEN_PIX], reg_wr_data_0[LEN_PIX*W_BRAM*N_BRAM_GRP-1-:j*W_BRAM*LEN_PIX]};
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   // reg_wr_data_mask_1
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         reg_wr_data_mask_1 <= 0;
      end else begin
         for (int j=0; j<N_BRAM_GRP; j=j+1) begin
            if (shuf_val == j)
              reg_wr_data_mask_1 <= {reg_wr_data_mask_0[0+:(N_BRAM_GRP-j)*W_BRAM], reg_wr_data_mask_0[W_BRAM*N_BRAM_GRP-1-:j*W_BRAM]};
         end
      end
   end // always @ (posedge clk or negedge rst_n)

   // ----------------------------------------------------------------
   // Special sig for Line End and Start
   // Line End , Split
   reg [LEN_PIX*LEN_BLK-1:0] reg_wr_data_s0;
   reg [LEN_PIX*LEN_BLK-1:0] reg_wr_data_s1;
   // No mask & wr_en signal for split part writing; coz the rest part will be overwirted, just write 16 pixels
   reg [N_BRAM_GRP-1:0]      reg_wr_addr_inc_s0;
   reg [N_BRAM_GRP-1:0]      reg_wr_addr_inc_s1;

   // reg_wr_data_s0&s1
   always @(posedge clk) begin
      for (int j=0; j<LEN_BLK; j=j+1) begin
         if (conf_split == j) begin
            if (conf_split == 0)
              reg_wr_data_s0 <= {LEN_PIX*LEN_BLK{1'b0}};
            else
              reg_wr_data_s0 <= {(LEN_PIX*(LEN_BLK-j)){1'b0}, pix_in_d[1][LEN_PIX*LEN_BLK-1-:LEN_PIX*j]};
         end
      end
      reg_wr_data_s1 <= reg_wr_data_s0;      
   end // always @ (posedge clk)

   // reg_wr_addr_inc_s0&1
   always @(posedge clk) begin
      for (int j=0; j<$ceil(LEN_BLK/W_BRAM); j=j+1) begin
         if (conf_split >= j*W_BRAM && conf_split < (j+1)*W_BRAM) begin
            if (j==0)
              reg_wr_addr_inc_s0 <= {N_BRAM_GRP{1'b0}};
            else
              reg_wr_addr_inc_s0 <= {(N_BRAM_GRP-j){1'b0}, j{1'b0}};
         end
      end
      reg_wr_addr_inc_s1 <= reg_wr_addr_inc_s0;      
   end


   // ----------------------------------------------------------------
   // Line Start, tailappend
   reg [W_CONF_SHUF_FLAG -1:0] reg_shuf_flag_tail;
   reg [W_CONF_SHUF_VAL-1:0]   reg_shuf_val_tail;   
   reg [W_CONF_OFFSET-1:0]     reg_conf_offset_tail;
   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] reg_wr_data_tail_0;
   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] reg_wr_data_tail_1;
   reg [W_BRAM*N_BRAM_GRP-1:0]         reg_wr_data_mask_tail_0;
   reg [W_BRAM*N_BRAM_GRP-1:0]         reg_wr_data_mask_tail_1;

   always @(posedge clk) begin     
      reg_shuf_flag_tail <= {shuf_flag[N_BRAM_GRP-2:0], shuf_flag[N_BRAM_GRP-1]};
      reg_shuf_val_tail == (shuf_val==N_BRAM_GRP)? 0 : (shuf_val+1);
      reg_conf_offset_tail <= conf_offset;
      reg_wr_data_mask_tail_0 <= reg_wr_data_mask_0;
   end

   // reg_wr_data_tail_0
   always @(posedge clk) begin
      for (int j=0; j<W_BRAM; j=j+1) begin
         if (reg_conf_offset_tail == j)
           reg_wr_data_tail_0 <= {{LEN_PIX*(N_BRAM_GRP*W_BRAM-LEN_BLK-j){1'b0}}, pix_in_d[1],{LEN_PIX*j{1'b0}}};
      end
   end
   
   // reg_wr_data_tail_1
   always @(posedge clk) begin
      for (int j=0; j<N_BRAM_GRP; j=j+1) begin
         if (reg_shuf_val_tail == j)
           reg_wr_data_tail_1 <= {reg_wr_data_tail_0[0+:(N_BRAM_GRP-j)*W_BRAM*LEN_PIX], reg_wr_data_tail_0[LEN_PIX*W_BRAM*N_BRAM_GRP-1-:j*W_BRAM*LEN_PIX]};
      end
   end
   
   // reg_wr_data_mask_1
   always @(posedge clk) begin
      for (int j=0; j<N_BRAM_GRP; j=j+1) begin
         if (reg_shuf_val_tail == j)
           reg_wr_data_mask_1 <= {reg_wr_data_mask_tail_0[0+:(N_BRAM_GRP-j)*W_BRAM], reg_wr_data_mask_tail_0[W_BRAM*N_BRAM_GRP-1-:j*W_BRAM]};
      end
   end
   
   // ----------------------------------------------------------------
   // BRAM Grp Control Signal
   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] wr_data_grp[H_WIN-1:0];
   reg [W_BRAM*N_BRAM_GRP-1:0]         wr_data_mask_grp[H_WIN-1:0];
   reg [H_WIN-1:0]                     wr_data_en_grp;
   wire [H_WIN-1:0]                    wr_data_en_line_end; // TODO
   wire [H_WIN-1:0]                    wr_data_en_line_start;
   reg [N_BRAM_GRP-1:0]                wr_addr_inc_grp[H_WIN-1:0];
   
   // connect the output wire to the intermediate result registers
   generate
      for (g=0; g<H_WIN; g=g+1) begin
         assign wr_data[LEN_PIX*W_BRAM*N_BRAM_GRP*g+:LEN_PIX*W_BRAM*N_BRAM_GRP] = wr_data_grp[g];
         assign wr_data_mask[W_BRAM*N_BRAM_GRP*g+:W_BRAM*N_BRAM_GRP] = wr_data_mask_grp[g];
         assign wr_addr_inc[N_BRAM_GRP*g+:N_BRAM_GRP] = wr_addr_inc_grp[g];
      end
   endgenerate
   assign wr_data_en = wr_data_en_grp;

   // generate wr_en_mask for wr_data_en_line_end & start;
   // line_end mask is crol
   assign wr_data_en_line_end = {grp_wr_en_d[0][H_WIN-2:0], grp_wr_en_d[0][H_WIN-1]};
   // line_start mask is cror
   assign wr_data_en_line_start = {grp_wr_en_d[0][0], grp_wr_en_d0[H_WIN-1:1]};

   wire            flag_write;
   // insert the split part to the next BRAM
   wire            flag_write_line_end;
   wire            flag_write_line_start;

   assign flag_write = pix_in_vld_d[3];
   assign flag_write_line_end = pix_in_vld_d[3] && (inline_cnt_d[0]==0);
   // Even d4 corresponds to inline_cnt_d2, but d3 here represents the next batch of input
   assign flag_write_line_start = pix_in_vld_d[3] && (inline_cnt_d[1]==0);

   // wr_data_grpx
   // connection to wr_data_grpx are totally decided by grp_wr_en_d0
   always @(posedge clk) begin
      for (int j=0; j<H_WIN, j=j+1) begin
         if (grp_wr_en_d[0] == (2**j)) begin
            wr_data_grp[j] <= reg_wr_data_1;
            wr_data_grp[(j+1)%H_WIN] <= reg_wr_data_s1;
            wr_data_grp[(j+H_WIN-1)%H_WIN] <= reg_wr_data_tail_1;
         end
      end
   end

   always @(posedge clk) begin
      for (int j=0; j<H_WIN, j=j+1) begin
         if (grp_wr_en_d[0] == (2**j)) begin
            wr_data_mask_grp[j] <= reg_wr_data_mask_1;
            wr_data_mask_grp[(j+1)%H_WIN] <= (N_BRAM_GRP*W_BRAM){1'b1};
            wr_data_mask_grp[(j+H_WIN-1)%H_WIN] <= reg_wr_data_mask_tail_1;
         end
      end
   end

   // wr_data_en_grpx
   // strict, key controller on BRAM writing
   always @(posedge clk) begin
      case({ flag_write, flag_write_line_end, flag_write_line_start })
        3'b100: wr_data_en_grp <= grp_wr_en_d0;
        3'b110: wr_data_en_grp <= grp_wr_en_d0 | wr_data_en_line_end;
        3'b101: wr_data_en_grp <= grp_wr_en_d0 | wr_data_en_line_start;
        default: wr_data_en_grp <= 3'b000;
      endcase // case ({ flag_write, flag_write_line_end, flag_write_line_start })
   end

   // wr_addr_inc
   // strict, key controller of BRAM writing address
   always @(posedge clk) begin
      for (int j=0; j<H_WIN; j=j+1) begin
         for (int k=0; k<N_BRAM_GRP; k=k+1) begin
            if ((flag_write & grp_wr_en_d[0][j] & shuf_flag_d[0][k]) | (flag_write_line_end & grp_wr_en_d[0][(j+H_WIN-1)%H_WIN] & reg_wr_addr_inc_s1[k]))
              wr_addr_inc_grp[j][k] <= 1'b1;
            else
              wr_addr_inc_grp[j][k] <= 1'b0;
         end
      end
   end

   // wr_addr_reset sig
   always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         wr_addr_reset <= 3'b111;
      end else begin
         if(flag_write_line_start) begin
            for (int k=0; k<N_BRAM_GRP; k=k+1) begin
               wr_addr_reset[k] <= grp_wr_en_d[0][(k+1)%H_WIN];
            end
         end
      end
   end // always @ (posedge clk or negedge rst_n)
   

   // rd_data_related
   // rd_addr_sel is the same with grp_wr_en and output at the same clock with
   assign rd_addr_sel = grp_wr_en_d[0];

   // out stage 0
   reg [LEN_PIX*W_BRAM*N_BRAM_GRP-1:0] rd_data_deshuf_grp[H_WIN-1:0];

   generate
      for (g=0; g<H_WIN; g=g+1) begin
         always @(posedge clk) begin
            for (int j=0; j<N_BRAM_GRP; j=j+1) begin
               if (shuf_val_d[2] == j) begin
                  rd_data_deshuf_grp[g] <=  {rd_data_deshuf_grp[g][0+:(N_BRAM_GRP-j)*W_BRAM*LEN_PIX], rd_data_deshuf_grp[g][LEN_PIX*W_BRAM*N_BRAM_GRP-1-:j*W_BRAM*LEN_PIX]};
               end
            end
         end
      end
   endgenerate

   // out stage 1
   reg [LEN_PIX*LEN_BLK-1:0] rd_data_deoffset_grp[H_WIN-1:0];
   generate
      for (g=0; g<H_WIN; g=g+1) begin
         always @(posedge clk) begin
            for (int j=0; j<W_BRAM; j=j+1) begin
               if (offset_d[4] == j) begin
                  rd_data_deoffset_grp[g] <= rd_data_deshuf_grp[g][LEN_PIX*j+:LEN_PIX*LEN_BLK];
               end
            end
         end
      end
   endgenerate

   // out stage 2
   reg [LEN_PIX*LEN_BLK-1:0]           pix_out_line[H_WIN-1:0];
   generate
      for (g=0; g<H_WIN; g=g+1) begin
         assign pix_out[LEN_PIX*LEN_BLK*g+:LEN_PIX*LEN_BLK]  = pix_out_line[g];
      end
   endgenerate   
   
   generate
      for (g=0; g<H_WIN-1; g=g+1) begin
         always @(posedge clk) begin
            for (int j=0; j<H_WIN; j=j+1) begin
               if (grp_wr_en_d[4] == (2**j)) begin
                  pix_out_line[g] <= rd_data_deoffset_grp[(g+j+1)%H_WIN];
               end
            end
         end
      end
   endgenerate
   pix_out_line[H_WIN] <= pix_in_d[7];

   // pix_out_vld
   assign pix_out_vld = pix_in_vld_d[8];

endmodule // decoder
