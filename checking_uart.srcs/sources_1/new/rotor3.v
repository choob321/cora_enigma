`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 23:23:42
// Design Name: 
// Module Name: rotor3
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


module rotor3 (
    input wire clk,
    input wire [4:0] in_char,
    input wire [4:0] offset,
    input wire reverse,
    input wire valid_in,
    output reg [4:0] out_char,
    output reg valid_out
);
    reg [4:0] forward_map [0:25];
    reg [4:0] reverse_map [0:25]; // <-- New reverse map

    initial begin
        // Rotor III: BDFHJLCPRTXVZNYEIWGAKMUSQO
        forward_map[ 0] = 5'd1;   // A -> B
        forward_map[ 1] = 5'd3;   // B -> D
        forward_map[ 2] = 5'd5;   // C -> F
        forward_map[ 3] = 5'd7;   // D -> H
        forward_map[ 4] = 5'd9;   // E -> J
        forward_map[ 5] = 5'd11;  // F -> L
        forward_map[ 6] = 5'd2;   // G -> C
        forward_map[ 7] = 5'd15;  // H -> P
        forward_map[ 8] = 5'd17;  // I -> R
        forward_map[ 9] = 5'd19;  // J -> T
        forward_map[10] = 5'd23;  // K -> X
        forward_map[11] = 5'd21;  // L -> V
        forward_map[12] = 5'd25;  // M -> Z
        forward_map[13] = 5'd13;  // N -> N
        forward_map[14] = 5'd24;  // O -> Y
        forward_map[15] = 5'd4;   // P -> E
        forward_map[16] = 5'd8;   // Q -> I
        forward_map[17] = 5'd22;  // R -> W
        forward_map[18] = 5'd6;   // S -> G
        forward_map[19] = 5'd0;   // T -> A
        forward_map[20] = 5'd10;  // U -> K
        forward_map[21] = 5'd12;  // V -> M
        forward_map[22] = 5'd20;  // W -> U
        forward_map[23] = 5'd18;  // X -> S
        forward_map[24] = 5'd16;  // Y -> Q
        forward_map[25] = 5'd14;  // Z -> O

        // Reverse map (inverting forward map)
        reverse_map[ 1] = 5'd0;   // B -> A
        reverse_map[ 3] = 5'd1;   // D -> B
        reverse_map[ 5] = 5'd2;   // F -> C
        reverse_map[ 7] = 5'd3;   // H -> D
        reverse_map[ 9] = 5'd4;   // J -> E
        reverse_map[11] = 5'd5;   // L -> F
        reverse_map[ 2] = 5'd6;   // C -> G
        reverse_map[15] = 5'd7;   // P -> H
        reverse_map[17] = 5'd8;   // R -> I
        reverse_map[19] = 5'd9;   // T -> J
        reverse_map[23] = 5'd10;  // X -> K
        reverse_map[21] = 5'd11;  // V -> L
        reverse_map[25] = 5'd12;  // Z -> M
        reverse_map[13] = 5'd13;  // N -> N
        reverse_map[24] = 5'd14;  // Y -> O
        reverse_map[ 4] = 5'd15;  // E -> P
        reverse_map[ 8] = 5'd16;  // I -> Q
        reverse_map[22] = 5'd17;  // W -> R
        reverse_map[ 6] = 5'd18;  // G -> S
        reverse_map[ 0] = 5'd19;  // A -> T
        reverse_map[10] = 5'd20;  // K -> U
        reverse_map[12] = 5'd21;  // M -> V
        reverse_map[20] = 5'd22;  // U -> W
        reverse_map[18] = 5'd23;  // S -> X
        reverse_map[16] = 5'd24;  // Q -> Y
        reverse_map[14] = 5'd25;  // O -> Z
    end

    reg [4:0] shifted_in, mapped_char, unshifted_out;

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in) begin
            shifted_in = in_char + offset;
            if (shifted_in >= 26) shifted_in = shifted_in - 26;

            if (!reverse) begin
                mapped_char = forward_map[shifted_in];
            end else begin
                mapped_char = reverse_map[shifted_in];
            end

            //unshifted_out = mapped_char + (26 - offset);
            //if (unshifted_out >= 26) unshifted_out = unshifted_out - 26;
            
            if (mapped_char < offset)
                unshifted_out = mapped_char + 26 - offset;
            else 
                unshifted_out = mapped_char - offset;
            
            out_char <= unshifted_out;
        end
    end
endmodule
