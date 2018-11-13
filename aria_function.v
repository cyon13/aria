//-----------------------------------------------------------------------------
// Title         : aria_function
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_function.v
// Author        :  bonyul gu <bonyul13@gmail.com>
// Created       : 31.10.2018
// Last modified : 06.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_function
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 31.10.2018 : created
// 06.11.2018 : modify ver1
//-----------------------------------------------------------------------------
module aria_function (/*AUTOARG*/
   // Outputs
   fn_blk_out,
   // Inputs
   fn_rkey_in,fn_blk_in,lt_inv_sel,rkey_diff_sel,rkey_final,addr_last
   ) ;

   input [127:0] fn_rkey_in;
   input [127:0] fn_blk_in;
   input         lt_inv_sel;
   input         rkey_diff_sel; //ENC ,DEC
   input [127:0] rkey_final;
   input         addr_last; //fn_final
   
   output [127:0] fn_blk_out;

   localparam LT_OP_NORMAL = 1'b0;
   localparam LT_OP_INV = 1'b1;
   
   localparam ENC = 1'b0;
   localparam DEC = 1'b1;

   wire [31:0]    lt_in0,lt_in1,lt_in2,lt_in3;
   wire [31:0]    lt_out0,lt_out1,lt_out2,lt_out3;
   wire [127:0]   dec_diff_in;
   wire [127:0]   dec_diff_out;
   wire [127:0]   lt_diff_in;
   wire [127:0]   lt_diff_out;
   wire [127:0]   fn_xor;
   wire [127:0]   lt_out_total;

   assign dec_diff_in =fn_rkey_in;
   
   aria_diff_layer dec_diff_layer (/*AUTOINST*/
                                   // Outputs
                                   .dout                (dec_diff_out),
                                   // Inputs
                                   .din                 (dec_diff_in));

   assign fn_xor =(rkey_diff_sel==DEC)?  dec_diff_out^fn_blk_in : fn_rkey_in^fn_blk_in;

   assign lt_in0 = fn_xor[127:96];
   assign lt_in1 = fn_xor[95:64];
   assign lt_in2 = fn_xor[63:32];
   assign lt_in3 = fn_xor[31:0];
   
   aria_lt lt_0(/*AUTOINST*/
                // Outputs
                .lt_out                 (lt_out0),
                // Inputs
                .lt_in                  (lt_in0),
                .lt_inv_sel             (lt_inv_sel));

   aria_lt lt_1(/*AUTOINST*/
                // Outputs
                .lt_out                 (lt_out1),
                // Inputs
                .lt_in                  (lt_in1),
                .lt_inv_sel             (lt_inv_sel));

   aria_lt lt_2(/*AUTOINST*/
                // Outputs
                .lt_out                 (lt_out2),
                // Inputs
                .lt_in                  (lt_in2),
                .lt_inv_sel             (lt_inv_sel));

   aria_lt lt_3(/*AUTOINST*/
                // Outputs
                .lt_out                 (lt_out3),
                // Inputs
                .lt_in                  (lt_in3),
                .lt_inv_sel             (lt_inv_sel));



   assign lt_diff_in = {lt_out0,lt_out1,lt_out2,lt_out3};

   aria_diff_layer lt_diff_layer (/*AUTOINST*/
                                  // Outputs
                                  .dout                 (lt_diff_out),
                                  // Inputs
                                  .din                  (lt_diff_in));

   assign fn_blk_out = (addr_last == 1) ? lt_diff_in^rkey_final : lt_diff_out;

endmodule // aria_function

