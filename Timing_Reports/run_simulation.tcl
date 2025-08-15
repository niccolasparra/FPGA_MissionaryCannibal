# ModelSim TCL Script for Missionaries and Cannibals Simulation
# This script automates the complete simulation process

# Clear any existing work library
if {[file exists work]} {
    vdel -lib work -all
}

# Create work library
vlib work
vmap work work

# Compile source files
echo "Compiling source files..."
echo "Compiling main module..."
vlog -reportprogress 300 -work work missionary_cannibal_complete.v
echo "Compiling testbench..."
vlog -reportprogress 300 -work work tb_missionary_cannibal_complete.v

# Check compilation status
if {[runStatus] != "ready"} {
    echo "Compilation failed! Please check error messages."
    return
}
echo "Compilation successful!"

# Start simulation
echo "Starting simulation..."
vsim -t 1ps -lib work tb_missionary_cannibal_complete

# Add waves
echo "Adding signals to wave window..."
add wave -position insertpoint sim:/tb_missionary_cannibal_complete/*

# Configure wave window
echo "Configuring wave display..."
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

# Set radix for better viewing
radix -hexadecimal /tb_missionary_cannibal_complete/state
radix -decimal /tb_missionary_cannibal_complete/missionaries_left
radix -decimal /tb_missionary_cannibal_complete/cannibals_left
radix -decimal /tb_missionary_cannibal_complete/missionaries_right
radix -decimal /tb_missionary_cannibal_complete/cannibals_right

# Run simulation
echo "Running simulation..."
run -all

# Zoom to fit
wave zoom full

# Generate report
echo "Generating simulation report..."
echo "=== SIMULATION SUMMARY ===" > simulation_report.txt
echo "Project: Missionaries and Cannibals State Machine" >> simulation_report.txt
echo "Date: [clock format [clock seconds]]" >> simulation_report.txt
echo "" >> simulation_report.txt
echo "Files Compiled:" >> simulation_report.txt
echo "- missionary_cannibal_complete.v" >> simulation_report.txt
echo "- tb_missionary_cannibal_complete.v" >> simulation_report.txt
echo "" >> simulation_report.txt
echo "Simulation completed successfully." >> simulation_report.txt
echo "Check transcript window for detailed results." >> simulation_report.txt
echo "Check wave window for timing analysis." >> simulation_report.txt

echo "Simulation completed! Check wave window and transcript for results."
echo "Report saved to simulation_report.txt"

