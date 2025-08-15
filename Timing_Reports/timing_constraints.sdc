# Timing Constraints for Missionaries and Cannibals State Machine
# SDC (Synopsys Design Constraints) file

# Create clock constraint
# 100MHz clock (10ns period)
create_clock -name clk -period 10.0 [get_ports {clk}]

# Set clock uncertainty (accounts for jitter and skew)
set_clock_uncertainty -setup -to [get_clocks clk] 0.2
set_clock_uncertainty -hold -to [get_clocks clk] 0.1

# Input delay constraints
# Assume inputs arrive 2ns after clock edge
set_input_delay -clock clk -max 2.0 [get_ports {reset start}]
set_input_delay -clock clk -min -0.5 [get_ports {reset start}]

# Output delay constraints
# Outputs must be stable 1ns before next clock edge
set_output_delay -clock clk -max 1.0 [get_ports {state missionaries_left cannibals_left missionaries_right cannibals_right boat_side solution_complete valid_state}]
set_output_delay -clock clk -min -0.5 [get_ports {state missionaries_left cannibals_left missionaries_right cannibals_right boat_side solution_complete valid_state}]

# Drive strength for inputs (assumes 4mA drive)
set_driving_cell -lib_cell [get_lib_cells */BUF_X1] [get_ports {reset start}]

# Load capacitance for outputs (assumes 10pF load)
set_load 0.01 [get_ports {state missionaries_left cannibals_left missionaries_right cannibals_right boat_side solution_complete valid_state}]

# Timing exceptions
# Reset is asynchronous, so ignore timing on reset paths
set_false_path -from [get_ports reset] -to [get_registers *]

# Multicycle paths (if any state transitions take multiple cycles)
# set_multicycle_path -setup -from [get_registers *] -to [get_registers *] 2
# set_multicycle_path -hold -from [get_registers *] -to [get_registers *] 1

# Maximum transition time constraint
set_max_transition 0.5 [current_design]

# Maximum fanout constraint
set_max_fanout 20 [current_design]

