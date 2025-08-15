# Missionaries and Cannibals State Machine Project

A complete digital design project implementing the classic Missionaries and Cannibals puzzle as a finite state machine using Verilog HDL.

## Project Overview

This project solves the Missionaries and Cannibals puzzle through a sequential logic design approach. The puzzle involves safely transporting 3 missionaries and 3 cannibals across a river using a boat that can carry at most 2 people, ensuring that cannibals never outnumber missionaries on either side.

## Project Structure

```
MissionariesCannibals_Project/
├── README.md                    # This file
├── Documentation/               # All documentation files
│   ├── state_machine_analysis.tex    # LaTeX document with K-maps and circuit diagrams
│   ├── DETAILED_EXPLANATION.md       # Comprehensive design explanation
│   ├── PROJECT_COMPLETE.md           # Project completion summary
│   └── project_summary.md            # Project summary
├── VerilogFiles/               # All Verilog source files
│   ├── missionary_cannibal_complete.v        # Main state machine module
│   ├── missionary_cannibal_complete_fixed.v  # Fixed version with improvements
│   ├── missionary_cannibal_sequential.v      # Sequential logic implementation
│   ├── tb_missionary_cannibal_sequential.v   # Testbench for sequential version
│   └── tb_complete_final.v                   # Final comprehensive testbench
└── SimulationFiles/            # Simulation outputs
    └── missionary_cannibal_sequential.vcd    # Waveform data
```

## Key Features

### State Machine Design
- **10 unique states** representing valid puzzle configurations
- **Sequential logic implementation** using D flip-flops
- **State encoding** with 4-bit binary representation
- **Transition logic** derived from Karnaugh maps
- **Safety constraints** preventing invalid states

### Technical Implementation
- **Verilog HDL** for hardware description
- **Finite State Machine (FSM)** design methodology
- **K-map optimization** for minimal logic expressions
- **Comprehensive testbenches** for verification
- **Waveform analysis** for timing verification

### Documentation
- **LaTeX technical report** with circuit diagrams and K-maps
- **Detailed markdown explanations** of design process
- **Step-by-step solution** trace through all valid states
- **Circuit analysis** with logic gate implementations

## States and Encoding

| State | Missionaries Left | Cannibals Left | Boat Position | Binary Code |
|-------|------------------|----------------|---------------|-------------|
| S0    | 3                | 3              | Left          | 0000        |
| S1    | 3                | 1              | Right         | 0001        |
| S2    | 3                | 2              | Left          | 0010        |
| S3    | 3                | 0              | Right         | 0011        |
| S4    | 3                | 1              | Left          | 0100        |
| S5    | 1                | 1              | Right         | 0101        |
| S6    | 2                | 2              | Left          | 0110        |
| S7    | 0                | 2              | Right         | 0111        |
| S8    | 0                | 3              | Left          | 1000        |
| S9    | 0                | 1              | Right         | 1001        |
| S10   | 0                | 0              | Right         | 1010        |

## Solution Path

The optimal solution follows this state sequence:
S0 → S1 → S2 → S3 → S4 → S5 → S6 → S7 → S8 → S9 → S10

## Files Description

### Main Design Files
- `missionary_cannibal_complete_fixed.v`: Final optimized state machine implementation
- `tb_complete_final.v`: Comprehensive testbench with all test cases

### Documentation Files
- `state_machine_analysis.tex`: Complete LaTeX report with mathematical analysis
- `DETAILED_EXPLANATION.md`: In-depth explanation of design methodology

### Simulation Files
- `missionary_cannibal_sequential.vcd`: GTKWave-compatible waveform data

## How to Use

### Simulation
1. Compile the Verilog files using your preferred simulator (ModelSim, Icarus Verilog, etc.)
2. Run the testbench to verify functionality
3. View waveforms using GTKWave or similar tool

### Synthesis
1. Use the main module for FPGA implementation
2. Apply timing constraints as needed
3. Verify timing closure and resource utilization

## Design Methodology

1. **Problem Analysis**: Identified all valid states and transitions
2. **State Encoding**: Assigned binary codes to each state
3. **K-map Optimization**: Derived minimal Boolean expressions
4. **Sequential Logic Design**: Implemented using D flip-flops
5. **Verification**: Comprehensive testbench validation
6. **Documentation**: Detailed technical report generation

## Tools Used

- **Verilog HDL**: Hardware description language
- **LaTeX**: Technical documentation
- **GTKWave**: Waveform visualization
- **Karnaugh Maps**: Logic optimization
- **ModelSim/Icarus Verilog**: Simulation tools

## Academic Context

This project demonstrates proficiency in:
- Digital logic design
- Finite state machine implementation
- Verilog HDL programming
- Sequential circuit analysis
- Technical documentation
- Engineering problem solving

## Author

Niccolás Parra  
Digital Design Course Project

## License

This project is for educational purposes. Feel free to use and modify for learning objectives.

---

*For detailed technical analysis, refer to the documentation files in the Documentation/ folder.*

