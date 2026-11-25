export PATH := $(HOME)/opt/iverilog-12/bin:$(PATH)

TT_TOOLS = tt
TT_TOOL = $(TT_TOOLS)/tt_tool.py
PDK_ROOT ?= $(HOME)/.volare
PDK ?= sky130A
IMAGE = localhost/femto-librelane:2.4.2
PROJECT_ROOT = $(CURDIR)

.PHONY: all user-config harden submission clean test version fpga-synth fpga-pnr fpga-bit fpga-bit-gl fpga-prog fpga-prog-gl fpga-flash fpga-flash-gl fpga-fw fpga-clean

all: user-config harden submission

user-config:
	podman run --rm \
		-v "$(PROJECT_ROOT):/work:Z" \
		-v "$(PDK_ROOT):/pdk:ro" \
		-e PDK_ROOT=/pdk -e PDK="$(PDK)" \
		-e HOME=/tmp/container-home \
		-w /work "$(IMAGE)" \
		python3 $(TT_TOOL) --create-user-config --no-docker

harden:
	podman run --rm \
		-v "$(PROJECT_ROOT):/work:Z" \
		-v "$(PDK_ROOT):/pdk:ro" \
		-e PDK_ROOT=/pdk -e PDK="$(PDK)" \
		-e HOME=/tmp/container-home \
		-w /work "$(IMAGE)" \
		python3 $(TT_TOOL) --harden --no-docker

submission:
	podman run --rm \
		-v "$(PROJECT_ROOT):/work:Z" \
		-v "$(PDK_ROOT):/pdk:ro" \
		-e PDK_ROOT=/pdk -e PDK="$(PDK)" \
		-e HOME=/tmp/container-home \
		-w /work "$(IMAGE)" \
		python3 $(TT_TOOL) --create-tt-submission --no-docker
	cp ./tt_submission/tt_um_femto.v .

clean: fpga-clean
	rm -rf ./runs ./tt-submission

.PHONY: test

test:
	$(MAKE) -C test $(filter-out test,$(MAKECMDGOALS))

%:
	@:

version:
	which iverilog
	iverilog -V | head -n 1
	which vvp
	vvp -V | head -n 1

# ----------------------------------------------------------------------------
# FPGA: Colorlight i9 v7.2 (Lattice ECP5 LFE5U-45F-6BG381C)
#
# Dos orígenes del diseño (mismo wrapper config/top_fpga.v, sin tocar tt_um_femto):
#   RTL        make fpga-bit      -> src/femto.v y compañia           build/fpga_rtl/
#   NETLIST    make fpga-bit-gl   -> ./tt_um_femto.v (generado por TT)  build/fpga_gl/
#
#   make fpga-prog[-gl]   carga el bitstream en SRAM (volatil, se pierde al apagar)
#   make fpga-flash[-gl]  graba el bitstream en la W25Q64 (offset 0, persistente)
#   make fpga-fw FW=x.bin graba el firmware en la W25Q64 en FW_OFFSET (0x400000)
#
# Variables:
#   FW_OFFSET=0x400000 | 0   0 => firmware en el offset 0 (el bitstream se carga solo por JTAG)
#   LED_ACTIVE_HIGH=1        el LED de L2 enciende con nivel alto (por defecto, activo en bajo)
#   NETLIST=ruta.v           netlist alterna (por defecto ./tt_um_femto.v)
#   FPGA_CABLE=<cable>       p. ej. ft232, ft2232, digilent... (por defecto el de la placa: cmsisdap)
# Herramientas: yosys, nextpnr-ecp5, ecppack (prjtrellis), openFPGALoader.
# ----------------------------------------------------------------------------
FPGA_TOP     = top_fpga
FPGA_LPF     = config/colorlight_i9.lpf
FPGA_DEVICE  = --45k --package CABGA381 --speed 6
FPGA_FREQ    = 25
# El RTL tiene un lazo combinacional (MappedSPIMultidrop <-> CPU.writeBack/aluWr): sin
# --ignore-loops nextpnr aborta el analisis de timing.
FPGA_PNR_OPT = --ignore-loops
FPGA_BOARD   = colorlight-i9
FPGA_CABLE  ?=
FPGA_LOADER  = openFPGALoader -b $(FPGA_BOARD) $(if $(FPGA_CABLE),-c $(FPGA_CABLE))

FW_OFFSET   ?= 0x400000
LED_ACTIVE_HIGH ?= 0
NETLIST     ?= tt_um_femto.v
FW          ?= test/firmware/hello.bin

FPGA_DEFS    = $(if $(filter 0 0x0 0x00000000,$(FW_OFFSET)),-DFW_AT_ZERO) \
               $(if $(filter 1,$(LED_ACTIVE_HIGH)),-DLED_ACTIVE_HIGH)

# Fuentes comunes del wrapper
FPGA_WRAP    = config/top_fpga.v config/flash_qe_init.v

# RTL: el banco de registros usa la macro OpenRAM en ASIC; en FPGA se sustituye por un modelo
# sintetizable con la misma interfaz (config/sky130_sram_32x32_1rw1r_fpga.v).
FPGA_SRC_RTL = src/femto.v src/femtorv32_quark.v src/femto_regfile_sram.v \
               config/sky130_sram_32x32_1rw1r_fpga.v src/perip_uart.v src/uart.v \
               src/MappedSPIMultidrop.v $(FPGA_WRAP)
# NETLIST: celdas sky130 (modelos funcionales generados de la propia netlist) + la macro de la
# SRAM sustituida por el modelo FPGA (si la netlist la trae como caja negra).
FPGA_SRC_GL  = $(NETLIST) config/sky130_cells_fpga.v \
               config/sky130_sram_32x32_1rw1r_fpga.v $(FPGA_WRAP)

# $(call FPGA_RULES,dir,fuentes,defines-extra,opciones-synth_ecp5)
define FPGA_RULES
$(1)/$(FPGA_TOP).json: $(2) $(MAKEFILE_LIST)
	@mkdir -p $(1)
	yosys -q -l $(1)/yosys.log \
		-p "read_verilog -sv $(FPGA_DEFS) $(3) $(2); synth_ecp5 $(4) -top $(FPGA_TOP) -json $$@"

$(1)/$(FPGA_TOP).config: $(1)/$(FPGA_TOP).json $(FPGA_LPF)
	nextpnr-ecp5 $(FPGA_DEVICE) --freq $(FPGA_FREQ) $(FPGA_PNR_OPT) \
		--json $$< --lpf $(FPGA_LPF) --textcfg $$@ --log $(1)/nextpnr.log

$(1)/$(FPGA_TOP).bit: $(1)/$(FPGA_TOP).config
	ecppack --compress $$< $$@
endef

$(eval $(call FPGA_RULES,build/fpga_rtl,$(FPGA_SRC_RTL),,))
# La netlist (puertas sky130) no cierra 25 MHz con el mapeo por defecto (21 MHz); con abc9 si (~25.7 MHz).
$(eval $(call FPGA_RULES,build/fpga_gl,$(FPGA_SRC_GL),,-abc9))

# Los modelos de celdas se regeneran si cambia la netlist
config/sky130_cells_fpga.v: $(NETLIST) tools/gen_sky130_cells.py
	python3 tools/gen_sky130_cells.py $(NETLIST) > $@

fpga-synth: build/fpga_rtl/$(FPGA_TOP).json
fpga-pnr:   build/fpga_rtl/$(FPGA_TOP).config
fpga-bit:   build/fpga_rtl/$(FPGA_TOP).bit
fpga-bit-gl: build/fpga_gl/$(FPGA_TOP).bit

fpga-prog: build/fpga_rtl/$(FPGA_TOP).bit
	$(FPGA_LOADER) $<
fpga-prog-gl: build/fpga_gl/$(FPGA_TOP).bit
	$(FPGA_LOADER) $<
fpga-flash: build/fpga_rtl/$(FPGA_TOP).bit
	$(FPGA_LOADER) -f $<
fpga-flash-gl: build/fpga_gl/$(FPGA_TOP).bit
	$(FPGA_LOADER) -f $<

# Firmware (.bin crudo) -> W25Q64 en FW_OFFSET. No toca el bitstream (esta en 0..~0.4 MB).
fpga-fw:
	@test -f "$(FW)" || { echo "No existe FW=$(FW)"; exit 1; }
	$(FPGA_LOADER) -f --file-type raw --offset $(FW_OFFSET) --verify $(FW)

fpga-clean:
	rm -rf ./build ./abc.history
