//-----------------------------------------------------------------------------
// Title         : aria_key_extension
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_key_ex.v
// Author        :   <bonyul13@hw.myislab.com>
// Created       : 07.11.2018
// Last modified : 07.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_key_extension module
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 07.11.2018 : created
//-----------------------------------------------------------------------------
module aria_key_extension (/*AUTOARG*/
   // Outputs
   w0,w1,w2,w3,
   // Inputs
   clk, rst_n, key, lt_inv_sel,aria_mode,rkey_diff_sel,fn_final
   ) ;
   input clk;
   input rst_n;
   input [255:0] key;
   input         lt_inv_sel;
   input [1:0]   aria_mode;
   input fn_final;
   input rkey_diff_sel;
   output [127:0] w0,w1,w2,w3;

   localparam C1=128'h517cc1b727220a94fe13abe8fa9a6ee0;
   localparam C2=128'h6db14acc9e21c820ff28b1d5ef5de2b0;
   localparam C3=128'hdb92371d2126e9700324977504e8c90e;
   localparam ARIA_128 = 2'b00;
   localparam ARIA_192 = 2'b01;
   localparam ARIA_256 = 2'b10;
   
   wire [127:0] rkey_final;
   wire [127:0]   kl , kr;
   wire [127:0]   fn_blk_out;
   wire [127:0]   w_data;
   wire [127:0]   fn_blk_in;
   wire [127:0]   next_w_data;
   wire [127:0]   xor_in;
   
   reg [127:0]    w0,w1,w2,w3;
   reg [127:0]    ck1,ck2,ck3;
   reg [1:0] amount;
   
   assign kl = key[255:128];
   assign kr = key[127:0];
   assign w_data = (amount== 0)? kl : next_w_data;

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n) begin
         w0 <= 128'd0;
         w1 <= 128'd0;
         w2 <= 128'd0;
         w3 <= 128'd0;
      end
      else if (amount==0)
        w0 <= w_data;
      else if (amount==1)
        w1 <= w_data;
      else if (amount==2)
        w2 <= w_data;
      else
        w3 <= w_data;
   end // always @ (posedge clk or negedge rst_n)

   always @ (*) begin
      case(aria_mode)
        ARIA_128 : begin
           ck1=C1;
           ck2=C2;
           ck3=C3;
           end
        ARIA_192 : begin
           ck1=C2;
           ck2=C3;
           ck3=C1;
        end
        ARIA_256 : begin
           ck1=C3;
           ck2=C1;
           ck3=C2;
        end
      endcase // case (aria_mode)
   end // always @ (*)

   assign fn_blk_in = (amount==0)? ck1 :
                      (amount==1)? ck2 : ck3;

   aria_function aria_function (/*AUTOINST*/
                                // Outputs
                                .fn_blk_out     (fn_blk_out[127:0]),
                                // Inputs
                                .fn_rkey_in     (w_data[127:0]),
                                .fn_blk_in      (fn_blk_in[127:0]),
                                .lt_inv_sel     (lt_inv_sel),
                                .rkey_diff_sel  (rkey_diff_sel),
                                .rkey_final     (rkey_final),
                                .fn_final       (fn_final));

   assign xor_in = (amount==0)? kr :
                   (amount==1)? w0 :
                   (amount==2)? w1 : w2;

   assign next_w_data = xor_in^fn_blk_out;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) 
    amount <= 0;
    else if (amount!=3)
    amount <= amount + 2'd1;
end

endmodule // aria_key_extension

