// flash_qe_init.v
// Secuencia de arranque de la flash Winbond W25Q64 de la Colorlight i9: se asegura de que el bit
// QE (Quad Enable, bit 1 del registro de estado 2) este a 1 antes de soltar la CPU. Sin QE=1 la
// flash no entrega datos por IO2/IO3 y la lectura QSPI (0xEB) de MappedSPIMultidrop falla.
//
//   1) 0x35         lee SR2.  Si QE=1 -> done (caso normal a partir del 2o arranque).
//   2) 0x06         Write Enable
//   3) 0x31 SR2|02  Write Status Register-2 (QE es NO volatil: solo se escribe una vez en la vida)
//   4) 0x05 (xN)    sondea WIP (bit 0 de SR1) hasta que baje
//   5) 0x35         verifica QE=1 -> done, si no -> fail
//
// SPI modo 0, MSB primero, un solo bit por linea (IO0 = MOSI, IO1 = MISO).  IO2/IO3 los maneja
// el top a 1 (WP#/HOLD# inactivos).  sck = clk / (4*DIV)  (DIV=4 -> 25 MHz / 16 = 1.56 MHz).
module flash_qe_init #(
    parameter DIV = 4,                  // reloj de sistema por semiperiodo de SCK (>= 1)
    parameter MAX_POLL = 65535          // sondeos de WIP antes de rendirse
)(
    input  wire clk,
    input  wire rst_n,                  // activo en bajo: reinicia la secuencia
    output reg  cs_n,
    output reg  sck,
    output wire mosi,
    input  wire miso,
    output reg  done,                   // QE=1 confirmado: se puede soltar la CPU
    output reg  fail                    // no se pudo poner QE=1 (flash protegida / ausente)
);
    localparam E_IDLE = 3'd0, E_CS = 3'd1, E_LOW = 3'd2, E_HIGH = 3'd3, E_END = 3'd4, E_GAP = 3'd5;
    localparam S_RD1 = 3'd0, S_WREN = 3'd1, S_WRSR = 3'd2, S_POLL = 3'd3, S_RD2 = 3'd4;

    reg [2:0]  eng;
    reg [2:0]  st;
    reg [15:0] txsh;
    reg [4:0]  ntx, nrx, bitcnt;
    reg [7:0]  rx, sr2;
    reg [15:0] polls;
    reg [7:0]  tcnt;

    wire tick = (tcnt == DIV - 1);
    assign mosi = txsh[15];

    always @(posedge clk) begin
        if (!rst_n) begin
            eng <= E_IDLE; st <= S_RD1; cs_n <= 1'b1; sck <= 1'b0;
            done <= 1'b0; fail <= 1'b0; tcnt <= 8'd0; bitcnt <= 5'd0;
            txsh <= 16'd0; ntx <= 5'd0; nrx <= 5'd0; rx <= 8'd0; sr2 <= 8'd0; polls <= 16'd0;
        end else begin
            tcnt <= tick ? 8'd0 : tcnt + 8'd1;
            case (eng)
            E_IDLE: if (!done && !fail) begin
                bitcnt <= 5'd0; nrx <= 5'd0; tcnt <= 8'd0;
                case (st)
                    S_RD1, S_RD2: begin txsh <= {8'h35, 8'h00};    ntx <= 5'd8;  nrx <= 5'd8; end
                    S_WREN:       begin txsh <= {8'h06, 8'h00};    ntx <= 5'd8;  end
                    S_WRSR:       begin txsh <= {8'h31, sr2 | 8'h02}; ntx <= 5'd16; end
                    default:      begin txsh <= {8'h05, 8'h00};    ntx <= 5'd8;  nrx <= 5'd8; end
                endcase
                cs_n <= 1'b0; eng <= E_CS;
            end
            E_CS:   if (tick) eng <= E_LOW;                       // CS# bajo, SCK bajo
            E_LOW:  if (tick) begin sck <= 1'b1; eng <= E_HIGH; end   // flanco de subida
            E_HIGH: if (tick) begin                                // se muestrea antes de bajar SCK
                if (bitcnt >= ntx) rx <= {rx[6:0], miso};
                sck    <= 1'b0;
                bitcnt <= bitcnt + 5'd1;
                txsh   <= {txsh[14:0], 1'b0};
                eng    <= (bitcnt + 5'd1 == ntx + nrx) ? E_END : E_LOW;
            end
            E_END:  if (tick) begin cs_n <= 1'b1; eng <= E_GAP; end
            E_GAP:  if (tick) begin
                eng <= E_IDLE;
                case (st)
                    S_RD1:  if (rx[1]) done <= 1'b1; else begin sr2 <= rx; st <= S_WREN; end
                    S_WREN: st <= S_WRSR;
                    S_WRSR: begin polls <= 16'd0; st <= S_POLL; end
                    S_POLL: if (!rx[0]) st <= S_RD2;
                            else if (polls == MAX_POLL) fail <= 1'b1;
                            else polls <= polls + 16'd1;
                    default: if (rx[1]) done <= 1'b1; else fail <= 1'b1;   // S_RD2
                endcase
            end
            default: eng <= E_IDLE;
            endcase
        end
    end
endmodule
