// Missionaries and Cannibals State Machine using T Flip-Flops
// This module implements the complete solution sequence

module missionary_cannibal_complete (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [3:0] state,
    output reg [2:0] missionaries_left,
    output reg [2:0] cannibals_left,
    output reg [2:0] missionaries_right,
    output reg [2:0] cannibals_right,
    output reg boat_side,  // 0=left, 1=right
    output reg solution_complete,
    output reg valid_state
);

// State encoding for 12-step solution
parameter IDLE = 4'b0000;
parameter S1   = 4'b0001;  // Initial: M=3,C=3 | M=0,C=0, boat_left
parameter S2   = 4'b0010;  // After 1M,1C cross: M=2,C=2 | M=1,C=1, boat_right
parameter S3   = 4'b0011;  // After 1M returns: M=3,C=2 | M=0,C=1, boat_left
parameter S4   = 4'b0100;  // After 2C cross: M=3,C=0 | M=0,C=3, boat_right
parameter S5   = 4'b0101;  // After 1C returns: M=3,C=1 | M=0,C=2, boat_left
parameter S6   = 4'b0110;  // After 2M cross: M=1,C=1 | M=2,C=2, boat_right
parameter S7   = 4'b0111;  // After 1M,1C return: M=2,C=2 | M=1,C=1, boat_left
parameter S8   = 4'b1000;  // After 2M cross: M=0,C=2 | M=3,C=1, boat_right
parameter S9   = 4'b1001;  // After 1C returns: M=0,C=3 | M=3,C=0, boat_left
parameter S10  = 4'b1010;  // After 2C cross: M=0,C=1 | M=3,C=2, boat_right
parameter S11  = 4'b1011;  // After 1C returns: M=0,C=2 | M=3,C=1, boat_left
parameter S12  = 4'b1100;  // Final: M=0,C=0 | M=3,C=3, boat_right

// T Flip-Flop control signals - corrected logic for proper state progression
wire [3:0] t_ff;
wire enable_transition;
reg started;

// Track if the system has been started
always @(posedge clk or posedge reset) begin
    if (reset) begin
        started <= 0;
    end else if (start) begin
        started <= 1;
    end
end

// Enable transitions only when system is started and not in final state
assign enable_transition = started && (state != S12);

// T flip-flop logic based on binary counting with state-specific control
// The sequence progresses: 0000->0001->0010->0011->0100->0101->0110->0111->1000->1001->1010->1011->1100

// T[0] - LSB toggles every state transition (like a binary counter LSB)
assign t_ff[0] = enable_transition && (
    (state == IDLE) ||           // 0000 -> 0001
    (state == S1) ||             // 0001 -> 0010
    (state == S2) ||             // 0010 -> 0011
    (state == S3) ||             // 0011 -> 0100
    (state == S4) ||             // 0100 -> 0101
    (state == S5) ||             // 0101 -> 0110
    (state == S6) ||             // 0110 -> 0111
    (state == S7) ||             // 0111 -> 1000
    (state == S8) ||             // 1000 -> 1001
    (state == S9) ||             // 1001 -> 1010
    (state == S10) ||            // 1010 -> 1011
    (state == S11)               // 1011 -> 1100
);

// T[1] - Second bit toggles when LSB goes from 1 to 0 (every 2 transitions)
assign t_ff[1] = enable_transition && (
    (state == S1) ||             // 0001 -> 0010
    (state == S3) ||             // 0011 -> 0100
    (state == S5) ||             // 0101 -> 0110
    (state == S7) ||             // 0111 -> 1000
    (state == S9) ||             // 1001 -> 1010
    (state == S11)               // 1011 -> 1100
);

// T[2] - Third bit toggles when lower 2 bits go from 11 to 00 (every 4 transitions)
assign t_ff[2] = enable_transition && (
    (state == S3) ||             // 0011 -> 0100
    (state == S7) ||             // 0111 -> 1000
    (state == S11)               // 1011 -> 1100
);

// T[3] - MSB toggles when lower 3 bits go from 111 to 000 (every 8 transitions)
assign t_ff[3] = enable_transition && (
    (state == S7)                // 0111 -> 1000
);

// Note: We stop at S12 (1100) which represents the final state

// T Flip-Flop implementation
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        state[0] <= state[0] ^ t_ff[0];
        state[1] <= state[1] ^ t_ff[1];
        state[2] <= state[2] ^ t_ff[2];
        state[3] <= state[3] ^ t_ff[3];
    end
end

// Output logic for missionaries and cannibals positions
always @(*) begin
    case (state)
        IDLE: begin
            missionaries_left = 3; cannibals_left = 3;
            missionaries_right = 0; cannibals_right = 0;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S1: begin
            missionaries_left = 3; cannibals_left = 3;
            missionaries_right = 0; cannibals_right = 0;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S2: begin
            missionaries_left = 2; cannibals_left = 2;
            missionaries_right = 1; cannibals_right = 1;
            boat_side = 1; solution_complete = 0; valid_state = 1;
        end
        S3: begin
            missionaries_left = 3; cannibals_left = 2;
            missionaries_right = 0; cannibals_right = 1;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S4: begin
            missionaries_left = 3; cannibals_left = 0;
            missionaries_right = 0; cannibals_right = 3;
            boat_side = 1; solution_complete = 0; valid_state = 1;
        end
        S5: begin
            missionaries_left = 3; cannibals_left = 1;
            missionaries_right = 0; cannibals_right = 2;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S6: begin
            missionaries_left = 1; cannibals_left = 1;
            missionaries_right = 2; cannibals_right = 2;
            boat_side = 1; solution_complete = 0; valid_state = 1;
        end
        S7: begin
            missionaries_left = 2; cannibals_left = 2;
            missionaries_right = 1; cannibals_right = 1;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S8: begin
            missionaries_left = 0; cannibals_left = 2;
            missionaries_right = 3; cannibals_right = 1;
            boat_side = 1; solution_complete = 0; valid_state = 1;
        end
        S9: begin
            missionaries_left = 0; cannibals_left = 3;
            missionaries_right = 3; cannibals_right = 0;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S10: begin
            missionaries_left = 0; cannibals_left = 1;
            missionaries_right = 3; cannibals_right = 2;
            boat_side = 1; solution_complete = 0; valid_state = 1;
        end
        S11: begin
            missionaries_left = 0; cannibals_left = 2;
            missionaries_right = 3; cannibals_right = 1;
            boat_side = 0; solution_complete = 0; valid_state = 1;
        end
        S12: begin
            missionaries_left = 0; cannibals_left = 0;
            missionaries_right = 3; cannibals_right = 3;
            boat_side = 1; solution_complete = 1; valid_state = 1;
        end
        default: begin
            missionaries_left = 0; cannibals_left = 0;
            missionaries_right = 0; cannibals_right = 0;
            boat_side = 0; solution_complete = 0; valid_state = 0;
        end
    endcase
end

endmodule

