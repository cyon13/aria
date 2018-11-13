//-----------------------------------------------------------------------------
// Title         : aria_key_gen
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_key_gen.v
// Author        :   <bonyul13@hw.myislab.com>
// Created       : 09.11.2018
// Last modified : 09.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_key_gen
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 09.11.2018 : created
//-----------------------------------------------------------------------------
module aria_key_gen (/*AUTOARG*/
   // Outputs
   rkey, rkey_final,
   // Inputs
   clk, rst_n, w0, w1, w2, w3, addr, wr_en, aria_mode, enc_round, dec_round,
   addr_last, addr_zero
   ) ;
   input clk;
   input rst_n;
   input [127:0] w0,w1,w2,w3;
   input [4:0]   addr; //f,cl,ch
   input         wr_en;
   input [1:0]   aria_mode;
   input         enc_round;
   input         dec_round;
   input         addr_last;
   input         addr_zero;

   output [127:0] rkey;
   output [127:0] rkey_final;
   
   reg [127:0]    rkey;
   reg [127:0]    rkey_final;
   
   localparam ARIA_128 = 2'b00;
   localparam ARIA_192 = 2'b01;
   localparam ARIA_256 = 2'b10;
   localparam C1 = 128'h517cc1b727220a94fe13abe8fa9a6ee0;
   localparam C2 = 128'h6db14acc9e21c820ff28b1d5ef5de2b0;
   localparam C3 = 128'hdb92371d2126e9700324977504e8c90e;
   
   assign cl1 = (addr[1:0]%4==0)? w0 :
                (addr[1:0]%4==1)? w1 :
                (addr[1:0]%4==2)? w2 : w3;

   assign cl2 = (addr[1:0]%4==0)? w1 :
                (addr[1:0]%4==1)? w2 :
                (addr[1:0]%4==2)? w3 : w0;

   assign cl2_ror19 = {cl2[18:0],cl2[127:19]};
   assign cl2_ror31 = {cl2[30:0],cl2[127:31]};
   assign cl2_ror67 = {cl2[66:0],cl2[127:67]};
   assign cl2_ror97 = {cl2[96:0],cl2[127:97]};
   assign cl2_ror109 = {cl2[108:0],cl2[127:109]};
   
   
   assign ch = (addr[3:2]%4==0)? cl2_ror19 :
               (addr[3:2]%4==1)? cl2_ror31 :
               (addr[3:2]%4==2)? cl2_ror67 : cl2_ror91;

   assign ch_final = (addr[4]==1)? cl2_ror109 : ch ;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        rkey <= 0;
      else if(wr_en & (enc_round|dec_round))
        rkey <= ch_final^cl1;
      else begin
         case (aria_mode)
            ARIA_128 : begin
               rkey <= (w_amount==0)? C1 :
                       (w_amount==1)? C2 : C3;
            end
           ARIA_192 : begin
              rkey <= (w_amount==0)? C2 :
                      (w_amount==1)? C3 : C1;
           end
           default : begin
              rkey <= (w_amount==0)? C3 :
                      (w_amount==1)? C1 :C2;
           end
         endcase // case (aria_mode)
      end
   end // always @ (posedge clk or negedge rst_n)

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        rkey_final <= 128'd0;
      else if (addr_last& end_round)
        rkey_final <= ch_final^cl1;
      else if (addr_zero & dec_round)
        rkey_final <= ch_final^cl1;
   end
   
endmodule // aria_key_gen

