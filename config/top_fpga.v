// top_fpga.v  --  femto_UN en la Colorlight i9 v7.2 (Lattice ECP5 LFE5U-45F)
//
// Envuelve a tt_um_femto SIN modificarlo, de modo que sirve tanto para el RTL (src/femto.v)
// como para la netlist generada por Tiny Tapeout (./tt_um_femto.v).
//
//   * Codigo : flash W25Q64 de la placa, cableada a los pines de configuracion del ECP5.
//              Su SCK solo se alcanza con la primitiva USRMCLK; CS#/IO0..IO3 son pines normales.
//   * Datos  : SPI RAM externa en cabecera (ram_*).
//   * tt_um_femto saca UN solo bus (SCK, IO0..3) con dos CS#: aqui se replica el bus hacia la flash
//     y hacia la RAM y la entrada se selecciona con el CS# de la flash.
//   * Arranque: flash_qe_init asegura QE=1 en la flash y solo despues suelta la CPU.
//   * Offset: la flash tambien guarda el bitstream del FPGA desde la direccion 0, asi que el
//     firmware vive en 0x400000.  Como la netlist no se puede tocar, se inserta el bit 22 de la
//     direccion de la lectura 0xEB "al vuelo" (la CPU solo genera direcciones < 4 MiB).
//     -DFW_AT_ZERO desactiva el offset (firmware en 0, bitstream solo por JTAG/SRAM).
//
// Defines:  FW_AT_ZERO, LED_ACTIVE_HIGH, SIM (reset corto en simulacion).

`default_nettype none

module top_fpga (
    input  wire       clk,          // oscilador de 25 MHz (P3)
    input  wire       rst_n,        // pulsador / pin de reset, activo en bajo (K18)

    input  wire       uart_rx,
    output wire       uart_tx,
    output wire       led,          // LED de la placa (pin L2): bit LED de la UART / error QE

    // Flash W25Q64 integrada (SCK por USRMCLK)
    output wire       flash_cs_n,
    inout  wire [3:0] flash_io,

    // SPI RAM externa
    output wire       ram_sck,
    output wire       ram_cs_n,
    inout  wire [3:0] ram_io
);

    // ------------------------------------------------------------------
    // Reset de arranque (~42 ms a 25 MHz) y secuencia QE de la flash
    // ------------------------------------------------------------------
`ifdef SIM
    localparam POR_BITS = 6;                     // simulacion: reset corto
`else
    localparam POR_BITS = 20;                    // 2^20 ciclos de 25 MHz = 42 ms
`endif
    reg [POR_BITS:0] por_cnt = 0;
    wire       por_done = por_cnt[POR_BITS];
    always @(posedge clk) if (!por_done) por_cnt <= por_cnt + 1'b1;

    wire init_cs_n, init_sck, init_mosi, init_done, init_fail;
    wire [3:0] flash_in;                         // lo que se lee en los pines de la flash

    flash_qe_init #(.DIV(4)) u_init (
        .clk(clk), .rst_n(por_done),
        .cs_n(init_cs_n), .sck(init_sck), .mosi(init_mosi), .miso(flash_in[1]),
        .done(init_done), .fail(init_fail)
    );

    wire cpu_rst_n = rst_n & init_done;          // la CPU no arranca hasta tener QE=1

    // ------------------------------------------------------------------
    // tt_um_femto
    // ------------------------------------------------------------------
    wire [7:0] uo_out, uio_in, uio_out, uio_oe;
    wire       soc_sck      = uo_out[0];
    wire       soc_cs_f_n   = uo_out[1];
    wire       soc_cs_r_n   = uo_out[2];

    // ui_in[2] = RXD ; ui_in[3] = IRQ (sin usar)
    wire [7:0] ui_in_w = {4'b0000, 1'b0, uart_rx, 2'b00};

    // Con la netlist de TT, tt_um_femto trae ademas los pines inout VPWR/VGND: se dejan sin
    // conectar (los modelos de celdas los ignoran), asi la instancia es la misma en RTL y netlist.
    tt_um_femto u_soc (
        .ui_in(ui_in_w), .uo_out(uo_out), .uio_in(uio_in), .uio_out(uio_out), .uio_oe(uio_oe),
        .ena(1'b1), .clk(clk), .rst_n(cpu_rst_n)
    );

    assign uart_tx = uo_out[7];

    // ------------------------------------------------------------------
    // Offset del firmware en la flash: bit 22 de la direccion del comando 0xEB
    //   Flujo del controlador: 8 ciclos de comando, luego el 1er nibble de direccion (A23..A20)
    //   se presenta tras el 8o flanco de bajada de SCK.  IO2 de ese nibble = A22.
    // ------------------------------------------------------------------
    reg       sck_prev = 1'b0;
    reg [3:0] fall_cnt = 4'd0;
    always @(posedge clk) begin
        sck_prev <= soc_sck;
        if (soc_cs_f_n)                       fall_cnt <= 4'd0;
        else if (sck_prev & ~soc_sck && fall_cnt != 4'd15) fall_cnt <= fall_cnt + 4'd1;
    end
`ifdef FW_AT_ZERO
    wire force_a22 = 1'b0;
`else
    wire force_a22 = init_done & ~soc_cs_f_n & (fall_cnt == 4'd8);
`endif

    // ------------------------------------------------------------------
    // Pines de la flash: init (antes de init_done) o SoC (despues)
    // ------------------------------------------------------------------
    wire [3:0] soc_io_o  = uio_out[3:0];
    wire [3:0] soc_io_oe = uio_oe[3:0];

    wire       f_cs_n = init_done ? soc_cs_f_n : init_cs_n;
    wire       f_sck  = init_done ? soc_sck    : init_sck;
    wire [3:0] f_o    = init_done ? (soc_io_o | {1'b0, force_a22, 2'b00})
                                  : {2'b11, 1'b0, init_mosi};     // IO2/IO3 = 1 (WP#/HOLD#)
    wire [3:0] f_oe   = init_done ? soc_io_oe : 4'b1101;          // IO1 = MISO (entrada)

    assign flash_cs_n = f_cs_n;

    // SCK de la flash: pin dedicado CCLK, solo accesible por USRMCLK (USRMCLKTS=0: salida activa)
    USRMCLK u_usrmclk (.USRMCLKI(f_sck), .USRMCLKTS(1'b0));

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : g_io
            assign flash_io[i] = f_oe[i]      ? f_o[i]       : 1'bz;
            assign flash_in[i] = flash_io[i];
            assign ram_io[i]   = soc_io_oe[i] ? soc_io_o[i]  : 1'bz;
        end
    endgenerate

    // ------------------------------------------------------------------
    // SPI RAM externa: mismo SCK / datos que la flash, su propio CS#
    // ------------------------------------------------------------------
    assign ram_sck  = soc_sck;
    assign ram_cs_n = soc_cs_r_n;

    // Entrada del SoC: la flash si su CS# esta activo; si no, la RAM
    assign uio_in = {4'b0000, soc_cs_f_n ? ram_io : flash_io};

    // ------------------------------------------------------------------
    // LED (pin L2): refleja el bit LED de la CPU; parpadeo rapido si no se pudo habilitar QE.
    // Polaridad: por defecto ACTIVO EN BAJO (LED de la placa a +3V3 por resistencia). Si en tu
    // placa se enciende al reves, compila con LED_ACTIVE_HIGH=1 (make ... LED_ACTIVE_HIGH=1).
    // ------------------------------------------------------------------
    reg [21:0] blink = 22'd0;
    always @(posedge clk) blink <= blink + 22'd1;
    wire led_on = init_fail ? blink[21] : uo_out[6];
`ifdef LED_ACTIVE_HIGH
    assign led = led_on;
`else
    assign led = ~led_on;
`endif

    wire _unused = &{1'b0, uio_oe[7:4], uio_out[7:4], uo_out[5:3]};

endmodule

`default_nettype wire
