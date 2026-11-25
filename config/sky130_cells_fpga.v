// sky130_cells_fpga.v  --  GENERADO con tools/gen_sky130_cells.py (no editar a mano)
// Modelos funcionales sintetizables de las celdas sky130_fd_sc_hd que usa la netlist
// tt_um_femto.v generada por Tiny Tapeout. Solo para el flujo FPGA / simulacion de la
// netlist: los pines de alimentacion existen pero no hacen nada.
`timescale 1ns/1ps
`default_nettype none

module sky130_ef_sc_hd__decap_12(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__a2111o_1(input wire A1, input wire A2, input wire B1, input wire C1, input wire D1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1 | C1 | D1;
endmodule

module sky130_fd_sc_hd__a211o_1(input wire A1, input wire A2, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1 | C1;
endmodule

module sky130_fd_sc_hd__a211o_2(input wire A1, input wire A2, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1 | C1;
endmodule

module sky130_fd_sc_hd__a211o_4(input wire A1, input wire A2, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1 | C1;
endmodule

module sky130_fd_sc_hd__a211oi_1(input wire A1, input wire A2, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1 | C1);
endmodule

module sky130_fd_sc_hd__a211oi_2(input wire A1, input wire A2, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1 | C1);
endmodule

module sky130_fd_sc_hd__a211oi_4(input wire A1, input wire A2, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1 | C1);
endmodule

module sky130_fd_sc_hd__a21bo_1(input wire A1, input wire A2, input wire B1_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | ~B1_N;
endmodule

module sky130_fd_sc_hd__a21bo_2(input wire A1, input wire A2, input wire B1_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | ~B1_N;
endmodule

module sky130_fd_sc_hd__a21boi_1(input wire A1, input wire A2, input wire B1_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | ~B1_N);
endmodule

module sky130_fd_sc_hd__a21boi_2(input wire A1, input wire A2, input wire B1_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | ~B1_N);
endmodule

module sky130_fd_sc_hd__a21boi_4(input wire A1, input wire A2, input wire B1_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | ~B1_N);
endmodule

module sky130_fd_sc_hd__a21o_1(input wire A1, input wire A2, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1;
endmodule

module sky130_fd_sc_hd__a21o_4(input wire A1, input wire A2, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | B1;
endmodule

module sky130_fd_sc_hd__a21oi_1(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1);
endmodule

module sky130_fd_sc_hd__a21oi_2(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1);
endmodule

module sky130_fd_sc_hd__a21oi_4(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | B1);
endmodule

module sky130_fd_sc_hd__a221o_1(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | (B1 & B2) | C1;
endmodule

module sky130_fd_sc_hd__a221o_4(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | (B1 & B2) | C1;
endmodule

module sky130_fd_sc_hd__a22o_1(input wire A1, input wire A2, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a22o_2(input wire A1, input wire A2, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a22o_4(input wire A1, input wire A2, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a22oi_1(input wire A1, input wire A2, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

module sky130_fd_sc_hd__a22oi_2(input wire A1, input wire A2, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

module sky130_fd_sc_hd__a22oi_4(input wire A1, input wire A2, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2) | (B1 & B2));
endmodule

module sky130_fd_sc_hd__a2bb2o_1(input wire A1_N, input wire A2_N, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (~A1_N & ~A2_N) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a2bb2o_2(input wire A1_N, input wire A2_N, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (~A1_N & ~A2_N) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a311o_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2 & A3) | B1 | C1;
endmodule

module sky130_fd_sc_hd__a311oi_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3) | B1 | C1);
endmodule

module sky130_fd_sc_hd__a31o_1(input wire A1, input wire A2, input wire A3, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2 & A3) | B1;
endmodule

module sky130_fd_sc_hd__a31oi_1(input wire A1, input wire A2, input wire A3, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3) | B1);
endmodule

module sky130_fd_sc_hd__a31oi_2(input wire A1, input wire A2, input wire A3, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3) | B1);
endmodule

module sky130_fd_sc_hd__a32o_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2 & A3) | (B1 & B2);
endmodule

module sky130_fd_sc_hd__a32oi_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3) | (B1 & B2));
endmodule

module sky130_fd_sc_hd__a32oi_4(input wire A1, input wire A2, input wire A3, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3) | (B1 & B2));
endmodule

module sky130_fd_sc_hd__a41o_1(input wire A1, input wire A2, input wire A3, input wire A4, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 & A2 & A3 & A4) | B1;
endmodule

module sky130_fd_sc_hd__a41oi_1(input wire A1, input wire A2, input wire A3, input wire A4, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 & A2 & A3 & A4) | B1);
endmodule

module sky130_fd_sc_hd__and2_1(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B;
endmodule

module sky130_fd_sc_hd__and2_2(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B;
endmodule

module sky130_fd_sc_hd__and2_4(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B;
endmodule

module sky130_fd_sc_hd__and2b_1(input wire A_N, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B;
endmodule

module sky130_fd_sc_hd__and2b_2(input wire A_N, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B;
endmodule

module sky130_fd_sc_hd__and3_1(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B & C;
endmodule

module sky130_fd_sc_hd__and3_2(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B & C;
endmodule

module sky130_fd_sc_hd__and3_4(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B & C;
endmodule

module sky130_fd_sc_hd__and3b_1(input wire A_N, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B & C;
endmodule

module sky130_fd_sc_hd__and3b_2(input wire A_N, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B & C;
endmodule

module sky130_fd_sc_hd__and3b_4(input wire A_N, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B & C;
endmodule

module sky130_fd_sc_hd__and4_1(input wire A, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A & B & C & D;
endmodule

module sky130_fd_sc_hd__and4b_1(input wire A_N, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B & C & D;
endmodule

module sky130_fd_sc_hd__and4b_2(input wire A_N, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & B & C & D;
endmodule

module sky130_fd_sc_hd__and4bb_1(input wire A_N, input wire B_N, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = ~A_N & ~B_N & C & D;
endmodule

module sky130_fd_sc_hd__buf_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__buf_12(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__buf_2(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__buf_4(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__buf_6(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__buf_8(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__bufinv_8(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__clkbuf_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__clkbuf_16(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__clkbuf_2(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__clkbuf_4(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__clkbuf_8(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__clkinv_16(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__clkinv_2(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__clkinv_8(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__clkinvlp_4(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__conb_1(output wire HI, output wire LO, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign HI = 1'b1;
  assign LO = 1'b0;
endmodule

module sky130_fd_sc_hd__decap_3(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__decap_4(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__decap_6(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__decap_8(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__dfxtp_1(input wire CLK, input wire D, output reg Q, inout VPWR, inout VGND, inout VPB, inout VNB);
`ifndef SYNTHESIS
  initial Q = 1'b0;
`endif
  always @(posedge CLK) Q <= D;
endmodule

module sky130_fd_sc_hd__dfxtp_2(input wire CLK, input wire D, output reg Q, inout VPWR, inout VGND, inout VPB, inout VNB);
`ifndef SYNTHESIS
  initial Q = 1'b0;
`endif
  always @(posedge CLK) Q <= D;
endmodule

module sky130_fd_sc_hd__dfxtp_4(input wire CLK, input wire D, output reg Q, inout VPWR, inout VGND, inout VPB, inout VNB);
`ifndef SYNTHESIS
  initial Q = 1'b0;
`endif
  always @(posedge CLK) Q <= D;
endmodule

module sky130_fd_sc_hd__diode_2(input wire DIODE, inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__dlxtn_1(input wire D, input wire GATE_N, output reg Q, inout VPWR, inout VGND, inout VPB, inout VNB);
`ifndef SYNTHESIS
  initial Q = 1'b0;
`endif
  always @* if (!GATE_N) Q = D;
endmodule

module sky130_fd_sc_hd__dlygate4sd1_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__dlygate4sd3_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__dlymetal6s2s_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__dlymetal6s4s_1(input wire A, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A;
endmodule

module sky130_fd_sc_hd__fill_1(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__fill_2(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__inv_12(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__inv_16(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__inv_2(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__inv_4(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__inv_6(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__inv_8(input wire A, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~A;
endmodule

module sky130_fd_sc_hd__mux2_1(input wire A0, input wire A1, input wire S, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = S ? A1 : A0;
endmodule

module sky130_fd_sc_hd__mux2_2(input wire A0, input wire A1, input wire S, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = S ? A1 : A0;
endmodule

module sky130_fd_sc_hd__mux2_4(input wire A0, input wire A1, input wire S, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = S ? A1 : A0;
endmodule

module sky130_fd_sc_hd__mux4_2(input wire A0, input wire A1, input wire A2, input wire A3, input wire S0, input wire S1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = S1 ? (S0 ? A3 : A2) : (S0 ? A1 : A0);
endmodule

module sky130_fd_sc_hd__nand2_1(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B);
endmodule

module sky130_fd_sc_hd__nand2_2(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B);
endmodule

module sky130_fd_sc_hd__nand2_4(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B);
endmodule

module sky130_fd_sc_hd__nand2b_1(input wire A_N, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(~A_N & B);
endmodule

module sky130_fd_sc_hd__nand2b_2(input wire A_N, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(~A_N & B);
endmodule

module sky130_fd_sc_hd__nand2b_4(input wire A_N, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(~A_N & B);
endmodule

module sky130_fd_sc_hd__nand3_1(input wire A, input wire B, input wire C, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B & C);
endmodule

module sky130_fd_sc_hd__nand3_4(input wire A, input wire B, input wire C, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B & C);
endmodule

module sky130_fd_sc_hd__nand4_1(input wire A, input wire B, input wire C, input wire D, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A & B & C & D);
endmodule

module sky130_fd_sc_hd__nand4b_4(input wire A_N, input wire B, input wire C, input wire D, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(~A_N & B & C & D);
endmodule

module sky130_fd_sc_hd__nor2_1(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B);
endmodule

module sky130_fd_sc_hd__nor2_2(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B);
endmodule

module sky130_fd_sc_hd__nor2_4(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B);
endmodule

module sky130_fd_sc_hd__nor2_8(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B);
endmodule

module sky130_fd_sc_hd__nor3_1(input wire A, input wire B, input wire C, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | C);
endmodule

module sky130_fd_sc_hd__nor3_2(input wire A, input wire B, input wire C, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | C);
endmodule

module sky130_fd_sc_hd__nor3b_1(input wire A, input wire B, input wire C_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | ~C_N);
endmodule

module sky130_fd_sc_hd__nor4_1(input wire A, input wire B, input wire C, input wire D, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | C | D);
endmodule

module sky130_fd_sc_hd__nor4b_2(input wire A, input wire B, input wire C, input wire D_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | C | ~D_N);
endmodule

module sky130_fd_sc_hd__nor4b_4(input wire A, input wire B, input wire C, input wire D_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A | B | C | ~D_N);
endmodule

module sky130_fd_sc_hd__o2111a_1(input wire A1, input wire A2, input wire B1, input wire C1, input wire D1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & B1 & C1 & D1;
endmodule

module sky130_fd_sc_hd__o211a_1(input wire A1, input wire A2, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & B1 & C1;
endmodule

module sky130_fd_sc_hd__o211ai_1(input wire A1, input wire A2, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & B1 & C1);
endmodule

module sky130_fd_sc_hd__o211ai_4(input wire A1, input wire A2, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & B1 & C1);
endmodule

module sky130_fd_sc_hd__o21a_1(input wire A1, input wire A2, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & B1;
endmodule

module sky130_fd_sc_hd__o21a_2(input wire A1, input wire A2, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & B1;
endmodule

module sky130_fd_sc_hd__o21a_4(input wire A1, input wire A2, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & B1;
endmodule

module sky130_fd_sc_hd__o21ai_1(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & B1);
endmodule

module sky130_fd_sc_hd__o21ai_2(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & B1);
endmodule

module sky130_fd_sc_hd__o21ai_4(input wire A1, input wire A2, input wire B1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & B1);
endmodule

module sky130_fd_sc_hd__o21ba_1(input wire A1, input wire A2, input wire B1_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & ~B1_N;
endmodule

module sky130_fd_sc_hd__o21ba_4(input wire A1, input wire A2, input wire B1_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & ~B1_N;
endmodule

module sky130_fd_sc_hd__o21bai_1(input wire A1, input wire A2, input wire B1_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & ~B1_N);
endmodule

module sky130_fd_sc_hd__o21bai_4(input wire A1, input wire A2, input wire B1_N, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & ~B1_N);
endmodule

module sky130_fd_sc_hd__o221a_1(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & (B1 | B2) & C1;
endmodule

module sky130_fd_sc_hd__o221a_4(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & (B1 | B2) & C1;
endmodule

module sky130_fd_sc_hd__o221ai_1(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & (B1 | B2) & C1);
endmodule

module sky130_fd_sc_hd__o221ai_4(input wire A1, input wire A2, input wire B1, input wire B2, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & (B1 | B2) & C1);
endmodule

module sky130_fd_sc_hd__o22a_1(input wire A1, input wire A2, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2) & (B1 | B2);
endmodule

module sky130_fd_sc_hd__o22ai_1(input wire A1, input wire A2, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2) & (B1 | B2));
endmodule

module sky130_fd_sc_hd__o2bb2a_1(input wire A1_N, input wire A2_N, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (~A1_N | ~A2_N) & (B1 | B2);
endmodule

module sky130_fd_sc_hd__o2bb2ai_1(input wire A1_N, input wire A2_N, input wire B1, input wire B2, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((~A1_N | ~A2_N) & (B1 | B2));
endmodule

module sky130_fd_sc_hd__o311a_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & B1 & C1;
endmodule

module sky130_fd_sc_hd__o311a_4(input wire A1, input wire A2, input wire A3, input wire B1, input wire C1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & B1 & C1;
endmodule

module sky130_fd_sc_hd__o311ai_4(input wire A1, input wire A2, input wire A3, input wire B1, input wire C1, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~((A1 | A2 | A3) & B1 & C1);
endmodule

module sky130_fd_sc_hd__o31a_1(input wire A1, input wire A2, input wire A3, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & B1;
endmodule

module sky130_fd_sc_hd__o31a_4(input wire A1, input wire A2, input wire A3, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & B1;
endmodule

module sky130_fd_sc_hd__o32a_1(input wire A1, input wire A2, input wire A3, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & (B1 | B2);
endmodule

module sky130_fd_sc_hd__o32a_4(input wire A1, input wire A2, input wire A3, input wire B1, input wire B2, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3) & (B1 | B2);
endmodule

module sky130_fd_sc_hd__o41a_1(input wire A1, input wire A2, input wire A3, input wire A4, input wire B1, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = (A1 | A2 | A3 | A4) & B1;
endmodule

module sky130_fd_sc_hd__or2_1(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B;
endmodule

module sky130_fd_sc_hd__or2_2(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B;
endmodule

module sky130_fd_sc_hd__or2_4(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B;
endmodule

module sky130_fd_sc_hd__or3_1(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C;
endmodule

module sky130_fd_sc_hd__or3_2(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C;
endmodule

module sky130_fd_sc_hd__or3_4(input wire A, input wire B, input wire C, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C;
endmodule

module sky130_fd_sc_hd__or3b_1(input wire A, input wire B, input wire C_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | ~C_N;
endmodule

module sky130_fd_sc_hd__or3b_2(input wire A, input wire B, input wire C_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | ~C_N;
endmodule

module sky130_fd_sc_hd__or3b_4(input wire A, input wire B, input wire C_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | ~C_N;
endmodule

module sky130_fd_sc_hd__or4_1(input wire A, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | D;
endmodule

module sky130_fd_sc_hd__or4_2(input wire A, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | D;
endmodule

module sky130_fd_sc_hd__or4_4(input wire A, input wire B, input wire C, input wire D, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | D;
endmodule

module sky130_fd_sc_hd__or4b_1(input wire A, input wire B, input wire C, input wire D_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | ~D_N;
endmodule

module sky130_fd_sc_hd__or4b_2(input wire A, input wire B, input wire C, input wire D_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | ~D_N;
endmodule

module sky130_fd_sc_hd__or4b_4(input wire A, input wire B, input wire C, input wire D_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | C | ~D_N;
endmodule

module sky130_fd_sc_hd__or4bb_1(input wire A, input wire B, input wire C_N, input wire D_N, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A | B | ~C_N | ~D_N;
endmodule

module sky130_fd_sc_hd__tapvpwrvgnd_1(inout VPWR, inout VGND, inout VPB, inout VNB);
endmodule

module sky130_fd_sc_hd__xnor2_1(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A ^ B);
endmodule

module sky130_fd_sc_hd__xnor2_2(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A ^ B);
endmodule

module sky130_fd_sc_hd__xnor2_4(input wire A, input wire B, output wire Y, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign Y = ~(A ^ B);
endmodule

module sky130_fd_sc_hd__xor2_1(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A ^ B;
endmodule

module sky130_fd_sc_hd__xor2_2(input wire A, input wire B, output wire X, inout VPWR, inout VGND, inout VPB, inout VNB);
  assign X = A ^ B;
endmodule

`default_nettype wire
