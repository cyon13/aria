//-----------------------------------------------------------------------------
// Title         : ARIA Sbox S1
// Project       : CA ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_sbox_s1.v
// Author        : Hae-young Kim  <ryoung0327@gmail.com>
// Created       : 01.11.2018
// Last modified : 01.11.2018
//-----------------------------------------------------------------------------
// Description :
//  ARIA Sbox S1 Module
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 01.11.2018 : created
//-----------------------------------------------------------------------------
module aria_sbox_s1 (/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   din
   ) ;
   input  [7:0] din;
   output [7:0] dout;

   wire [7:0]   gfinv_i, gfinv_o;

   assign gfinv_i = din;

	 aria_gfinv	GFINV(
                    .din(gfinv_i),
                    .dout(gfinv_o));

	 assign	dout[7]		=  gfinv_o[3] ^ gfinv_o[4] ^ gfinv_o[5] ^ gfinv_o[6] ^ gfinv_o[7];
	 assign	dout[6]		= ~gfinv_o[6] ^ gfinv_o[2] ^ gfinv_o[3] ^ gfinv_o[4] ^ gfinv_o[5];
	 assign	dout[5]		= ~gfinv_o[1] ^ gfinv_o[2] ^ gfinv_o[3] ^ gfinv_o[4] ^ gfinv_o[5];
	 assign	dout[4]		=  gfinv_o[0] ^ gfinv_o[1] ^ gfinv_o[2] ^ gfinv_o[3] ^ gfinv_o[4];
	 assign	dout[3]		=  gfinv_o[7] ^ gfinv_o[0] ^ gfinv_o[1] ^ gfinv_o[2] ^ gfinv_o[3];
	 assign	dout[2]		=  gfinv_o[2] ^ gfinv_o[0] ^ gfinv_o[1] ^ gfinv_o[6] ^ gfinv_o[7];
	 assign	dout[1]		= ~gfinv_o[5] ^ gfinv_o[0] ^ gfinv_o[1] ^ gfinv_o[6] ^ gfinv_o[7];
	 assign	dout[0]		= ~gfinv_o[0] ^ gfinv_o[4] ^ gfinv_o[5] ^ gfinv_o[6] ^ gfinv_o[7];

endmodule // aria_sbox_s1

