//-----------------------------------------------------------------------------
// Title         : aria_cu
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_cu.v
// Author        : bonyul gu  <bonyul13@gmail.com>
// Created       : 11.11.2018
// Last modified : 11.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_cu
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 11.11.2018 : created
//-----------------------------------------------------------------------------
module aria_cu (/*AUTOARG*/
   // Outputs
   init, key_ready, enc_round, dec_round, done, ready, rkey_diff_sel, w_ready,
   wr_en, addr_last, addr_zero, lt_inv_sel, w_amount, addr,
   // Inputs
   clk, rst_n, aria_mode, run
   ) ;
   input clk;
   input rst_n;
   input [1:0] aria_mode;
   input run;
   
   output init;
   output key_ready;
   output enc_round;
   output dec_round;
   output done;
   output ready;
   output rkey_diff_sel;
   output w_ready;
   output wr_en;
   output addr_last;
   output addr_zero;
   output lt_inv_sel;
   output w_amount;
   output [4:0] addr;
   
   localparam ARIA_128 =2'b00;
   localparam ARIA_192 =2'b01;
   localparam ARIA_256 =2'b10;
   localparam IDLE = 5'b00001;
   localparam KEY_EXPAND = 5'b00010;
   localparam ENC_ROUND = 5'b00100;
   localparam DEC_ROUND = 5'b01000;
   localparam DONE = 5'b10000;
   
   reg    init;
   reg    key_ready;
   reg    enc_round;
   reg    dec_round;
   reg    done;
   reg    c_state;
   reg    n_state;
   reg    rkey_diff_sel;
   reg    wr_en;
   reg    ready;
   
   wire      addr_last;
   wire      addr_zero;
   wire      lt_inv_sel;
   wire      w_ready;
   wire [1:0] w_amount;
   wire [3:0] round_amount;
   wire       round_last;
   
   aria_counter aria_counter(/*AUTOINST*/
                             // Outputs
                             .w_amount          (w_amount[1:0]),
                             .lt_inv_sel        (lt_inv_sel),
                             .w_ready           (w_ready),
                             .addr_last         (addr_last),
                             .addr_zero         (addr_zero),
                             .addr              (addr[4:0]),
                             .round_amount      (round_amount[3:0]),
                             .round_last        (round_last),
                             // Inputs
                             .clk               (clk),
                             .rst_n             (rst_n),
                             .aria_mode         (aria_mode[1:0]));
   


   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        c_state <= IDLE;
      else
        c_state <= n_state;
   end
 
   always @ (*) begin
      init = 0;
      key_ready =0;
      dec_round = 0;
      enc_round = 0;
      done = 0;
      rkey_diff_sel = 0;
      wr_en = 0;
      
      case (c_state)
        IDLE : begin
           ready = 1;
           if(run) begin
              init = 1;
              n_state = KEY_EXPAND;
           end
        end
        KEY_EXPAND : begin
           key_ready = 1;
           n_state = KEY_EXPAND;
           if(w_ready) begin
              n_state = ENC_ROUND;
           end
        end
        ENC_ROUND : begin
           enc_round = 1;
           wr_en = 1;
           
           if(addr_last) begin
              n_state = DEC_ROUND;
           end
        end
        DEC_ROUND : begin
           dec_round =1;
           wr_en = 1;
           rkey_diff_sel = 1;
           if(addr_zero) begin
              n_state = DONE;
           end
        end
        DONE : begin
           done =1;
           n_state = IDLE;
        end
      endcase 
   end
endmodule // aria_cu

