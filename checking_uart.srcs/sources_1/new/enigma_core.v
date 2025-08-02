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
    // Rotor positions
    reg [4:0] rotor1_pos = 0;
    reg [4:0] rotor2_pos = 0;
    reg [4:0] rotor3_pos = 0;

    // Flags for stepping
    wire rotor3_step = valid_in;
    wire rotor2_step = (rotor3_pos == 5'd21) && rotor3_step; // Rotor III notch at V (pos 21)
    wire rotor1_step = (rotor2_pos == 5'd4) && rotor2_step;  // Rotor II notch at E (pos 4)

    // Pipeline stage registers
    reg [4:0] stage1_char;
    reg [4:0] stage2_char;
    reg [4:0] stage3_char;
    reg [4:0] stage4_char;
    reg [4:0] stage5_char;
    reg [4:0] stage6_char;
    reg [4:0] stage7_char;

    wire [4:0] rotor3_out_fwd, rotor2_out_fwd, rotor1_out_fwd;
    wire [4:0] reflector_out;
    wire [4:0] rotor1_out_rev, rotor2_out_rev, rotor3_out_rev;

    wire [4:0] ascii_index = ascii_in - 8'd65;

    // Instantiate rotors and reflector
    rotor3 u_r3_fwd (.in_char(stage1_char), .offset(rotor3_pos), .reverse(1'b0), .out_char(rotor3_out_fwd));
    rotor2 u_r2_fwd (.in_char(stage2_char), .offset(rotor2_pos), .reverse(1'b0), .out_char(rotor2_out_fwd));
    rotor1 u_r1_fwd (.in_char(stage3_char), .offset(rotor1_pos), .reverse(1'b0), .out_char(rotor1_out_fwd));

    reflector u_reflector (.in_char(stage4_char), .out_char(reflector_out));

    rotor1 u_r1_rev (.in_char(stage5_char), .offset(rotor1_pos), .reverse(1'b1), .out_char(rotor1_out_rev));
    rotor2 u_r2_rev (.in_char(stage6_char), .offset(rotor2_pos), .reverse(1'b1), .out_char(rotor2_out_rev));
    rotor3 u_r3_rev (.in_char(stage7_char), .offset(rotor3_pos), .reverse(1'b1), .out_char(rotor3_out_rev));

    // Rotor stepping logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rotor1_pos <= 0;
            rotor2_pos <= 0;
            rotor3_pos <= 0;
        end else if (valid_in) begin
            // Advance rotor3 every key press
            if (rotor3_pos == 5'd25)
                rotor3_pos <= 0;
            else
                rotor3_pos <= rotor3_pos + 1;

            // Step rotor2 if rotor3 at notch
            if (rotor2_step) begin
                if (rotor2_pos == 5'd25)
                    rotor2_pos <= 0;
                else
                    rotor2_pos <= rotor2_pos + 1;
            end

            // Step rotor1 if rotor2 at notch
            if (rotor1_step) begin
                if (rotor1_pos == 5'd25)
                    rotor1_pos <= 0;
                else
                    rotor1_pos <= rotor1_pos + 1;
            end
        end
    end

    // Pipelined signal path
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_char <= 0;
            stage2_char <= 0;
            stage3_char <= 0;
            stage4_char <= 0;
            stage5_char <= 0;
            stage6_char <= 0;
            stage7_char <= 0;
            ascii_out <= 8'd0;
            valid_out <= 0;
        end else begin
            if (valid_in && ascii_in >= 8'd65 && ascii_in <= 8'd90) begin // Only uppercase A–Z
                stage1_char <= ascii_index;
            end else begin
                stage1_char <= 0;
            end

            stage2_char <= rotor3_out_fwd;
            stage3_char <= rotor2_out_fwd;
            stage4_char <= rotor1_out_fwd;
            stage5_char <= reflector_out;
            stage6_char <= rotor1_out_rev;
            stage7_char <= rotor2_out_rev;

            ascii_out <= rotor3_out_rev + 8'd65;
            valid_out <= valid_in;
        end
    end
endmodule
