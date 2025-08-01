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
    input wire [7:0] char_in,
    input wire valid_in,
    output reg [7:0] char_out,
    output reg valid_out
);
    wire [4:0] c0, c1, c2, c3, c4, c5, c6;
    reg [4:0] r1_pos = 0, r2_pos = 0, r3_pos = 0;
    wire [4:0] step_pos1, step_pos2, step_pos3;

    assign step_pos3 = (r3_pos + 1) % 26;
    assign step_pos2 = (r3_pos == 21) ? (r2_pos + 1) % 26 : r2_pos;
    assign step_pos1 = ((r2_pos == 4) && (r3_pos == 21)) ? (r1_pos + 1) % 26 : r1_pos;

    rotor3 r3_fwd (.in_char(char_in[4:0]), .reverse(0), .position(r3_pos), .out_char(c0));
    rotor2 r2_fwd (.in_char(c0), .reverse(0), .position(r2_pos), .out_char(c1));
    rotor1 r1_fwd (.in_char(c1), .reverse(0), .position(r1_pos), .out_char(c2));
    reflector refl (.char_in(c2), .char_out(c3));
    rotor1 r1_rev (.in_char(c3), .reverse(1), .position(r1_pos), .out_char(c4));
    rotor2 r2_rev (.in_char(c4), .reverse(1), .position(r2_pos), .out_char(c5));
    rotor3 r3_rev (.in_char(c5), .reverse(1), .position(r3_pos), .out_char(c6));

    always @(posedge clk) begin
        valid_out <= 0;
        if (valid_in) begin
            r3_pos <= step_pos3;
            r2_pos <= step_pos2;
            r1_pos <= step_pos1;
            char_out <= c6 + 8'd65; // padded to 8-bit ASCII range
            valid_out <= 1;
        end
    end
endmodule
