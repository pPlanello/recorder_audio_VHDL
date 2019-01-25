vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz" "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz" \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_sim_netlist.vhdl" \


vlog -work xil_defaultlib \
"glbl.v"

