create_clock -period 20.000 -name clk [get_ports clk]


#create_generated_clock -name chip/router/data_rwn -source [get_ports clk] -divide_by 1 [get_pins chip/router/data_rwn_reg/Q]
#create_generated_clock -name {chip/router/data_wben_reg_n_2_[0]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/data_wben_reg[0]/Q}]
#create_generated_clock -name {chip/router/data_wben_reg_n_2_[1]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/data_wben_reg[1]/Q}]
#create_generated_clock -name {chip/router/data_wben_reg_n_2_[2]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/data_wben_reg[2]/Q}]
#create_generated_clock -name {chip/router/data_wben_reg_n_2_[3]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/data_wben_reg[3]/Q}]
#create_generated_clock -name chip/router/favor_dmem -source [get_ports clk] -divide_by 1 [get_pins chip/router/favor_dmem_reg/Q]
#create_generated_clock -name chip/router/favor_imem -source [get_ports clk] -divide_by 1 [get_pins chip/router/favor_imem_reg/Q]
#create_generated_clock -name chip/router/favor_reg -source [get_ports clk] -divide_by 1 [get_pins chip/router/favor_reg_reg/Q]
#create_generated_clock -name chip/router/inst_rwn -source [get_ports clk] -divide_by 1 [get_pins chip/router/inst_rwn_reg/Q]
#create_generated_clock -name {chip/router/inst_wben_reg_n_2_[0]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/inst_wben_reg[0]/Q}]
#create_generated_clock -name {chip/router/inst_wben_reg_n_2_[1]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/inst_wben_reg[1]/Q}]
#create_generated_clock -name {chip/router/inst_wben_reg_n_2_[2]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/inst_wben_reg[2]/Q}]
#create_generated_clock -name {chip/router/int_dmem_htrans_reg[1]_0} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/int_dmem_htrans_reg[1]/Q}]
#create_generated_clock -name {chip/router/p_0_in0_in[0]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/int_dmem_haddr_read_reg[14]/Q}]
#create_generated_clock -name {chip/router/p_0_in0_in[1]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/int_dmem_haddr_read_reg[15]/Q}]
#create_generated_clock -name chip/router/p_0_in_0 -source [get_ports clk] -divide_by 1 [get_pins {chip/router/inst_wben_reg[3]/Q}]
#create_generated_clock -name {chip/router/p_1_in1_in[0]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/int_imem_haddr_read_reg[14]/Q}]
#create_generated_clock -name {chip/router/p_1_in1_in[1]} -source [get_ports clk] -divide_by 1 [get_pins {chip/router/int_imem_haddr_read_reg[15]/Q}]


create_generated_clock -name clk_div2 -source [get_ports clk] -divide_by 2 [get_ports clk]
