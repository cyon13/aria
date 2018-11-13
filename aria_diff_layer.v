//-----------------------------------------------------------------------------
// Title         : aria_diff_layer
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_diff_layer.v
// Author        :  bonyul gu <bonyul13@gmail.com>
// Created       : 31.10.2018
// Last modified : 06.11.2018
//-----------------------------------------------------------------------------
// Description :
// aria_diff_layer
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 31.10.2018 : created
// 06.11.2018 : modify wires name
//---------------------------------// --------------------------------------------
`define IDX8(x) 8*((x)+1)-1:8*(x)

module aria_diff_layer (/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   din
   ) ;
   input [127:0] din;
   
   output [127:0] dout;

   wire [127:0]   x;
   wire [7:0]     diff_x0,diff_x1,diff_x2,diff_x3,diff_x4,diff_x5,diff_x6,diff_x7,diff_x8,diff_x9,diff_x10,diff_x11,diff_x12,diff_x13,diff_x14,diff_x15;
   wire [7:0]     diff_y0,diff_y1,diff_y2,diff_y3,diff_y4,diff_y5,diff_y6,diff_y7,diff_y8,diff_y9,diff_y10,diff_y11,diff_y12,diff_y13,diff_y14,diff_y15;
   wire [127:0]   dout;

   assign x = din;
   assign diff_x0 = x[`IDX8(15)];
   assign diff_x1 = x[`IDX8(14)];
   assign diff_x2 = x[`IDX8(13)];
   assign diff_x3 = x[`IDX8(12)];
   assign diff_x4 = x[`IDX8(11)];
   assign diff_x5 = x[`IDX8(10)];
   assign diff_x6 = x[`IDX8(9)];
   assign diff_x7 = x[`IDX8(8)];
   assign diff_x8 = x[`IDX8(7)];
   assign diff_x9 = x[`IDX8(6)];
   assign diff_x10 = x[`IDX8(5)];
   assign diff_x11 = x[`IDX8(4)];
   assign diff_x12 = x[`IDX8(3)];
   assign diff_x13 = x[`IDX8(2)];
   assign diff_x14 = x[`IDX8(1)];
   assign diff_x15 = x[`IDX8(0)];
   
     
   assign diff_y0 = diff_x3^diff_x4^diff_x6^diff_x8^diff_x9^diff_x13^diff_x14;
   assign diff_y1 = diff_x2^diff_x5^diff_x7^diff_x8^diff_x9^diff_x12^diff_x15;
   assign diff_y2 = diff_x1^diff_x4^diff_x6^diff_x10^diff_x11^diff_x12^diff_x15;
   assign diff_y3 = diff_x0^diff_x5^diff_x7^diff_x10^diff_x11^diff_x13^diff_x14;
   assign diff_y4 = diff_x0^diff_x2^diff_x5^diff_x8^diff_x11^diff_x14^diff_x15;
   assign diff_y5 = diff_x1^diff_x3^diff_x4^diff_x9^diff_x10^diff_x14^diff_x15;
   assign diff_y6 = diff_x0^diff_x2^diff_x7^diff_x9^diff_x10^diff_x12^diff_x13;
   assign diff_y7 = diff_x1^diff_x3^diff_x6^diff_x8^diff_x11^diff_x12^diff_x13;
   assign diff_y8 = diff_x0^diff_x1^diff_x4^diff_x7^diff_x10^diff_x13^diff_x15;
   assign diff_y9 = diff_x0^diff_x1^diff_x5^diff_x6^diff_x11^diff_x12^diff_x14;
   assign diff_y10 = diff_x2^diff_x3^diff_x5^diff_x6^diff_x8^diff_x13^diff_x15;
   assign diff_y11 = diff_x2^diff_x3^diff_x4^diff_x7^diff_x9^diff_x12^diff_x14;
   assign diff_y12 = diff_x1^diff_x2^diff_x6^diff_x7^diff_x9^diff_x11^diff_x12;
   assign diff_y13 = diff_x0^diff_x3^diff_x6^diff_x7^diff_x8^diff_x10^diff_x13;
   assign diff_y14 = diff_x0^diff_x3^diff_x4^diff_x5^diff_x9^diff_x11^diff_x14;
   assign diff_y15 = diff_x1^diff_x2^diff_x4^diff_x5^diff_x8^diff_x10^diff_x15;
   assign dout = {diff_y0,diff_y1,diff_y2,diff_y3,diff_y4,diff_y5,diff_y6,diff_y7,diff_y8,diff_y9,diff_y10,diff_y11,diff_y12,diff_y13,diff_y14,diff_y15};
endmodule // aria_diff_layer

