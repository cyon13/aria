//-----------------------------------------------------------------------------
// Title         : ARIA Sbox S2 Inversion
// Project       : CA ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_sbox_s2_inv.v
// Author        : Hae-young Kim  <ryoung0327@gmail.com>
// Created       : 01.11.2018
// Last modified : 01.11.2018
//-----------------------------------------------------------------------------
// Description :
//  ARIA Sbox S2 Inversion Module
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 01.11.2018 : created
//-----------------------------------------------------------------------------
module aria_sbox_s2_inv (/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   din
   ) ;
   input  [7:0] din;
   output [7:0] dout;

   wire [7:0]   gfinv_i, gfinv_o;

   assign	gfinv_i[7]		=  din[7] ^ din[6] ^ din[3] ^ din[0];
	 assign	gfinv_i[6]		=  din[7] ^ din[5] ^ din[4] ^ din[3] ^ din[2] ^ din[0];
	 assign	gfinv_i[5]		= ~din[7] ^ din[6] ^ din[4] ^ din[2] ^ din[1];
	 assign	gfinv_i[4]		=  din[5] ^ din[4] ^ din[2] ^ din[1] ^ din[0];
	 assign	gfinv_i[3]		= ~din[7] ^ din[6] ^ din[2] ^ din[1] ^ din[0];
	 assign	gfinv_i[2]		= ~din[6] ^ din[4];
	 assign	gfinv_i[1]		=  din[6] ^ din[5] ^ din[2];
	 assign	gfinv_i[0]		=  din[3] ^ din[4];

	 aria_gfinv	GFINV(
                    .din(gfinv_i),
                    .dout(gfinv_o));

   assign dout = gfinv_o;

endmodule // aria_sbox_s2_inv

