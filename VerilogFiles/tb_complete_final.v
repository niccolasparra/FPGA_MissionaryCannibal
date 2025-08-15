// ==========================================================================================
// FINAL TESTBENCH for Complete Missionary-Cannibal System
// Includes 40-cycle window for screenshot requirement
// Author: Niccolas Parra
// Date: 2025-06-14
// ==========================================================================================

`timescale 1ns / 1ps

module tb_complete_final;

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
    missionary_cannibal_complete dut (
        .clock(clock),
        .reset(reset),
        .missionary_next(missionary_next),
        .cannibal_next(cannibal_next),
        .finish(finish)
    );
    
    // ===============================
    // CLOCK GENERATION
    // ===============================
    // 50MHz clock (20ns period) for better visibility in waveforms
    initial begin
        clock = 0;
        forever #10 clock = ~clock;  // Toggle every 10ns
    end
    
    // ===============================
    // EXPECTED STATE SEQUENCE
    // ===============================
    // Define expected outputs for each state (from your midterm)
    reg [1:0] expected_missionary [0:11];
    reg [1:0] expected_cannibal [0:11];
    reg [2:0] expected_finish [0:11];
    
    initial begin
        // STATE_0: (3,3) - Initial
        expected_missionary[0] = 2'b11; expected_cannibal[0] = 2'b11; expected_finish[0] = 3'b000;
        // STATE_1: (3,1) - After Turn 1
        expected_missionary[1] = 2'b11; expected_cannibal[1] = 2'b01; expected_finish[1] = 3'b000;
        // STATE_2: (3,2) - After Turn 2
        expected_missionary[2] = 2'b11; expected_cannibal[2] = 2'b10; expected_finish[2] = 3'b000;
        // STATE_3: (3,0) - After Turn 3
        expected_missionary[3] = 2'b11; expected_cannibal[3] = 2'b00; expected_finish[3] = 3'b000;
        // STATE_4: (3,1) - After Turn 4
        expected_missionary[4] = 2'b11; expected_cannibal[4] = 2'b01; expected_finish[4] = 3'b000;
        // STATE_5: (1,1) - After Turn 5
        expected_missionary[5] = 2'b01; expected_cannibal[5] = 2'b01; expected_finish[5] = 3'b000;
        // STATE_6: (2,2) - After Turn 6
        expected_missionary[6] = 2'b10; expected_cannibal[6] = 2'b10; expected_finish[6] = 3'b000;
        // STATE_7: (0,2) - After Turn 7
        expected_missionary[7] = 2'b00; expected_cannibal[7] = 2'b10; expected_finish[7] = 3'b000;
        // STATE_8: (0,3) - After Turn 8
        expected_missionary[8] = 2'b00; expected_cannibal[8] = 2'b11; expected_finish[8] = 3'b000;
        // STATE_9: (0,1) - After Turn 9
        expected_missionary[9] = 2'b00; expected_cannibal[9] = 2'b01; expected_finish[9] = 3'b000;
        // STATE_10: (0,2) - After Turn 10
        expected_missionary[10] = 2'b00; expected_cannibal[10] = 2'b10; expected_finish[10] = 3'b000;
        // STATE_11: (0,0) - FINAL (Turn 11)
        expected_missionary[11] = 2'b00; expected_cannibal[11] = 2'b00; expected_finish[11] = 3'b001;
    end
    
    // ===============================
    // VERIFICATION TASK
    // ===============================
    task verify_state;
        input integer state_num;
        input [80*8-1:0] phase;  // Changed from string to reg array
        begin
            if (missionary_next !== expected_missionary[state_num] ||
                cannibal_next !== expected_cannibal[state_num] ||
                finish !== expected_finish[state_num]) begin
                
                $display("ERROR [%s] at cycle %0d, state %0d:", phase, cycle_count, state_num);
                $display("  Expected: M=%b(%0d), C=%b(%0d), F=%b", 
                    expected_missionary[state_num], expected_missionary[state_num],
                    expected_cannibal[state_num], expected_cannibal[state_num],
                    expected_finish[state_num]);
                $display("  Actual:   M=%b(%0d), C=%b(%0d), F=%b", 
                    missionary_next, missionary_next, cannibal_next, cannibal_next, finish);
                error_count = error_count + 1;
            end else begin
                $display("PASS [%s] cycle %0d, state %0d: M=%0d, C=%0d, F=%b", 
                    phase, cycle_count, state_num, missionary_next, cannibal_next, finish);
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
        
        $display("====================================================================");
        $display("MISSIONARY-CANNIBAL COMPLETE SYSTEM TEST");
        $display("Final Project - Term Project 2");
        $display("Student: Niccolas Parra");
        $display("====================================================================");
        
        // Wait for clock stabilization
        #25;
        
        // ===== TEST 1: SYSTEM RESET =====
        $display("\n[TEST 1] System Reset Verification");
        $display("--------------------------------------------------------------------");
        reset = 1;
        @(posedge clock);
        #2; // Small delay for combinational logic
        verify_state(0, "RESET");
        reset = 0;
        
        // ===== TEST 2: COMPLETE SOLUTION SEQUENCE (40 CYCLES) =====
        $display("\n[TEST 2] Complete Solution Sequence - 40-Cycle Window");
        $display("--------------------------------------------------------------------");
        $display("Starting 40-cycle simulation window for screenshot...");
        
        // Mark start of 40-cycle window
        $display("\n*** 40-CYCLE WINDOW START ***");
        
        // Run for exactly 40 cycles to capture complete sequences
        for (cycle_count = 0; cycle_count < 40; cycle_count = cycle_count + 1) begin
            @(posedge clock);
            #2; // Small delay for combinational logic
            
            // Verify the state (determine expected state inline)
            verify_state(cycle_count % 12, "SEQUENCE");
            
            // Special markers for important transitions
            if ((cycle_count % 12) == 11) begin
                $display("  >>> SOLUTION COMPLETE! Auto-restarting... <<<");
            end
            if ((cycle_count % 12) == 0 && cycle_count > 0) begin
                $display("  >>> NEW SOLUTION CYCLE STARTING <<<");
            end
        end
        
        $display("\n*** 40-CYCLE WINDOW END ***");
        
        // ===== TEST 3: RESET DURING OPERATION =====
        $display("\n[TEST 3] Reset During Operation");
        $display("--------------------------------------------------------------------");
        
        // Let it run a few more cycles
        repeat(5) begin
            @(posedge clock);
            cycle_count = cycle_count + 1;
            #2;
        end
        
        // Apply reset in middle of sequence
        $display("Applying reset at cycle %0d...", cycle_count);
        reset = 1;
        @(posedge clock);
        #2;
        verify_state(0, "MID-RESET");
        reset = 0;
        
        // ===== TEST 4: EXTENDED OPERATION =====
        $display("\n[TEST 4] Extended Operation Verification");
        $display("--------------------------------------------------------------------");
        
        // Run for another complete cycle to verify consistency
        for (cycle_count = 0; cycle_count < 12; cycle_count = cycle_count + 1) begin
            @(posedge clock);
            #2;
            verify_state(cycle_count, "EXTENDED");
        end
        
        // ===== FINAL RESULTS =====
        $display("\n====================================================================");
        if (error_count == 0) begin
            $display("🎉 ALL TESTS PASSED! Project Implementation Successful! 🎉");
            $display("✅ Sequential logic working correctly");
            $display("✅ Reset functionality verified");
            $display("✅ 40-cycle window captured");
            $display("✅ Auto-restart behavior confirmed");
            $display("✅ Complete solution sequence validated");
        end else begin
            $display("❌ TESTS FAILED!");
            $display("Total errors: %0d", error_count);
            $display("Please review the implementation.");
        end
        $display("====================================================================");
        
        // Additional cycles for waveform viewing
        $display("\nRunning additional cycles for waveform analysis...");
        repeat(20) begin
            @(posedge clock);
            #2;
        end
        
        // Finish simulation
        $display("\nSimulation completed. Check waveform file: complete_system.vcd");
        #100;
        $finish;
    end
    
    // ===============================
    // WAVEFORM GENERATION
    // ===============================
    initial begin
        $dumpfile("complete_system.vcd");
        $dumpvars(0, tb_complete_final);
        
        // Also dump internal state for debugging
        $dumpvars(1, dut.current_state);
        $dumpvars(1, dut.next_state);
    end
    
    // ===============================
    // CONTINUOUS MONITORING
    // ===============================
    initial begin
        $monitor("Time=%0t | Clk=%b | Rst=%b | State=%b | M=%0d C=%0d F=%b | Cycle=%0d", 
                 $time, clock, reset, dut.current_state, 
                 missionary_next, cannibal_next, finish, cycle_count);
    end
    
    // ===============================
    // CYCLE COUNTER FOR SCREENSHOT
    // ===============================
    initial begin
        #200; // Wait for initial reset
        $display("\n📸 SCREENSHOT REMINDER:");
        $display("For project submission, capture waveform from cycle 0 to cycle 40");
        $display("This window shows complete solution sequence with auto-restart");
        $display("Look for the finish signal going high at cycle 11, 23, 35, etc.");
    end
    
endmodule

// ==========================================================================================
// TESTBENCH FEATURES FOR PROJECT SUBMISSION:
// 
// 1. 40-CYCLE WINDOW: Captures exactly what's needed for screenshot
// 2. COMPREHENSIVE VERIFICATION: Tests all major functionality
// 3. CLEAR DOCUMENTATION: Easy to understand output
// 4. WAVEFORM READY: Generates VCD file for viewing
// 5. ERROR REPORTING: Detailed pass/fail information
// 6. PROJECT COMPLIANCE: Meets all stated requirements
// 
// USAGE FOR PROJECT:
// 1. Compile: iverilog -o test_final tb_complete_final.v missionary_cannibal_complete_fixed.v
// 2. Run: ./test_final
// 3. View waveforms: gtkwave complete_system.vcd
// 4. Take screenshot of cycles 0-40 for submission
// 5. Note Fmax after Quartus synthesis
// ==========================================================================================

