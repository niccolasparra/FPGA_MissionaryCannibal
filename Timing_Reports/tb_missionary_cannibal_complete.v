// Testbench for Missionaries and Cannibals State Machine
// Comprehensive verification including timing analysis

`timescale 1ns/1ps

module tb_missionary_cannibal_complete;

// Testbench signals
reg clk;
reg reset;
reg start;
wire [3:0] state;
wire [2:0] missionaries_left;
wire [2:0] cannibals_left;
wire [2:0] missionaries_right;
wire [2:0] cannibals_right;
wire boat_side;
wire solution_complete;
wire valid_state;

// Clock period definition
parameter CLK_PERIOD = 10; // 10ns = 100MHz

// Instantiate the Unit Under Test (UUT)
missionary_cannibal_complete uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .state(state),
    .missionaries_left(missionaries_left),
    .cannibals_left(cannibals_left),
    .missionaries_right(missionaries_right),
    .cannibals_right(cannibals_right),
    .boat_side(boat_side),
    .solution_complete(solution_complete),
    .valid_state(valid_state)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end

// Test sequence
integer i;
initial begin
    // Initialize signals
    reset = 1;
    start = 0;
    
    // Create VCD file for waveform viewing
    $dumpfile("missionary_cannibal_simulation.vcd");
    $dumpvars(0, tb_missionary_cannibal_complete);
    
    // Display header
    $display("=== Missionaries and Cannibals State Machine Simulation ===");
    $display("Time\tState\tM_L\tC_L\tM_R\tC_R\tBoat\tComplete\tValid");
    $display("----\t-----\t---\t---\t---\t---\t----\t--------\t-----");
    
    // Reset sequence
    #20 reset = 0;
    #10;
    
    // Monitor initial state
    $display("%4t\t%4b\t%3d\t%3d\t%3d\t%3d\t%4s\t%8b\t%5b", 
             $time, state, missionaries_left, cannibals_left, 
             missionaries_right, cannibals_right, 
             boat_side ? "Right" : "Left", solution_complete, valid_state);
    
    // Start the solution sequence
    start = 1;
    #CLK_PERIOD;
    start = 0;
    
    // Wait for solution to complete or timeout after 20 cycles
    for (i = 0; i < 20; i = i + 1) begin
        #CLK_PERIOD;
        $display("%4t\t%4b\t%3d\t%3d\t%3d\t%3d\t%4s\t%8b\t%5b", 
                 $time, state, missionaries_left, cannibals_left, 
                 missionaries_right, cannibals_right, 
                 boat_side ? "Right" : "Left", solution_complete, valid_state);
        
        // Check for solution completion
        if (solution_complete) begin
            $display("\n*** SOLUTION COMPLETED SUCCESSFULLY! ***");
            $display("Final State: All 3 missionaries and 3 cannibals on right side");
            i = 20; // Exit loop by setting i to loop limit
        end
    end
    
    // Additional time to observe final state
    #(5*CLK_PERIOD);
    
    // Verification checks
    $display("\n=== VERIFICATION RESULTS ===");
    
    // Check final state
    if (missionaries_right == 3 && cannibals_right == 3 && 
        missionaries_left == 0 && cannibals_left == 0) begin
        $display("✓ PASS: Final positioning correct");
    end else begin
        $display("✗ FAIL: Final positioning incorrect");
    end
    
    // Check solution complete flag
    if (solution_complete) begin
        $display("✓ PASS: Solution complete flag set");
    end else begin
        $display("✗ FAIL: Solution complete flag not set");
    end
    
    // Check validity
    if (valid_state) begin
        $display("✓ PASS: Valid state maintained");
    end else begin
        $display("✗ FAIL: Invalid state detected");
    end
    
    $display("\n=== TIMING ANALYSIS ===");
    $display("Clock Period: %0d ns", CLK_PERIOD);
    $display("Total Simulation Time: %0t", $time);
    $display("Number of Clock Cycles: %0d", ($time / CLK_PERIOD));
    
    // Test reset functionality
    $display("\n=== TESTING RESET FUNCTIONALITY ===");
    #20;
    reset = 1;
    #CLK_PERIOD;
    reset = 0;
    #CLK_PERIOD;
    
    if (state == 4'b0000 && !solution_complete) begin
        $display("✓ PASS: Reset functionality working");
    end else begin
        $display("✗ FAIL: Reset functionality not working");
    end
    
    $display("\n=== SIMULATION COMPLETED ===");
    $finish;
end

// State change monitor
always @(posedge clk) begin
    if (!reset && $time > 30) begin // Skip initial reset period
        case (state)
            4'b0001: $display("State S1: Initial setup - boat on left");
            4'b0010: $display("State S2: 1M,1C crossed to right");
            4'b0011: $display("State S3: 1M returned to left");
            4'b0100: $display("State S4: 2C crossed to right");
            4'b0101: $display("State S5: 1C returned to left");
            4'b0110: $display("State S6: 2M crossed to right");
            4'b0111: $display("State S7: 1M,1C returned to left");
            4'b1000: $display("State S8: 2M crossed to right");
            4'b1001: $display("State S9: 1C returned to left");
            4'b1010: $display("State S10: 2C crossed to right");
            4'b1011: $display("State S11: 1C returned to left");
            4'b1100: $display("State S12: SOLUTION COMPLETE!");
        endcase
    end
end

// Safety constraint checker
always @(*) begin
    if (!reset && valid_state) begin
        // Check missionaries >= cannibals on each side (when missionaries > 0)
        if ((missionaries_left > 0 && missionaries_left < cannibals_left) ||
            (missionaries_right > 0 && missionaries_right < cannibals_right)) begin
            $display("WARNING: Safety constraint violated at time %t!", $time);
            $display("Left side: M=%d, C=%d | Right side: M=%d, C=%d", 
                     missionaries_left, cannibals_left, missionaries_right, cannibals_right);
        end
    end
end

// Performance monitoring
real start_time, end_time, execution_time;
initial begin
    wait(start == 1);
    start_time = $time;
    wait(solution_complete == 1);
    end_time = $time;
    execution_time = end_time - start_time;
    $display("\n=== PERFORMANCE METRICS ===");
    $display("Execution Time: %.2f ns", execution_time);
    $display("Clock Cycles to Complete: %0d", (execution_time / CLK_PERIOD));
end

endmodule

