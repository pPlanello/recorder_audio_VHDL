vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz" "+incdir+../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz" \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../dsed_audio.srcs/sources_1/ip/clk_12Mhz/clk_12Mhz_sim_netlist.vhdl" \


vlog -work xil_defaultlib \
"glbl.v"

