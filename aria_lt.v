//-----------------------------------------------------------------------------
// Title         : aria_lt
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_lt.v
// Author        :  bonyul gu <bonyul13@gmail.com>
// Created       : 02.11.2018
// Last modified : 06.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_lt
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 02.11.2018 : created
// 06.11.2018 : modify ver1
//------------------------------------------------------------------------------
module aria_lt (/*AUTOARG*/
                //Output
                lt_out,
                //Input
                lt_in,lt_inv_sel);
                
   input [31:0] lt_in;
   input        lt_inv_sel;
   
   output [31:0] lt_out;

   localparam LT_OP_NORMAL = 1'b0;
   localparam LT_OP_INV = 1'b1;


   wire [7:0]    sbox_in0,sbox_in1,sbox_in2,sbox_in3;
   wire [7:0]    sbox_out0,sbox_out1,sbox_out2,sbox_out3;
   
   assign sbox_in0 = (lt_inv_sel==LT_OP_INV)? lt_in[15:8] : lt_in[31:24];
   assign sbox_in1 = (lt_inv_sel==LT_OP_INV)? lt_in[7:0] : lt_in[23:16];
   assign sbox_in2 = (lt_inv_sel==LT_OP_INV)? lt_in[31:24] : lt_in[15:8];
   assign sbox_in3 = (lt_inv_sel==LT_OP_INV)? lt_in[23:16] : lt_in[7:0];

   aria_sbox_s1 sbox1(/*AUTOINST*/
                      .dout (sbox_out0),
                      .din (sbox_in0));

   aria_sbox_s2 sbox2(/*AUTOINST*/
                      .dout (sbox_out1),
                      .din (sbox_in1));
   aria_sbox_s1_inv sbox1_inv(/*AUTOINST*/
                      .dout (sbox_out2),
                      .din (sbox_in2));
   aria_sbox_s2_inv sbox2_inv(/*AUTOINST*/
                      .dout (sbox_out3),
                      .din (sbox_in3));


   assign lt_out = (lt_inv_sel==LT_OP_INV)? {sbox_out2,sbox_out3,sbox_out0,sbox_out1} : {sbox_out0,sbox_out1,sbox_out2,sbox_out3};
   
endmodule // aria_lt

