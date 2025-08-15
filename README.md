# Missionaries and Cannibals Digital Logic Implementation

## Project Overview

This project implements the classic Missionaries and Cannibals problem as a digital finite state machine using T flip-flops. The design demonstrates both combinational and sequential logic design principles through a systematic approach including truth tables, K-maps, and HDL implementation.

## Project Structure

```
Final_Project/
├── HDL_Code/
│   ├── missionary_cannibal_complete.v     # Main module implementation
│   ├── tb_missionary_cannibal_complete.v  # Comprehensive testbench
│   └── missionary_sim                     # Compiled simulation executable
├── Analysis_Scripts/
│   ├── logic_analysis.py                  # Truth table generation
│   ├── generate_kmaps.py                  # K-map analysis for T flip-flops
│   ├── kmap_minimization.py               # Boolean function minimization
│   └── boolean_minimizer.py               # Advanced optimization tools
├── Simulation_Results/
│   ├── final_simulation_output.txt        # Complete simulation log
│   ├── missionary_cannibal_simulation.vcd # VCD waveform files
│   └── complete_system.vcd
├── Timing_Reports/
│   ├── timing_constraints.sdc             # Timing constraints
│   ├── run_simulation.tcl                 # TCL simulation script
│   └── generate_report.tcl                # Report generation script
├── Documentation/
│   ├── missionary_cannibal_report.tex     # Complete LaTeX report
│   └── missionary_cannibal_report.pdf     # Generated PDF report
└── README.md                              # This file
```

## Problem Description

The Missionaries and Cannibals problem requires transporting 3 missionaries and 3 cannibals across a river with the following constraints:
- The boat can carry at most 2 people
- Cannibals cannot outnumber missionaries on either side (when missionaries are present)
- The boat must be operated by at least one person

## Implementation Details

### State Machine Design
- **13 valid states** (0000 to 1100) representing the solution sequence
- **T flip-flop implementation** for state memory (4 bits)
- **Moore machine architecture** with combinational output logic
- **Invalid state handling** for robustness

### Key Features
- Automatic progression through optimal 12-step solution
- Invalid state detection and handling (states 1101, 1110, 1111)
- Comprehensive verification testbench
- Performance timing analysis
- Educational demonstration of T flip-flop usage

## Running the Simulation

### Prerequisites
- Icarus Verilog (iverilog) for HDL simulation
- GTKWave for waveform viewing
- Python 3.x for analysis scripts
- LaTeX distribution for report compilation

### Simulation Steps

1. **Compile and Run Simulation:**
   ```bash
   cd Final_Project/HDL_Code/
   iverilog -o missionary_sim tb_missionary_cannibal_complete.v missionary_cannibal_complete.v
   ./missionary_sim
   ```

2. **View Waveforms:**
   ```bash
   gtkwave missionary_cannibal_simulation.vcd
   ```

3. **Run Analysis Scripts:**
   ```bash
   cd ../Analysis_Scripts/
   python3 logic_analysis.py
   python3 generate_kmaps.py
   ```

4. **Compile Report:**
   ```bash
   cd ../Documentation/
   pdflatex missionary_cannibal_report.tex
   pdflatex missionary_cannibal_report.tex  # Run twice for references
   ```

## Simulation Results

The simulation demonstrates:
- **✓ Successful state progression** through all 12 solution steps
- **✓ Proper invalid state handling** with valid_state = 0
- **✓ Correct output mappings** for all missionaries/cannibals positions
- **✓ Reset functionality** working correctly
- **✓ Timing performance** of 13 clock cycles total execution

### Key Metrics
- **Clock Period:** 10ns (100MHz simulation)
- **Execution Time:** 125ns from start to completion
- **State Transitions:** 12 solution steps + 1 start cycle
- **Latency:** 1 clock cycle per state transition

## Educational Value

This project demonstrates:
1. **Combinational Logic Design:** Truth tables, K-maps, Boolean minimization
2. **Sequential Logic Design:** T flip-flop implementation and state machines
3. **HDL Programming:** Professional Verilog coding practices
4. **Design Verification:** Comprehensive testbench development
5. **Documentation:** Complete technical report with LaTeX

## File Descriptions

### HDL Code
- `missionary_cannibal_complete.v`: Main state machine with T flip-flops
- `tb_missionary_cannibal_complete.v`: Testbench with comprehensive verification

### Analysis Scripts
- `logic_analysis.py`: Generates truth tables for the original combinational logic
- `generate_kmaps.py`: Creates K-maps for T flip-flop inputs
- `kmap_minimization.py`: Boolean function optimization
- `boolean_minimizer.py`: Advanced minimization techniques

### Documentation
- `missionary_cannibal_report.tex`: Complete technical report covering:
  - Problem description and motivation
  - Combinational logic design with truth tables and K-maps
  - Sequential logic design with T flip-flops
  - Justification for T flip-flop selection
  - Module descriptions and architecture
  - Complete HDL code with comments
  - Simulation results and analysis
  - Conclusions and references

## Design Highlights

### T Flip-Flop Implementation
The design uses T flip-flops for educational reasons:
- Natural fit for binary counter progression
- Clear demonstration of toggle behavior
- Minimal control logic for sequential patterns
- Educational value in understanding flip-flop types

### Invalid State Handling
The design explicitly handles invalid states (1101, 1110, 1111):
- Sets `valid_state = 0` for invalid combinations
- Zeros all outputs for safety
- Demonstrates defensive programming practices

### Comprehensive Verification
The testbench includes:
- Invalid state injection and testing
- Complete solution sequence verification
- Reset functionality testing
- Timing analysis and performance metrics
- Safety constraint checking

## Future Enhancements

- **Parameterizable Design:** Support for N missionaries and N cannibals
- **Multiple Solutions:** Implementation of alternative solution paths
- **Interactive Mode:** User-controlled step-through capability
- **FPGA Implementation:** Hardware synthesis and optimization
- **Optimization Analysis:** Comparison of different solution strategies

## Authors

Niccolás Parra - Digital Logic Design Implementation

## License

This project is for educational purposes as part of digital logic design coursework.

