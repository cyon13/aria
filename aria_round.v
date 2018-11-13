//-----------------------------------------------------------------------------
// Title         : aria_round
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_round.v
// Author        : bonyul gu  <bonyul13@gmail.com>
// Created       : 12.11.2018
// Last modified : 12.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_round(enc,dec) process
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 12.11.2018 : created
//-----------------------------------------------------------------------------
module aria_round (/*AUTOARG*/ ) ;
   input clk;
   input rst_n;
   input enc_round;
   input dec_round;
   input [127:0] in_msg;
   input [127:0] rkey;
   input [127:0] rkey_final;
   input [3:0] round_count;
   input       round_last;
   input       fn_blk_out;
 
   input       done;
   
   output [127:0] round_out;

   wire [127:0] round_in;
   wire [127:0] fn_blk_in;
   
   
   reg [127:0]    round_out;

   assign round_in = (round_count==0)? in_msg : round_out
   
   always @ (posedge clk or negedge rst_n) begin
      if(!rst_n)
        round_out <= 128'd0;
      else if (enc_round | dec_round)
        round_out <= fn_blk_out;
   end

endmodule
