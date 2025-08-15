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

// T Flip-Flop control signals
wire [3:0] t_ff;
reg [3:0] state_next;

// State transition logic using T flip-flops
assign t_ff[0] = (state == IDLE && start) ||
                 (state == S1) || (state == S2) || (state == S4) ||
                 (state == S5) || (state == S7) || (state == S8) ||
                 (state == S10) || (state == S11);

assign t_ff[1] = (state == S1) || (state == S2) || (state == S5) ||
                 (state == S6) || (state == S9) || (state == S10);

assign t_ff[2] = (state == S3) || (state == S4) || (state == S7) ||
                 (state == S8) || (state == S11) || (state == S12);

assign t_ff[3] = (state == S7) || (state == S8) || (state == S9) ||
                 (state == S10) || (state == S11) || (state == S12);

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

