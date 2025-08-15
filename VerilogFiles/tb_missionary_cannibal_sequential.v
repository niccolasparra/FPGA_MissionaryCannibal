// ==========================================================================================
// TESTBENCH for Missionary-Cannibal Sequential Logic
// Comprehensive verification of FSM behavior
// Author: Niccolas Parra
// Date: 2025-06-14
// ==========================================================================================

`timescale 1ns / 1ps

module tb_missionary_cannibal_sequential;

    // ===============================
    // TESTBENCH SIGNALS
    // ===============================
    reg clock;
    reg reset;
    wire [1:0] missionary_next;
    wire [1:0] cannibal_next;
    wire [2:0] finish;
    
    // Test control variables
    integer cycle_count;
    integer error_count;
    
    // ===============================
    // DEVICE UNDER TEST (DUT)
    // ===============================
    missionary_cannibal_sequential dut (
        .clock(clock),
        .reset(reset),
        .missionary_next(missionary_next),
        .cannibal_next(cannibal_next),
        .finish(finish)
    );
    
    // ===============================
    // CLOCK GENERATION
    // ===============================
    // 100MHz clock (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;  // Toggle every 5ns
    end
    
    // ===============================
    // EXPECTED STATE SEQUENCE
    // ===============================
    // Define expected outputs for each state
    reg [1:0] expected_missionary [0:11];
    reg [1:0] expected_cannibal [0:11];
    reg [2:0] expected_finish [0:11];
    
    initial begin
        // STATE_0: (3,3,L)
        expected_missionary[0] = 2'b11; expected_cannibal[0] = 2'b11; expected_finish[0] = 3'b000;
        // STATE_1: (3,1,R)
        expected_missionary[1] = 2'b11; expected_cannibal[1] = 2'b01; expected_finish[1] = 3'b000;
        // STATE_2: (3,2,L)
        expected_missionary[2] = 2'b11; expected_cannibal[2] = 2'b10; expected_finish[2] = 3'b000;
        // STATE_3: (3,0,R)
        expected_missionary[3] = 2'b11; expected_cannibal[3] = 2'b00; expected_finish[3] = 3'b000;
        // STATE_4: (3,1,L)
        expected_missionary[4] = 2'b11; expected_cannibal[4] = 2'b01; expected_finish[4] = 3'b000;
        // STATE_5: (1,1,R)
        expected_missionary[5] = 2'b01; expected_cannibal[5] = 2'b01; expected_finish[5] = 3'b000;
        // STATE_6: (2,2,L)
        expected_missionary[6] = 2'b10; expected_cannibal[6] = 2'b10; expected_finish[6] = 3'b000;
        // STATE_7: (0,2,R)
        expected_missionary[7] = 2'b00; expected_cannibal[7] = 2'b10; expected_finish[7] = 3'b000;
        // STATE_8: (0,3,L)
        expected_missionary[8] = 2'b00; expected_cannibal[8] = 2'b11; expected_finish[8] = 3'b000;
        // STATE_9: (0,1,R)
        expected_missionary[9] = 2'b00; expected_cannibal[9] = 2'b01; expected_finish[9] = 3'b000;
        // STATE_10: (0,2,L)
        expected_missionary[10] = 2'b00; expected_cannibal[10] = 2'b10; expected_finish[10] = 3'b000;
        // STATE_11: (0,0,R) - FINAL
        expected_missionary[11] = 2'b00; expected_cannibal[11] = 2'b00; expected_finish[11] = 3'b001;
    end
    
    // ===============================
    // VERIFICATION TASK
    // ===============================
    task verify_state;
        input integer state_num;
        begin
            if (missionary_next !== expected_missionary[state_num] ||
                cannibal_next !== expected_cannibal[state_num] ||
                finish !== expected_finish[state_num]) begin
                
                $display("ERROR at cycle %0d, state %0d:", cycle_count, state_num);
                $display("  Expected: M=%b, C=%b, F=%b", 
                    expected_missionary[state_num], expected_cannibal[state_num], expected_finish[state_num]);
                $display("  Actual:   M=%b, C=%b, F=%b", 
                    missionary_next, cannibal_next, finish);
                error_count = error_count + 1;
            end else begin
                $display("PASS cycle %0d, state %0d: M=%b, C=%b, F=%b", 
                    cycle_count, state_num, missionary_next, cannibal_next, finish);
            end
        end
    endtask
    
    // ===============================
    // MAIN TEST SEQUENCE
    // ===============================
    initial begin
        // Initialize
        error_count = 0;
        cycle_count = 0;
        reset = 0;
        
        $display("======================================");
        $display("MISSIONARY-CANNIBAL SEQUENTIAL TEST");
        $display("======================================");
        
        // Wait for clock stabilization
        #10;
        
        // ===== TEST 1: RESET FUNCTIONALITY =====
        $display("\nTEST 1: Reset Functionality");
        reset = 1;
        @(posedge clock);
        #1; // Small delay for combinational logic
        verify_state(0); // Should be in initial state
        reset = 0;
        
        // ===== TEST 2: COMPLETE SEQUENCE =====
        $display("\nTEST 2: Complete Solution Sequence");
        
        // Verify initial state first
        #1;
        verify_state(0);
        
        // Run through complete 12-state sequence
        for (cycle_count = 1; cycle_count < 12; cycle_count = cycle_count + 1) begin
            @(posedge clock);
            #1; // Small delay for combinational logic
            verify_state(cycle_count);
        end
        
        // ===== TEST 3: AUTO-RESTART =====
        $display("\nTEST 3: Auto-restart from finish state");
        @(posedge clock);
        #1;
        verify_state(0); // Should be back to initial state
        
        // ===== TEST 4: RESET DURING OPERATION =====
        $display("\nTEST 4: Reset during operation");
        
        // Run a few cycles
        repeat(5) begin
            @(posedge clock);
            cycle_count = cycle_count + 1;
        end
        
        // Apply reset
        reset = 1;
        @(posedge clock);
        #1;
        verify_state(0); // Should be in initial state
        reset = 0;
        
        // ===== TEST 5: EXTENDED OPERATION =====
        $display("\nTEST 5: Extended operation (2 complete cycles)");
        
        // Run two complete sequences
        for (cycle_count = 0; cycle_count < 24; cycle_count = cycle_count + 1) begin
            @(posedge clock);
            #1;
            verify_state(cycle_count % 12);
        end
        
        // ===== TEST RESULTS =====
        $display("\n======================================");
        if (error_count == 0) begin
            $display("ALL TESTS PASSED! ✓");
            $display("Sequential FSM is working correctly.");
        end else begin
            $display("TESTS FAILED! ✗");
            $display("Total errors: %0d", error_count);
        end
        $display("======================================");
        
        // Finish simulation
        #100;
        $finish;
    end
    
    // ===============================
    // WAVEFORM DUMP (for viewing)
    // ===============================
    initial begin
        $dumpfile("missionary_cannibal_sequential.vcd");
        $dumpvars(0, tb_missionary_cannibal_sequential);
    end
    
    // ===============================
    // MONITORING (for debugging)
    // ===============================
    initial begin
        $monitor("Time=%0t | Clock=%b | Reset=%b | State=%b | M=%b C=%b F=%b", 
                 $time, clock, reset, dut.current_state, missionary_next, cannibal_next, finish);
    end
    
endmodule

// ==========================================================================================
// TESTBENCH FEATURES:
// 
// 1. COMPREHENSIVE TESTING:
//    - Reset functionality
//    - Complete solution sequence
//    - Auto-restart behavior
//    - Reset during operation
//    - Extended operation
// 
// 2. VERIFICATION:
//    - Expected vs actual output comparison
//    - Error counting and reporting
//    - Detailed pass/fail information
// 
// 3. DEBUGGING SUPPORT:
//    - Waveform generation (VCD file)
//    - Real-time monitoring
//    - Detailed error messages
// 
// 4. TIMING:
//    - 100MHz clock (realistic frequency)
//    - Proper setup/hold timing
//    - Combinational delay consideration
// 
// USAGE:
//   1. Compile: iverilog -o test tb_missionary_cannibal_sequential.v missionary_cannibal_sequential.v
//   2. Run: ./test
//   3. View waveforms: gtkwave missionary_cannibal_sequential.vcd
// ==========================================================================================

