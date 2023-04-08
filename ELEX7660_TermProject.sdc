create_clock -name {FPGA_CLK1_50} -period 20.000 [get_ports {FPGA_CLK1_50}]

set_max_skew -to [get_ports {rgb_clk rgb_cs rgb_dc rgb_din}] 10

set_false_path -from * -to [get_ports LED[*]]
set_false_path -from * -to [get_ports rgb_res]
