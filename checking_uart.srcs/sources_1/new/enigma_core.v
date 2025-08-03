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
    input wire reset,  // unused, but required by top.v
    input wire [7:0] ascii_in,
    input wire valid_in,
    output reg [7:0] ascii_out,
    output reg valid_out
);
    // Rotor positions
    reg [4:0] rotor1_pos = 0;
    reg [4:0] rotor2_pos = 0;
    reg [4:0] rotor3_pos = 0;

    // Internal wires
    wire [4:0] stage0_in = ascii_in - "A";  // Convert ASCII to 0-25
    wire [4:0] r3_out, r2_out, r1_out;
    wire [4:0] ref_out, r1_rev, r2_rev, r3_rev;

    wire v_r3_fwd, v_r2_fwd, v_r1_fwd, v_ref, v_r1_rev, v_r2_rev, v_r3_rev;

    // Rotor stepping: done BEFORE encryption (i.e., when valid_in)
    always @(posedge clk) begin
        if (valid_in) begin
            // Advance rotor3 every key press
            rotor3_pos <= (rotor3_pos == 5'd25) ? 5'd0 : rotor3_pos + 1;

            // Rotor2 steps when rotor3 is at notch (Q = index 16)
            if (rotor3_pos == 5'd16)
                rotor2_pos <= (rotor2_pos == 5'd25) ? 5'd0 : rotor2_pos + 1;

            // Rotor1 steps when rotor2 is at notch (E = index 4)
            if (rotor2_pos == 5'd4)
                rotor1_pos <= (rotor1_pos == 5'd25) ? 5'd0 : rotor1_pos + 1;
        end
    end

    // Pipeline: Forward path
    rotor3 r3(.clk(clk), .in_char(stage0_in), .offset(rotor3_pos), .reverse(1'b0), .valid_in(valid_in), .out_char(r3_out), .valid_out(v_r3_fwd));
    rotor2 r2(.clk(clk), .in_char(r3_out), .offset(rotor2_pos), .reverse(1'b0), .valid_in(v_r3_fwd), .out_char(r2_out), .valid_out(v_r2_fwd));
    rotor1 r1(.clk(clk), .in_char(r2_out), .offset(rotor1_pos), .reverse(1'b0), .valid_in(v_r2_fwd), .out_char(r1_out), .valid_out(v_r1_fwd));

    // Reflector
    reflector ref(.clk(clk), .in_char(r1_out), .valid_in(v_r1_fwd), .out_char(ref_out), .valid_out(v_ref));

    // Reverse path
    rotor1 r1r(.clk(clk), .in_char(ref_out), .offset(rotor1_pos), .reverse(1'b1), .valid_in(v_ref), .out_char(r1_rev), .valid_out(v_r1_rev));
    rotor2 r2r(.clk(clk), .in_char(r1_rev), .offset(rotor2_pos), .reverse(1'b1), .valid_in(v_r1_rev), .out_char(r2_rev), .valid_out(v_r2_rev));
    rotor3 r3r(.clk(clk), .in_char(r2_rev), .offset(rotor3_pos), .reverse(1'b1), .valid_in(v_r2_rev), .out_char(r3_rev), .valid_out(v_r3_rev));

    // Output register
    always @(posedge clk) begin
        valid_out <= v_r3_rev;
        if (v_r3_rev) begin
            ascii_out <= r3_rev + "A";  // Convert back to ASCII
        end
    end
endmodule

