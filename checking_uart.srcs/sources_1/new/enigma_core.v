`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 22:39:47
// Design Name: 
// Module Name: enigma_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module enigma_core (
    input wire clk,
    input wire reset,
    input wire [7:0] ascii_in,
    input wire valid_in,
    output reg [7:0] ascii_out,
    output reg valid_out
);

    // FSM state encoding
    reg [2:0] state;
    localparam IDLE    = 3'd0;
    localparam STEP    = 3'd1;
    localparam LATCH   = 3'd2;
    localparam ENCRYPT = 3'd3;
    localparam WAIT    = 3'd4;
    localparam OUTPUT  = 3'd5;

    // Rotor positions
    reg [4:0] rotor1_pos;
    reg [4:0] rotor2_pos;
    reg [4:0] rotor3_pos;

    // Latched input character (0 to 25)
    reg [4:0] latched_char;

    // Wires for rotor/reflector outputs and valid signals
    wire [4:0] r3_out, r2_out, r1_out;
    wire [4:0] ref_out, r1r_out, r2r_out, r3r_out;

    wire v_r3, v_r2, v_r1, v_ref, v_r1r, v_r2r, v_r3r;

    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rotor1_pos <= 0;
            rotor2_pos <= 0;
            rotor3_pos <= 0;
            valid_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid_out <= 0;
                    if (valid_in)
                        state <= STEP;
                end

                STEP: begin
                    // Step rotor3 every keypress
                    if (rotor3_pos == 5'd25)
                        rotor3_pos <= 0;
                    else
                        rotor3_pos <= rotor3_pos + 1;

                    // Step rotor2 at rotor3 notch (Q = index 16)
                    if (rotor3_pos == 5'd16) begin
                        if (rotor2_pos == 5'd25)
                            rotor2_pos <= 0;
                        else
                            rotor2_pos <= rotor2_pos + 1;
                    end

                    // Step rotor1 at rotor2 notch (E = index 4)
                    if (rotor2_pos == 5'd4) begin
                        if (rotor1_pos == 5'd25)
                            rotor1_pos <= 0;
                        else
                            rotor1_pos <= rotor1_pos + 1;
                    end

                    state <= LATCH;
                end

                LATCH: begin
                    latched_char <= ascii_in - "A";  // Convert ASCII to 0-25
                    state <= ENCRYPT;
                end

                ENCRYPT: begin
                    state <= WAIT;
                end

                WAIT: begin
                    if (v_r3r)
                        state <= OUTPUT;
                end

                OUTPUT: begin
                    ascii_out <= r3r_out + "A";  // Convert 0-25 to ASCII
                    valid_out <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

    // FORWARD ROTORS
    rotor3 r3 (
        .clk(clk),
        .in_char(latched_char),
        .offset(rotor3_pos),
        .reverse(1'b0),
        .valid_in(state == ENCRYPT),
        .out_char(r3_out),
        .valid_out(v_r3)
    );

    rotor2 r2 (
        .clk(clk),
        .in_char(r3_out),
        .offset(rotor2_pos),
        .reverse(1'b0),
        .valid_in(v_r3),
        .out_char(r2_out),
        .valid_out(v_r2)
    );

    rotor1 r1 (
        .clk(clk),
        .in_char(r2_out),
        .offset(rotor1_pos),
        .reverse(1'b0),
        .valid_in(v_r2),
        .out_char(r1_out),
        .valid_out(v_r1)
    );

    // REFLECTOR
    reflector ref (
        .clk(clk),
        .in_char(r1_out),
        .valid_in(v_r1),
        .out_char(ref_out),
        .valid_out(v_ref)
    );

    // BACKWARD ROTORS
    rotor1 r1r (
        .clk(clk),
        .in_char(ref_out),
        .offset(rotor1_pos),
        .reverse(1'b1),
        .valid_in(v_ref),
        .out_char(r1r_out),
        .valid_out(v_r1r)
    );

    rotor2 r2r (
        .clk(clk),
        .in_char(r1r_out),
        .offset(rotor2_pos),
        .reverse(1'b1),
        .valid_in(v_r1r),
        .out_char(r2r_out),
        .valid_out(v_r2r)
    );

    rotor3 r3r (
        .clk(clk),
        .in_char(r2r_out),
        .offset(rotor3_pos),
        .reverse(1'b1),
        .valid_in(v_r2r),
        .out_char(r3r_out),
        .valid_out(v_r3r)
    );

endmodule
