// ==========================================================================================
// COSE221 : Term Project 2 : Missionaries and Cannibals Sequential Logic
// Sequential FSM Implementation for Missionary-Cannibal Problem
// Author: Niccolas Parra
// Date: 2025-06-14
// 
// DESIGN OVERVIEW:
// - FSM with 12 valid states representing puzzle configurations
// - Automatic progression through solution path
// - Synchronous reset to initial state
// - Positive edge-triggered clock
// - Outputs: missionary_next, cannibal_next, finish
// ==========================================================================================

module missionary_cannibal_sequential (
    input wire clock,                    // System clock (positive edge triggered)
    input wire reset,                    // Synchronous reset (active high)
    output reg [1:0] missionary_next,    // Next missionaries on original side
    output reg [1:0] cannibal_next,      // Next cannibals on original side  
    output reg [2:0] finish              // Finish signal (3-bit as specified)
);

    // ===============================
    // STATE ENCODING
    // ===============================
    // 4-bit state encoding for 12 valid states
    // State represents (missionaries_left, cannibals_left, boat_side)
    // boat_side: 0 = left, 1 = right
    
    parameter [3:0] STATE_0  = 4'b0000;  // (3,3,L) - Initial state
    parameter [3:0] STATE_1  = 4'b0001;  // (3,1,R) - After first move
    parameter [3:0] STATE_2  = 4'b0010;  // (3,2,L) - After return
    parameter [3:0] STATE_3  = 4'b0011;  // (3,0,R) - Remove 2 cannibals
    parameter [3:0] STATE_4  = 4'b0100;  // (3,1,L) - Return 1 cannibal
    parameter [3:0] STATE_5  = 4'b0101;  // (1,1,R) - Move 2 missionaries
    parameter [3:0] STATE_6  = 4'b0110;  // (2,2,L) - Return 1M+1C
    parameter [3:0] STATE_7  = 4'b0111;  // (0,2,R) - Move 2 missionaries
    parameter [3:0] STATE_8  = 4'b1000;  // (0,3,L) - Return 1 cannibal
    parameter [3:0] STATE_9  = 4'b1001;  // (0,1,R) - Move 2 cannibals
    parameter [3:0] STATE_10 = 4'b1010;  // (0,2,L) - Return 1 cannibal
    parameter [3:0] STATE_11 = 4'b1011;  // (0,0,R) - Final state
    
    // Current state register
    reg [3:0] current_state;
    reg [3:0] next_state;
    
    // ===============================
    // STATE REGISTER
    // ===============================
    // Synchronous state update with positive edge clock
    always @(posedge clock) begin
        if (reset) begin
            current_state <= STATE_0;  // Reset to initial state (3,3,L)
        end else begin
            current_state <= next_state;
        end
    end
    
    // ===============================
    // NEXT STATE LOGIC
    // ===============================
    // Sequential progression through valid solution path
    always @(*) begin
        case (current_state)
            STATE_0:  next_state = STATE_1;   // (3,3,L) -> (3,1,R)
            STATE_1:  next_state = STATE_2;   // (3,1,R) -> (3,2,L)
            STATE_2:  next_state = STATE_3;   // (3,2,L) -> (3,0,R)
            STATE_3:  next_state = STATE_4;   // (3,0,R) -> (3,1,L)
            STATE_4:  next_state = STATE_5;   // (3,1,L) -> (1,1,R)
            STATE_5:  next_state = STATE_6;   // (1,1,R) -> (2,2,L)
            STATE_6:  next_state = STATE_7;   // (2,2,L) -> (0,2,R)
            STATE_7:  next_state = STATE_8;   // (0,2,R) -> (0,3,L)
            STATE_8:  next_state = STATE_9;   // (0,3,L) -> (0,1,R)
            STATE_9:  next_state = STATE_10;  // (0,1,R) -> (0,2,L)
            STATE_10: next_state = STATE_11;  // (0,2,L) -> (0,0,R)
            STATE_11: next_state = STATE_0;   // (0,0,R) -> (3,3,L) - Auto reset
            default:  next_state = STATE_0;   // Error recovery
        endcase
    end
    
    // ===============================
    // OUTPUT LOGIC (Moore Machine)
    // ===============================
    // Outputs depend only on current state
    always @(*) begin
        case (current_state)
            STATE_0: begin  // (3,3,L)
                missionary_next = 2'b11;  // 3 missionaries
                cannibal_next = 2'b11;    // 3 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_1: begin  // (3,1,R)
                missionary_next = 2'b11;  // 3 missionaries
                cannibal_next = 2'b01;    // 1 cannibal
                finish = 3'b000;          // Not finished
            end
            STATE_2: begin  // (3,2,L)
                missionary_next = 2'b11;  // 3 missionaries
                cannibal_next = 2'b10;    // 2 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_3: begin  // (3,0,R)
                missionary_next = 2'b11;  // 3 missionaries
                cannibal_next = 2'b00;    // 0 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_4: begin  // (3,1,L)
                missionary_next = 2'b11;  // 3 missionaries
                cannibal_next = 2'b01;    // 1 cannibal
                finish = 3'b000;          // Not finished
            end
            STATE_5: begin  // (1,1,R)
                missionary_next = 2'b01;  // 1 missionary
                cannibal_next = 2'b01;    // 1 cannibal
                finish = 3'b000;          // Not finished
            end
            STATE_6: begin  // (2,2,L)
                missionary_next = 2'b10;  // 2 missionaries
                cannibal_next = 2'b10;    // 2 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_7: begin  // (0,2,R)
                missionary_next = 2'b00;  // 0 missionaries
                cannibal_next = 2'b10;    // 2 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_8: begin  // (0,3,L)
                missionary_next = 2'b00;  // 0 missionaries
                cannibal_next = 2'b11;    // 3 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_9: begin  // (0,1,R)
                missionary_next = 2'b00;  // 0 missionaries
                cannibal_next = 2'b01;    // 1 cannibal
                finish = 3'b000;          // Not finished
            end
            STATE_10: begin // (0,2,L)
                missionary_next = 2'b00;  // 0 missionaries
                cannibal_next = 2'b10;    // 2 cannibals
                finish = 3'b000;          // Not finished
            end
            STATE_11: begin // (0,0,R) - FINAL STATE
                missionary_next = 2'b00;  // 0 missionaries
                cannibal_next = 2'b00;    // 0 cannibals
                finish = 3'b001;          // FINISHED!
            end
            default: begin   // Error state
                missionary_next = 2'b11;  // Reset values
                cannibal_next = 2'b11;
                finish = 3'b000;
            end
        endcase
    end
    
endmodule

// ==========================================================================================
// DESIGN NOTES:
// 
// 1. FSM TYPE: Moore machine - outputs depend only on current state
// 2. CLOCK: Positive edge-triggered, synchronous design
// 3. RESET: Synchronous reset, returns to initial state (3,3,L)
// 4. STATES: 12 valid states representing the optimal solution path
// 5. PROGRESSION: Automatic advancement through solution sequence
// 6. FINISH: 3-bit signal, active (001) only in final state
// 7. AUTO-RESTART: From final state, automatically returns to initial state
// 
// STATE SEQUENCE (Optimal Solution):
// (3,3,L) -> (3,1,R) -> (3,2,L) -> (3,0,R) -> (3,1,L) -> (1,1,R) ->
// (2,2,L) -> (0,2,R) -> (0,3,L) -> (0,1,R) -> (0,2,L) -> (0,0,R)
// 
// TIMING: Each state transition occurs on rising clock edge
// OPTIMIZATION: State encoding optimized for synthesis efficiency
// ==========================================================================================

