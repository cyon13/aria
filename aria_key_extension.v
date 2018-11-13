//-----------------------------------------------------------------------------
// Title         : aria_key_extension
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_key_extension.v
// Author        :   <bonyul13@hw.myislab.com>
// Created       : 09.11.2018
// Last modified : 09.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_key_extension 
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 09.11.2018 : created
//-----------------------------------------------------------------------------
module aria_key_extension (/*AUTOARG*/
   // Outputs
   w0, w1, w2, w3,
   // Inputs
   clk, rst_n, key, key_ready, w_ready, fn_blk_out
   ) ;
   input clk;
   input rst_n;

   input [255:0] key;
   input         key_ready;
   input         w_ready;
   input [127:0] fn_blk_out;
 
   output [127:0] w0,w1,w2,w3;

   reg [127:0]    w0,w1,w2,w3;

   
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        w0 <=128'd0;
      else if(!w_ready & key_ready)
        w0 <= w1;
   end

   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        w1 <=128'd0;
      else if(!w_ready & key_ready)
        w1 <= w2;
   end
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        w2 <=key[127:0];
      else if(!w_ready & key_ready)
        w2 <= w3;
   end
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        w3 <=key[255:128];
      else if(!w_ready & key_ready)
        w3 <= w2^fn_blk_out;
   end
 endmodule // aria_key_extension

