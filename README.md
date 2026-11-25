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

# Firmware de ejemplo → test/firmware/hello.bin (grabar en la flash, offset 0)
make -C test/firmware
```

Más detalle: [Herramientas](https://dvillamor0.github.io/femto_UN/tools/) · [Simulación y firmware](https://dvillamor0.github.io/femto_UN/user/simulacion/) · [Prueba en hardware](https://dvillamor0.github.io/femto_UN/user/hardware/)

## Estructura

| Ruta | Contenido |
|---|---|
| `src/` | RTL del diseño |
| `macros/`, `open_ram/` | Macro SRAM del banco de registros y su configuración OpenRAM |
| `test/` | Suite de verificación y firmware |
| `config/` | Envoltorio y pines para la FPGA Colorlight i9 |
| `info.yaml` | Metadatos de Tiny Tapeout |

Pruebas: [Librería test/lib](https://dvillamor0.github.io/femto_UN/development/test-lib/) · [Cómo crear tests](https://dvillamor0.github.io/femto_UN/development/crear-tests/)

Diseño: [CPU](https://dvillamor0.github.io/femto_UN/development/cpu/) · [Bus SPI multidrop](https://dvillamor0.github.io/femto_UN/development/spi-multidrop/) · [UART](https://dvillamor0.github.io/femto_UN/development/uart/) · [FPGA](https://dvillamor0.github.io/femto_UN/development/fpga/) · [Flujo ASIC](https://dvillamor0.github.io/femto_UN/development/asic/)

## Estado

- La UART sale a 115 207 baudios con el reloj de 25 MHz (217 ciclos por bit).
- La RAM no admite accesos de byte ni media palabra.
- El banco de registros es una macro SRAM (OpenRAM) y el núcleo tiene una línea de interrupción en `ui[3]`; faltan el LEF, el GDS y el `.lib` de la macro para completar el flujo ASIC.

Detalles en [Limitaciones conocidas](https://dvillamor0.github.io/femto_UN/development/limitaciones/) y [Verificación](https://dvillamor0.github.io/femto_UN/development/verificacion/).

## Licencia y créditos

Proyecto de la Universidad Nacional de Colombia, bajo la dirección del profesor **Carlos Camargo Bareño** ([repositorio original](https://github.com/cicamargoba/femto_UN)). Licencia Apache-2.0.

Basado en [FemtoRV32](https://github.com/BrunoLevy/learn-fpga) de Bruno Levy.