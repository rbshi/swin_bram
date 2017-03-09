COMPILED_LIB = /home/rbshi/Documents/ise_lib
XILINX_PATH = /data/tools/Xilinx/14.7/ISE_DS/ISE
XILINX_FLAG = -Mupdate -Mlib=$(COMPILED_LIB)/unisims_ver -y $(XILINX_PATH)/verilog/src/unisims \
	      -Mlib=$(COMPILED_LIB)/xilinxcorelib_ver +incdir+$(XILINX_PATH)/verilog/src \
	      +libext+.v $(XILINX_PATH)/verilog/src/glbl.v

all:    clean comp run

clean:
	\rm -rf simv* csrc* *.log *.key vcdplus.vpd
comp:
	vcs $(XILINX_FLAG) +lint=PCWM -PP -f filelist -debug_all -l compile.log


vcs run:
	./simv -l run.log
