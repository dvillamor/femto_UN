# femto_UN

SoC RISC-V (FemtoRV32 *Quark*, RV32I) para [Tiny Tapeout](https://tinytapeout.com), sin memoria interna: ejecuta desde una flash QSPI externa, guarda datos en una RAM SPI y se comunica por UART. 4×2 tiles, sky130A, reloj nominal de 25 MHz.

📖 **Documentación: <https://dvillamor0.github.io/femto_UN/>**

## Mapa de memoria

| Rango | Destino |
|---|---|
| `0x0000_0000` – `0x0000_FFFF` | Flash QSPI (código) |
| `0x0001_0000` – `0x0001_FFFF` | RAM SPI (solo `lw`/`sw` alineados) |
| `0x0040_0000` | UART (`+0x08` datos, `+0x10` estado/control, bit 2 = LED) |

Pines y registros: [Introducción](https://dvillamor0.github.io/femto_UN/user/introduccion/).

## Inicio rápido

```bash
# Pruebas (Icarus Verilog 12 + cocotb)
pip install -r test/requirements.txt
make -C test unit

# Firmware de ejemplo → test/firmware/hello.bin (grabar en la flash: offset 0 en el ASIC, 0x400000 en la FPGA)
make -C test/firmware
```

Más detalle: [Herramientas](https://dvillamor0.github.io/femto_UN/tools/) · [Simulación y firmware](https://dvillamor0.github.io/femto_UN/user/simulacion/) · [Prueba en hardware](https://dvillamor0.github.io/femto_UN/user/hardware/)

## Probar en la FPGA Colorlight i9 v7.2 (ECP5 LFE5U-45F)

El código se ejecuta desde la **flash W25Q64 de la propia placa** (QSPI) y los datos van a una **SPI RAM externa**. El mismo envoltorio (`config/top_fpga.v`) sirve para las dos formas de sintetizar, sin modificar `tt_um_femto`:

| Origen | Comando | Salida |
|---|---|---|
| RTL (`src/femto.v` y archivos de `src/`) | `make fpga-bit` | `build/fpga_rtl/top_fpga.bit` |
| Netlist generada por Tiny Tapeout (`./tt_um_femto.v`) | `make fpga-bit-gl` | `build/fpga_gl/top_fpga.bit` |

Herramientas: `yosys`, `nextpnr-ecp5`, `ecppack` (prjtrellis) y `openFPGALoader`. En Ubuntu: `sudo apt install yosys nextpnr-ecp5 fpga-trellis openfpgaloader`.

Resultados de la compilación a 25 MHz: RTL ≈ 31–40 MHz máx.; netlist ≈ 25,7 MHz (usa `abc9`, el margen es pequeño). Si regeneras la netlist, `make` vuelve a generar `config/sky130_cells_fpga.v` (modelos de las celdas sky130 que usa).

### Conexiones

| Señal | Pin | Nota |
|---|---|---|
| `clk` | P3 | oscilador de 25 MHz |
| `rst_n` | K18 | activo en bajo, con pull-up |
| `led` | **L2** | LED de la placa; ver polaridad abajo |
| `uart_tx` / `uart_rx` | D2 / E2 | 3,3 V, hacia un adaptador USB-serie |
| Flash `CS#` | R2 | flash W25Q64 de la placa |
| Flash `IO0..IO3` | W2, V2, Y2, W1 | MOSI, MISO, WP#, HOLD# |
| Flash `SCK` | U3 (CCLK) | sin pin de usuario: sale por la primitiva `USRMCLK` |
| RAM `SCK` / `CS#` | C4 / A3 | SPI RAM externa |
| RAM `IO0..IO3` | D20, B19, A19, A18 | SI, SO, SIO2, SIO3 |

La RAM es externa y se cablea a estos pines (3,3 V, tierra común). Los pines de la flash ya vienen cableados en la placa.

**LED en L2:** por defecto se enciende con nivel bajo. Si en tu placa lo hace al revés, compila con `make fpga-bit LED_ACTIVE_HIGH=1` (y `fpga-bit-gl`). El LED sigue el bit 2 del registro de control de la UART (`0x0040_0010`) y **parpadea rápido** si no se pudo habilitar el modo Quad de la flash (ver abajo).

### Dónde vive el firmware en la flash

La flash también guarda el bitstream del FPGA desde la dirección 0 (200–260 KB comprimido), así que el firmware se coloca en **`0x400000` (4 MiB)**. El envoltorio suma ese offset al vuelo (pone a 1 el bit 22 de la dirección del comando de lectura `0xEB`), por eso funciona igual con el RTL y con la netlist. Para la CPU el firmware sigue empezando en la dirección `0`. Se enlaza igual que antes (`test/firmware`, origen `0x0`).

Si prefieres el firmware en la dirección `0` (bitstream solo por JTAG a SRAM), compila con `FW_OFFSET=0` y graba con `FW_OFFSET=0`.

### Arranque: bit QE de la flash

La lectura QSPI exige el bit QE (Quad Enable) de la W25Q64. El módulo `config/flash_qe_init.v` lo comprueba al arrancar y, si está a 0, lo pone a 1 (escritura no volátil, ocurre una sola vez en la vida de la flash) antes de soltar la CPU. Si no lo logra (flash protegida contra escritura), la CPU queda en reset y el LED parpadea rápido; ver la solución abajo.

### Paso a paso

1. **Conecta** la i9 al programador JTAG y la alimentación; conecta el USB-serie a `uart_tx`/`uart_rx` y la SPI RAM.
2. **Compila** el bitstream que quieras probar:
   ```bash
   make fpga-bit        # RTL (femto.v)
   make fpga-bit-gl     # netlist (tt_um_femto.v)
   ```
3. **Graba el firmware** en la W25Q64 (un `.bin` crudo, por ejemplo el de ejemplo):
   ```bash
   make -C test/firmware                   # genera test/firmware/hello.bin
   make fpga-fw FW=test/firmware/hello.bin # escribe en 0x400000 y verifica
   ```
   Para cualquier otro firmware: `make fpga-fw FW=ruta/mi_programa.bin`. No borra el bitstream.
4. **Carga el diseño**, de forma temporal o permanente:
   ```bash
   make fpga-prog       # RTL  → SRAM (se pierde al apagar)
   make fpga-prog-gl    # netlist → SRAM
   make fpga-flash      # RTL  → flash, offset 0 (arranca solo al encender)
   make fpga-flash-gl   # netlist → flash
   ```
5. **Abre la UART** con el baudio de la tabla de abajo (8N1) y observa la salida. Pulsa `rst_n` para reiniciar la CPU.

Notas de `openFPGALoader`: la placa se selecciona con `-b colorlight-i9` (cable por defecto `cmsisdap`). Con otro programador usa `make ... FPGA_CABLE=<cable>` (`openFPGALoader --list-cables`). Si la escritura en flash falla por protección, desbloquéala una vez con `openFPGALoader -b colorlight-i9 --unprotect-flash`.

### Baudios de la UART

El RTL de `src/` usa 115 200 baudios (217 ciclos por bit a 25 MHz). El `tt_um_femto.v` de la raíz es el resultado de una síntesis anterior y puede salir a otro valor (la nota previa del repositorio indicaba ≈130 208 baudios): si ves caracteres basura, prueba con 130 208 y regenera la netlist con `make submission` para que coincida con `src/`.

### Problemas frecuentes

| Síntoma | Causa probable |
|---|---|
| LED parpadea rápido, no hay salida | No se pudo poner QE=1 (flash protegida). Ejecuta `--unprotect-flash` y reinicia |
| Sin salida por la UART | Firmware no grabado en `0x400000` (o compilado con otro `FW_OFFSET`), baudio equivocado, RX/TX cruzados |
| LED siempre invertido | Usa `LED_ACTIVE_HIGH=1` |
| Salida en la UART pero datos de RAM mal | Revisa cableado y alimentación de la SPI RAM |

## Estructura

| Ruta | Contenido |
|---|---|
| `src/` | RTL del diseño |
| `test/` | Suite de verificación y firmware |
| `config/` | Envoltorio, pines, arranque de la flash y modelos de celdas para la FPGA Colorlight i9 |
| `tools/` | `gen_sky130_cells.py`: modelos de celdas sky130 para sintetizar la netlist en la FPGA |
| `info.yaml` | Metadatos de Tiny Tapeout |

Diseño: [Bus SPI multidrop](https://dvillamor0.github.io/femto_UN/development/spi-multidrop/) · [UART](https://dvillamor0.github.io/femto_UN/development/uart/) · [FPGA](https://dvillamor0.github.io/femto_UN/development/fpga/) · [Flujo ASIC](https://dvillamor0.github.io/femto_UN/development/asic/)

## Estado

En la FPGA el firmware vive en la flash en `0x400000` (ver sección anterior). La RAM no admite accesos de byte ni media palabra. Detalles en [Limitaciones conocidas](https://dvillamor0.github.io/femto_UN/development/limitaciones/) y [Verificación](https://dvillamor0.github.io/femto_UN/development/verificacion/).

## Licencia y créditos

Proyecto de la Universidad Nacional de Colombia, bajo la dirección del profesor **Carlos Camargo Bareño** ([repositorio original](https://github.com/cicamargoba/femto_UN)). Licencia Apache-2.0.

Basado en [FemtoRV32](https://github.com/BrunoLevy/learn-fpga) de Bruno Levy.