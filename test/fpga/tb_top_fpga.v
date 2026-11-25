// tb_top_fpga.v -- simula top_fpga (Colorlight i9) con la flash W25Q64 (QE=0 de fabrica) y una
// SPI RAM.  Comprueba: (1) que flash_qe_init pone QE=1, (2) que el firmware se lee del offset
// 0x400000 (o 0 con -DFW_AT_ZERO) y (3) que la UART saca el texto esperado.
//   iverilog -g2005 -DSIM [-DGATE_LEVEL] [-DFW_AT_ZERO] ... ; vvp a.out +fw=<hex> +expect=<texto>
`timescale 1ns/1ps
module tb_top_fpga;
    reg clk = 0;
    always #20 clk = ~clk;                       // 25 MHz
    reg rst_n = 1;

    wire uart_tx, led, flash_cs_n, ram_sck, ram_cs_n;
    wire [3:0] flash_io, ram_io;
    pullup (flash_io[0]); pullup (flash_io[1]); pullup (flash_io[2]); pullup (flash_io[3]);
    pullup (ram_io[0]);   pullup (ram_io[1]);   pullup (ram_io[2]);   pullup (ram_io[3]);

    top_fpga dut (
        .clk(clk), .rst_n(rst_n), .uart_rx(1'b1), .uart_tx(uart_tx), .led(led),
        .flash_cs_n(flash_cs_n), .flash_io(flash_io),
        .ram_sck(ram_sck), .ram_cs_n(ram_cs_n), .ram_io(ram_io)
    );

    // SCK de la flash = lo que entra a USRMCLK
    wire flash_sck = dut.u_usrmclk.USRMCLKI;

    w25q64_model #(.MEMFILE("flash_image.hex"), .QE_INIT(1'b0)) flash (
        .cs_n(flash_cs_n), .sck(flash_sck),
        .io0(flash_io[0]), .io1(flash_io[1]), .io2(flash_io[2]), .io3(flash_io[3]));
    spiram_model ram (.cs_n(ram_cs_n), .sck(ram_sck),
        .io0(ram_io[0]), .io1(ram_io[1]), .io2(ram_io[2]), .io3(ram_io[3]));

    // ---- receptor UART (baud real del diseno: 115207 -> 217 ciclos de reloj por bit) ----
    localparam integer BIT_NS = 217 * 40;
    reg [7:0]    rxb;
    integer      n;
    reg [1023:0] got = 0;                       // ultimos 128 caracteres recibidos
    integer      ngot = 0;

    // textos esperados (+e0=... +e1=...): cada uno debe aparecer en la salida de la UART
    reg [1023:0] e [0:1];
    integer      elen [0:1];
    reg          seen [0:1];
    integer      q;

    task automatic scan;
        integer k;
        reg [1023:0] mask;
        begin
            for (k = 0; k < 2; k = k + 1)
                if (elen[k] > 0) begin
                    mask = (1024'd1 << (8 * elen[k])) - 1;
                    if ((got & mask) === e[k]) seen[k] = 1;
                end
        end
    endtask

    always begin
        @(negedge uart_tx);
        #(BIT_NS / 2);
        rxb = 0;
        for (n = 0; n < 8; n = n + 1) begin #(BIT_NS); rxb[n] = uart_tx; end
        #(BIT_NS);
        got = {got[1015:0], rxb}; ngot = ngot + 1;
        $write("%c", rxb); $fflush();
        scan;
    end

    function integer slen;
        input [1023:0] v;
        integer i;
        begin slen = 0; for (i = 0; i < 128; i = i + 1) if (v[8*i +: 8] != 0) slen = i + 1; end
    endfunction

    integer waited;
    reg [1023:0] tmp;
    initial begin
        for (q = 0; q < 2; q = q + 1) begin e[q] = 0; elen[q] = 0; seen[q] = 0; end
        if ($value$plusargs("e0=%s", tmp)) begin e[0] = tmp; elen[0] = slen(tmp); end
        if ($value$plusargs("e1=%s", tmp)) begin e[1] = tmp; elen[1] = slen(tmp); end
        $display("[tb] esperando en la UART: '%0s' '%0s'", e[0], e[1]);

        wait (dut.init_done === 1'b1);
        $display("[tb] %0t ns: init_done  QE=%b  escrituras de SR2=%0d  fail=%b",
                 $time, flash.qe, flash.qe_writes, dut.init_fail);
        waited = 0;
        while (waited < 20000 && !((elen[0] == 0 || seen[0]) && (elen[1] == 0 || seen[1]))) begin
            #(1000 * 40); waited = waited + 1;      // pasos de 1000 ciclos de reloj
        end
        if (((elen[0] == 0 || seen[0]) && (elen[1] == 0 || seen[1])) && flash.qe && flash.qe_writes == 1)
            $display("\n[tb] PASS  (QE escrito %0d vez, texto recibido)", flash.qe_writes);
        else
            $display("\n[tb] FAIL  (seen0=%b seen1=%b qe=%b qe_writes=%0d bytes=%0d)",
                     seen[0], seen[1], flash.qe, flash.qe_writes, ngot);
        $finish;
    end
endmodule
