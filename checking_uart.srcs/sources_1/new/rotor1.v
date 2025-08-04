`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 23:23:01
// Design Name: 
// Module Name: rotor1
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


module rotor1 (
    input wire clk,
    input wire [4:0] in_char,
    input wire [4:0] offset,
    input wire reverse,
    input wire valid_in,
    output reg [4:0] out_char,
    output reg valid_out
);
    reg [4:0] forward_map [0:25];
    reg [4:0] reverse_map [0:25];

    initial begin
        // Rotor I: EKMFLGDQVZNTOWYHXUSPAIBRCJ
        forward_map[ 0] = 5'd4;   // A -> E
        forward_map[ 1] = 5'd10;  // B -> K
        forward_map[ 2] = 5'd12;  // C -> M
        forward_map[ 3] = 5'd5;   // D -> F
        forward_map[ 4] = 5'd11;  // E -> L
        forward_map[ 5] = 5'd6;   // F -> G
        forward_map[ 6] = 5'd3;   // G -> D
        forward_map[ 7] = 5'd16;  // H -> Q
        forward_map[ 8] = 5'd21;  // I -> V
        forward_map[ 9] = 5'd25;  // J -> Z
        forward_map[10] = 5'd13;  // K -> N
        forward_map[11] = 5'd19;  // L -> T
        forward_map[12] = 5'd14;  // M -> O
        forward_map[13] = 5'd22;  // N -> W
        forward_map[14] = 5'd24;  // O -> Y
        forward_map[15] = 5'd7;   // P -> H
        forward_map[16] = 5'd23;  // Q -> X
        forward_map[17] = 5'd20;  // R -> U
        forward_map[18] = 5'd18;  // S -> S
        forward_map[19] = 5'd15;  // T -> P
        forward_map[20] = 5'd0;   // U -> A
        forward_map[21] = 5'd8;   // V -> I
        forward_map[22] = 5'd1;   // W -> B
        forward_map[23] = 5'd17;  // X -> R
        forward_map[24] = 5'd2;   // Y -> C
        forward_map[25] = 5'd9;   // Z -> J

        // Reverse map: inverse of forward map
        reverse_map[ 4] = 5'd0;
        reverse_map[10] = 5'd1;
        reverse_map[12] = 5'd2;
        reverse_map[ 5] = 5'd3;
        reverse_map[11] = 5'd4;
        reverse_map[ 6] = 5'd5;
        reverse_map[ 3] = 5'd6;
        reverse_map[16] = 5'd7;
        reverse_map[21] = 5'd8;
        reverse_map[25] = 5'd9;
        reverse_map[13] = 5'd10;
        reverse_map[19] = 5'd11;
        reverse_map[14] = 5'd12;
        reverse_map[22] = 5'd13;
        reverse_map[24] = 5'd14;
        reverse_map[ 7] = 5'd15;
        reverse_map[23] = 5'd16;
        reverse_map[20] = 5'd17;
        reverse_map[18] = 5'd18;
        reverse_map[15] = 5'd19;
        reverse_map[ 0] = 5'd20;
        reverse_map[ 8] = 5'd21;
        reverse_map[ 1] = 5'd22;
        reverse_map[17] = 5'd23;
        reverse_map[ 2] = 5'd24;
        reverse_map[ 9] = 5'd25;
    end

    reg [4:0] shifted_in;
    reg [4:0] mapped_char;
    reg [4:0] unshifted_out;

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in) begin
            // Apply rotor offset
            shifted_in = in_char + offset;
            if (shifted_in >= 26) shifted_in = shifted_in - 26;

            // Use forward or reverse map
            if (!reverse) begin
                mapped_char = forward_map[shifted_in];
            end else begin
                mapped_char = reverse_map[shifted_in];
            end

            if (mapped_char < offset)
                unshifted_out = mapped_char + 26 - offset;
            else 
                unshifted_out = mapped_char - offset;

            out_char <= unshifted_out;
        end
    end
endmodule
