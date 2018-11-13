//-----------------------------------------------------------------------------
// Title         : aria_counter
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_counter.v
// Author        : bonyul gu  <bonyul13@gmail.com>
// Created       : 11.11.2018
// Last modified : 11.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_counter 
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 11.11.2018 : created
//-----------------------------------------------------------------------------
module aria_counter (/*AUTOARG*/
   // Outputs
   w_amount, lt_inv_sel, w_ready, addr_last, addr_zero, addr, round_amount,
   round_last,
   // Inputs
   clk, rst_n, aria_mode
   ) ;
   input clk;
   input rst_n;
   input [1:0] aria_mode;

   output [1:0] w_amount;
   output       lt_inv_sel;
   output       w_ready;
   output       addr_last;
   output       addr_zero;
   output [4:0] addr;
   output [3:0] round_amount;
   output       round_last;
   
   localparam ARIA_128 =2'b00;
   localparam ARIA_192 =2'b01;
   localparam ARIA_256 =2'b10;
   
   
   wire         addr_zero;
   wire         wr_en;
   wire         dec_round;
   wire         enc_round;
   wire         w_ready;

   reg         addr_last;
   reg   [1:0]  w_amount;
   reg          lt_inv_sel;
   reg   [4:0]  addr;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        w_amount <=2'd0;
      else if (w_amount!=3)
        w_amount <= w_amount +2'd1;
   end

   always @ (*) begin
      if(w_amount[0]==0)
        lt_inv_sel = 0;
      else if (w_amount[0]==1)
        lt_inv_sel =1;
      else if (round_amount[0]==0)
        lt_inv_sel = 0;
      else if (round_amount [0]==1)
        lv_inv_sel =1;
   end
   assign w_ready = (w_amount1>=2)? 1 : 0;
   

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
        addr <= 5'd0;
      else if (wr_en & dec_round) begin
         case (aria_mode)
           ARIA_128 : addr <= 5'b01101;
           ARIA_192 : addr <= 5'b01111;
           default : addr <= 5'b10000;
         endcase // case (aria_mode)
         if(dec_round)
           addr <= addr-5'd1;
         else
           addr <= addr;
      end
      else if (wr_en & enc_round) begin
         addr <= 5'b00000;
         if(enc_round)
           addr <= addr+5'd1;
         else
           addr <= addr;
      end
      else
        addr <= addr;
   end // always @ (posedge clk or negedge rst_n)


assign addr_zero = (addr==5'd0)? 1 : 0;

   always @(*) begin
      addr_last =5'd0;
      case (aria_mode)
        ARIA_128 : begin
           if(addr==5'b01101) begin
              addr_last = 1;
           end
        end
        ARIA_192 : begin
           if(addr==5'b01111) begin
              addr_last = 1;
           end
        end
        default : begin
           if(addr==5'b10000) begin
              addr_last = 1;
           end
        end
      endcase
   end // always @ (*)

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        round_amount <= 4'd0;
      else if (enc_round|dec_round)
        round_amount <=round_amount +1;
   end

  
   always @(*) begin
      round_last =5'd0;
      case (aria_mode)
        ARIA_128 : begin
           if(round_amount==5'b01011) begin
              round_last = 1;
           end
        end
        ARIA_192 : begin
           if(round_amount==5'b01101) begin
              round_last = 1;
           end
        end
        default : begin
           if(round_amount==5'b01111) begin
              round_last = 1;
           end
        end
      endcase
   end // always @ (*)
endmodule // aria_counter

