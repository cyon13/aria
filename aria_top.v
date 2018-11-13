//-----------------------------------------------------------------------------
// Title         : aria_top
// Project       : ARIA 1.1
//-----------------------------------------------------------------------------
// File          : aria_top.v
// Author        :   <bonyul13@hw.myislab.com>
// Created       : 12.11.2018
// Last modified : 12.11.2018
//-----------------------------------------------------------------------------
// Description :
//  aria_top module
//-----------------------------------------------------------------------------
// Copyright (c) 2018 by ISLAB This model is the confidential and
// proprietary property of ISLAB and the possession or use of this
// file requires a written license from ISLAB.
//------------------------------------------------------------------------------
// Modification history :
// 12.11.2018 : created
//-----------------------------------------------------------------------------
module aria_top (/*AUTOARG*/
   // Outputs
   msg, ready,
   // Inputs
   clk, rst_n, aria_mode, run, key, in_msg
   ) ;
   input clk;
   input rst_n;
   input [1:0] aria_mode;
   input       run;
   input  [255:0] key;
   input [127:0]  in_msg;
   
   output [127:0] msg;
   output         ready;

   wire [127:0]   fn_blk_out;
   wire [127:0]   fn_rkey_in;
   wire [127:0]   fn_blk_in;
   wire           lt_inv_sel;
   wire           rkey_diff_sel;
   wire [127:0]   rkey_final;
   wire           addr_last;
   wire [127:0]   w0,w1,w2,w3;
   wire [127:0]   rkey;
   wire           key_ready;
   wire           w_ready;
   wire [4:0]     addr;
   wire           wr_en;
   wire           enc_round;
   wire           dec_round;
   wire           addr_last;
   wire           addr_zero;
   wire [3:0]     round_count;
   wire           round_last;
   wire           done;
   wire           init;
   wire [127:0]   key_extension_out;
   
   assign fn_blk_in = (wr_en==1)? round_out : w3;
   assign fn_rkey_in = rkey;
   
   aria_function aria_function(/*AUTOINST*/
                               // Outputs
                               .fn_blk_out      (fn_blk_out[127:0]),
                               // Inputs
                               .fn_rkey_in      (fn_rkey_in[127:0]),
                               .fn_blk_in       (fn_blk_in[127:0]),
                               .lt_inv_sel      (lt_inv_sel),
                               .rkey_diff_sel   (rkey_diff_sel),
                               .rkey_final      (rkey_final[127:0]),
                               .addr_last       (addr_last));

   aria_key_extension aria_key_extension(/*AUTOINST*/
                                         // Outputs
                                         .w0                    (w0[127:0]),
                                         .w1                    (w1[127:0]),
                                         .w2                    (w2[127:0]),
                                         .w3                    (w3[127:0]),
                                         // Inputs
                                         .clk                   (clk),
                                         .rst_n                 (rst_n),
                                         .key                   (key[255:0]),
                                         .key_ready             (key_ready),
                                         .w_ready               (w_ready),
                                         .fn_blk_out            (fn_blk_out[127:0]));
   aria_key_gen aria_key_gen(/*AUTOINST*/
                             // Outputs
                             .rkey              (rkey[127:0]),
                             .rkey_final        (rkey_final[127:0]),
                             // Inputs
                             .clk               (clk),
                             .rst_n             (rst_n),
                             .w0                (w0[127:0]),
                             .w1                (w1[127:0]),
                             .w2                (w2[127:0]),
                             .w3                (w3[127:0]),
                             .addr              (addr[4:0]),
                             .wr_en             (wr_en),
                             .aria_mode         (aria_mode[1:0]),
                             .enc_round         (enc_round),
                             .dec_round         (dec_round),
                             .addr_last         (addr_last),
                             .addr_zero         (addr_zero));
   
   aria_round aria_round(/*AUTOINST*/
                         // Outputs
                         .round_out             (round_out[127:0]),
                         // Inputs
                         .clk                   (clk),
                         .rst_n                 (rst_n),
                         .enc_round             (enc_round),
                         .dec_round             (dec_round),
                         .in_msg                (in_msg[127:0]),
                         .rkey                  (rkey[127:0]),
                         .rkey_final            (rkey_final[127:0]),
                         .round_count           (round_count[3:0]),
                         .round_last            (round_last),
                         .fn_blk_out            (fn_blk_out),
                         .done                  (done));

   aria_cu aria_cu(/*AUTOINST*/
                   // Outputs
                   .init                (init),
                   .key_ready           (key_ready),
                   .enc_round           (enc_round),
                   .dec_round           (dec_round),
                   .done                (done),
                   .ready               (ready),
                   .rkey_diff_sel       (rkey_diff_sel),
                   .w_ready             (w_ready),
                   .wr_en               (wr_en),
                   .addr_last           (addr_last),
                   .addr_zero           (addr_zero),
                   .lt_inv_sel          (lt_inv_sel),
                   .w_amount            (w_amount),
                   .addr                (addr[4:0]),
                   // Inputs
                   .clk                 (clk),
                   .rst_n               (rst_n),
                   .aria_mode           (aria_mode[1:0]),
                   .run                 (run));

   always @(posedge clk or negedge rst_n) begin
      if(!rst_n)
        msg <= 128'd0;
      else if (done);
      msg <= round_out;
   end
endmodule // aria_top

