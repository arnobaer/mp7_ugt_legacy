// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Tue May 19 10:21:01 2020
// Host        : bergauer-X1 running 64-bit Linux Mint 19.2 Tina
// Command     : write_verilog -force -mode synth_stub -rename_top rom_lut_muon_inv_dr_sq_6 -prefix
//               rom_lut_muon_inv_dr_sq_6_ rom_lut_muon_inv_dr_sq_6_stub.v
// Design      : rom_lut_muon_inv_dr_sq_6
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx690tffg1927-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module rom_lut_muon_inv_dr_sq_6(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[11:0],douta[13:0]" */;
  input clka;
  input [11:0]addra;
  output [13:0]douta;
endmodule
