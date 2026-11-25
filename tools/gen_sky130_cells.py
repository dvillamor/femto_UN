#!/usr/bin/env python3
"""Genera config/sky130_cells_fpga.v: modelos funcionales sintetizables de las celdas
sky130_fd_sc_hd usadas por una netlist (p. ej. el tt_um_femto.v generado por Tiny Tapeout).

Uso:  python3 tools/gen_sky130_cells.py tt_um_femto.v > config/sky130_cells_fpga.v

Solo se emiten las celdas que aparecen en la netlist. Si falta la funcion de alguna,
el script falla (anadirla a COMB / SEQ / PHYS).
"""
import re
import sys

PWR = "inout VPWR, inout VGND, inout VPB, inout VNB"

# base -> (salida, [entradas], expresion Verilog)
COMB = {}
def c(base, out, ins, expr):
    COMB[base] = (out, ins.split(), expr)

for n in ("buf", "clkbuf", "dlygate4sd1", "dlygate4sd3", "dlymetal6s2s", "dlymetal6s4s"):
    c(n, "X", "A", "A")
for n in ("inv", "clkinv", "clkinvlp"):
    c(n, "Y", "A", "~A")
c("bufinv", "Y", "A", "~A")
c("and2", "X", "A B", "A & B");              c("and3", "X", "A B C", "A & B & C")
c("and4", "X", "A B C D", "A & B & C & D")
c("and2b", "X", "A_N B", "~A_N & B");        c("and3b", "X", "A_N B C", "~A_N & B & C")
c("and4b", "X", "A_N B C D", "~A_N & B & C & D")
c("and4bb", "X", "A_N B_N C D", "~A_N & ~B_N & C & D")
c("or2", "X", "A B", "A | B");               c("or3", "X", "A B C", "A | B | C")
c("or4", "X", "A B C D", "A | B | C | D")
c("or3b", "X", "A B C_N", "A | B | ~C_N")
c("or4b", "X", "A B C D_N", "A | B | C | ~D_N")
c("or4bb", "X", "A B C_N D_N", "A | B | ~C_N | ~D_N")
c("nand2", "Y", "A B", "~(A & B)");          c("nand3", "Y", "A B C", "~(A & B & C)")
c("nand4", "Y", "A B C D", "~(A & B & C & D)")
c("nand2b", "Y", "A_N B", "~(~A_N & B)")
c("nand3b", "Y", "A_N B C", "~(~A_N & B & C)")
c("nand4b", "Y", "A_N B C D", "~(~A_N & B & C & D)")
c("nor2", "Y", "A B", "~(A | B)");           c("nor3", "Y", "A B C", "~(A | B | C)")
c("nor4", "Y", "A B C D", "~(A | B | C | D)")
c("nor3b", "Y", "A B C_N", "~(A | B | ~C_N)")
c("nor4b", "Y", "A B C D_N", "~(A | B | C | ~D_N)")
c("xor2", "X", "A B", "A ^ B");              c("xnor2", "Y", "A B", "~(A ^ B)")
c("mux2", "X", "A0 A1 S", "S ? A1 : A0")
c("mux4", "X", "A0 A1 A2 A3 S0 S1", "S1 ? (S0 ? A3 : A2) : (S0 ? A1 : A0)")
c("a21o",   "X", "A1 A2 B1", "(A1 & A2) | B1")
c("a21oi",  "Y", "A1 A2 B1", "~((A1 & A2) | B1)")
c("a211o",  "X", "A1 A2 B1 C1", "(A1 & A2) | B1 | C1")
c("a211oi", "Y", "A1 A2 B1 C1", "~((A1 & A2) | B1 | C1)")
c("a2111o", "X", "A1 A2 B1 C1 D1", "(A1 & A2) | B1 | C1 | D1")
c("a22o",   "X", "A1 A2 B1 B2", "(A1 & A2) | (B1 & B2)")
c("a22oi",  "Y", "A1 A2 B1 B2", "~((A1 & A2) | (B1 & B2))")
c("a221o",  "X", "A1 A2 B1 B2 C1", "(A1 & A2) | (B1 & B2) | C1")
c("a31o",   "X", "A1 A2 A3 B1", "(A1 & A2 & A3) | B1")
c("a31oi",  "Y", "A1 A2 A3 B1", "~((A1 & A2 & A3) | B1)")
c("a311o",  "X", "A1 A2 A3 B1 C1", "(A1 & A2 & A3) | B1 | C1")
c("a311oi", "Y", "A1 A2 A3 B1 C1", "~((A1 & A2 & A3) | B1 | C1)")
c("a32o",   "X", "A1 A2 A3 B1 B2", "(A1 & A2 & A3) | (B1 & B2)")
c("a32oi",  "Y", "A1 A2 A3 B1 B2", "~((A1 & A2 & A3) | (B1 & B2))")
c("a41o",   "X", "A1 A2 A3 A4 B1", "(A1 & A2 & A3 & A4) | B1")
c("a41oi",  "Y", "A1 A2 A3 A4 B1", "~((A1 & A2 & A3 & A4) | B1)")
c("a21bo",  "X", "A1 A2 B1_N", "(A1 & A2) | ~B1_N")
c("a21boi", "Y", "A1 A2 B1_N", "~((A1 & A2) | ~B1_N)")
c("a2bb2o", "X", "A1_N A2_N B1 B2", "(~A1_N & ~A2_N) | (B1 & B2)")
c("a2bb2oi","Y", "A1_N A2_N B1 B2", "~((~A1_N & ~A2_N) | (B1 & B2))")
c("o21a",   "X", "A1 A2 B1", "(A1 | A2) & B1")
c("o21ai",  "Y", "A1 A2 B1", "~((A1 | A2) & B1)")
c("o211a",  "X", "A1 A2 B1 C1", "(A1 | A2) & B1 & C1")
c("o211ai", "Y", "A1 A2 B1 C1", "~((A1 | A2) & B1 & C1)")
c("o2111a", "X", "A1 A2 B1 C1 D1", "(A1 | A2) & B1 & C1 & D1")
c("o22a",   "X", "A1 A2 B1 B2", "(A1 | A2) & (B1 | B2)")
c("o22ai",  "Y", "A1 A2 B1 B2", "~((A1 | A2) & (B1 | B2))")
c("o221a",  "X", "A1 A2 B1 B2 C1", "(A1 | A2) & (B1 | B2) & C1")
c("o221ai", "Y", "A1 A2 B1 B2 C1", "~((A1 | A2) & (B1 | B2) & C1)")
c("o31a",   "X", "A1 A2 A3 B1", "(A1 | A2 | A3) & B1")
c("o311a",  "X", "A1 A2 A3 B1 C1", "(A1 | A2 | A3) & B1 & C1")
c("o311ai", "Y", "A1 A2 A3 B1 C1", "~((A1 | A2 | A3) & B1 & C1)")
c("o32a",   "X", "A1 A2 A3 B1 B2", "(A1 | A2 | A3) & (B1 | B2)")
c("o41a",   "X", "A1 A2 A3 A4 B1", "(A1 | A2 | A3 | A4) & B1")
c("o21ba",  "X", "A1 A2 B1_N", "(A1 | A2) & ~B1_N")
c("o21bai", "Y", "A1 A2 B1_N", "~((A1 | A2) & ~B1_N)")
c("o2bb2a", "X", "A1_N A2_N B1 B2", "(~A1_N | ~A2_N) & (B1 | B2)")
c("o2bb2ai","Y", "A1_N A2_N B1 B2", "~((~A1_N | ~A2_N) & (B1 | B2))")

PHYS = {"fill", "decap", "tapvpwrvgnd", "diode"}      # sin funcion logica
CONST = {"conb"}                                       # HI = 1, LO = 0
SEQ = {"dfxtp", "dlxtn"}


def base_of(cell):
    m = re.match(r"sky130_(?:fd|ef)_sc_hd__(.+?)_\d+$", cell)
    if not m:
        sys.exit(f"nombre de celda no reconocido: {cell}")
    return m.group(1)


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    text = open(sys.argv[1]).read()
    cells = sorted(set(re.findall(r"\bsky130_(?:fd|ef)_sc_hd__\w+", text)))
    out = [
        "// sky130_cells_fpga.v  --  GENERADO con tools/gen_sky130_cells.py (no editar a mano)",
        "// Modelos funcionales sintetizables de las celdas sky130_fd_sc_hd que usa la netlist",
        "// tt_um_femto.v generada por Tiny Tapeout. Solo para el flujo FPGA / simulacion de la",
        "// netlist: los pines de alimentacion existen pero no hacen nada.",
        "`timescale 1ns/1ps",
        "`default_nettype none",
        "",
    ]
    for cell in cells:
        b = base_of(cell)
        if b in COMB:
            o, ins, e = COMB[b]
            ports = ", ".join(f"input wire {i}" for i in ins)
            out += [f"module {cell}({ports}, output wire {o}, {PWR});",
                    f"  assign {o} = {e};", "endmodule", ""]
        elif b in CONST:
            out += [f"module {cell}(output wire HI, output wire LO, {PWR});",
                    "  assign HI = 1'b1;", "  assign LO = 1'b0;", "endmodule", ""]
        elif b == "dfxtp":
            out += [f"module {cell}(input wire CLK, input wire D, output reg Q, {PWR});",
                    "`ifndef SYNTHESIS", "  initial Q = 1'b0;", "`endif", "  always @(posedge CLK) Q <= D;", "endmodule", ""]
        elif b == "dlxtn":
            out += [f"module {cell}(input wire D, input wire GATE_N, output reg Q, {PWR});",
                    "`ifndef SYNTHESIS", "  initial Q = 1'b0;", "`endif", "  always @* if (!GATE_N) Q = D;", "endmodule", ""]
        elif b in PHYS:
            extra = "input wire DIODE, " if b == "diode" else ""
            out += [f"module {cell}({extra}{PWR});", "endmodule", ""]
        else:
            sys.exit(f"falta el modelo de la celda {cell} (base '{b}'): anadirlo a tools/gen_sky130_cells.py")
    out.append("`default_nettype wire")
    print("\n".join(out))
    print(f"[gen_sky130_cells] {len(cells)} celdas", file=sys.stderr)


main()
