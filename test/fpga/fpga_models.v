// fpga_models.v -- modelos de simulacion para el top de la Colorlight i9
//   * USRMCLK        : primitiva del ECP5 (SCK de la flash de configuracion), la expone al tb
//   * w25q64_model   : W25Q64 minimo: 0x05/0x35 (estado), 0x06 (WE), 0x31 (WR SR2), 0x03 y 0xEB.
//                      0xEB solo entrega datos si QE=1 (igual que el chip real).
//   * spiram_model   : SPI RAM 0x03/0x02, direccion de 24 bits, un bit por linea
`timescale 1ns/1ps

module USRMCLK (input USRMCLKI, input USRMCLKTS);
endmodule

module w25q64_model #(parameter MEMFILE = "", parameter QE_INIT = 1'b0) (
    input  wire cs_n,
    input  wire sck,
    inout  wire io0, io1, io2, io3
);
    // Para que la simulacion sea rapida solo se modelan dos ventanas de 64 KiB de los 8 MiB:
    // [0x000000..0x00FFFF] (zona del bitstream) y [0x400000..0x40FFFF] (firmware).
    // Indice = {A22, A15..A0}; en MEMFILE la 2a ventana va en @10000.
    reg [7:0] mem [0:131071];
    integer k;
    initial begin
        for (k = 0; k < 131072; k = k + 1) mem[k] = 8'hFF;
        if (MEMFILE != "") $readmemh(MEMFILE, mem);
    end
    function [16:0] ix; input [23:0] a; ix = {a[22], a[15:0]}; endfunction

    reg        qe = QE_INIT, wel = 1'b0, wip = 1'b0;
    integer    qe_writes = 0;            // cuantas veces el host escribio SR2 (para el tb)
    reg [7:0]  cmd;
    reg [23:0] addr;
    reg [7:0]  sh_in;
    integer    bitn;                     // flancos de subida de SCK desde que CS# bajo
    reg [3:0]  dout;
    reg        oe_all, oe_miso;

    assign io0 = oe_all  ? dout[0] : 1'bz;
    assign io1 = (oe_all | oe_miso) ? dout[1] : 1'bz;
    assign io2 = oe_all  ? dout[2] : 1'bz;
    assign io3 = oe_all  ? dout[3] : 1'bz;

    wire [7:0] sr1 = {6'b0, wel, wip};
    wire [7:0] sr2 = {6'b0, qe, 1'b0};

    always @(negedge cs_n) begin
        bitn = 0; cmd = 0; addr = 0; sh_in = 0; oe_all <= 0; oe_miso <= 0;
    end
    always @(posedge cs_n) begin
        oe_all <= 0; oe_miso <= 0;
        if (cmd == 8'h31 && bitn == 16 && wel) begin      // Write Status Register-2 completo
            qe_writes = qe_writes + 1; wel <= 0; wip <= 1;
            qe <= sh_in[1];
            #50000 wip <= 0;                              // el chip real tarda ~10 ms
        end
    end

    // flanco de subida: el chip muestrea
    always @(posedge sck) if (!cs_n) begin
        if (bitn < 8) cmd = {cmd[6:0], io0};
        else if (cmd == 8'h31) sh_in = {sh_in[6:0], io0};
        else if (cmd == 8'hEB && bitn < 14) addr = {addr[19:0], io3, io2, io1, io0};
        else if (cmd == 8'h03 && bitn < 32) addr = {addr[22:0], io0};
        bitn = bitn + 1;
        if (bitn == 8 && cmd == 8'h06) wel <= 1;
    end

    // flanco de bajada: el chip presenta datos
    reg [7:0] b; integer j;
    always @(negedge sck) if (!cs_n) begin
        if ((cmd == 8'h05 || cmd == 8'h35) && bitn >= 8) begin
            dout[1] <= ((cmd == 8'h05) ? sr1 : sr2) >> (7 - ((bitn - 8) % 8));
            oe_miso <= 1;
        end else if (cmd == 8'h03 && bitn >= 32) begin
            j = bitn - 32; b = mem[ix(addr + j / 8)];
            dout[1] <= b >> (7 - (j % 8)); oe_miso <= 1;
        end else if (cmd == 8'hEB && bitn >= 20 && qe) begin      // sin QE=1 no hay datos
            j = bitn - 20; b = mem[ix(addr + j / 2)];
            dout <= (j % 2 == 0) ? b[7:4] : b[3:0]; oe_all <= 1;
        end
    end
endmodule

module spiram_model (input cs_n, input sck, inout io0, io1, io2, io3);
    reg [7:0] mem [0:65535];
    integer k; initial for (k = 0; k < 65536; k = k + 1) mem[k] = 8'h00;
    reg [7:0]  cmd;  reg [23:0] addr;  integer n;  reg [7:0] wbyte;  reg d1, oe1;
    assign io1 = oe1 ? d1 : 1'bz;
    always @(negedge cs_n) begin n = 0; cmd = 0; addr = 0; oe1 <= 0; end
    always @(posedge cs_n) oe1 <= 0;
    always @(posedge sck) if (!cs_n) begin
        if (n < 8)       cmd  = {cmd[6:0], io0};
        else if (n < 32) addr = {addr[22:0], io0};
        else if (cmd == 8'h02) begin
            wbyte = {wbyte[6:0], io0};
            if (((n - 32) % 8) == 7) mem[(addr + (n - 32) / 8) & 16'hFFFF] = wbyte;
        end
        n = n + 1;
    end
    always @(negedge sck) if (!cs_n && n >= 32 && cmd == 8'h03) begin
        d1 <= mem[(addr + (n - 32) / 8) & 16'hFFFF][7 - ((n - 32) % 8)]; oe1 <= 1;
    end
endmodule
