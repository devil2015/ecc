TOPLEVEL = Fifo_Core_module

PWD = $(shell pwd)
COCOTB = ~/gitlab/cocotb
SRC = $(PWD)/../../hdl/multipliers

VERILOG_SOURCES = $(SRC)/DMA_module.v $(SRC)/Fifo_512.v $(SRC)/Fifo_Input_256.v $(SRC)/Fifo_command.v $(SRC)/Core1.v $(SRC)/Core2_implementation.v $(SRC)/LOOK_UP_table_module.v $(SRC)/Masking_Module.v $(SRC)/mul_128_module.v $(SRC)/Square_module.v $(SRC)/Xor_256_module.v $(SRC)/Xor_16_bit.v $(SRC)/LUT.v 
MODULE=test_ks #cocotb,test_discovery,test_external,test_regression

SIM_ARGS=-vcd

include $(COCOTB)/makefiles/Makefile.inc
include $(COCOTB)/makefiles/Makefile.sim