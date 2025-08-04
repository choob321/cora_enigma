`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 23:23:23
// Design Name: 
// Module Name: rotor2
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


module rotor2 (
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
        // Rotor II: AJDKSIRUXBLHWTMCQGZNPYFVOE
        //AJDKSIRUXBLHWTMCQGZNPYFVOE
        //AJDKS IRUXB LHWTM CQGZN PYFVOE
        //01234 56789 01234 56789 012345
        //ABCDE FGHIJ KLMNO PQRST UVWXYZ
        forward_map[ 0] = 5'd0;   // A -> A
        forward_map[ 1] = 5'd9;   // B -> J
        forward_map[ 2] = 5'd3;   // C -> D
        forward_map[ 3] = 5'd10;  // D -> K
        forward_map[ 4] = 5'd18;  // E -> S
        forward_map[ 5] = 5'd8;   // F -> I
        forward_map[ 6] = 5'd17;  // G -> R
        forward_map[ 7] = 5'd20;  // H -> U
        forward_map[ 8] = 5'd23;  // I -> X
        forward_map[ 9] = 5'd1;   // J -> B
        forward_map[10] = 5'd11;  // K -> L
        forward_map[11] = 5'd7;   // L -> H
        //
        forward_map[12] = 5'd22;  // M -> W
        forward_map[13] = 5'd19;  // N -> T
        forward_map[14] = 5'd12;   // O -> M
        forward_map[15] = 5'd2;  // P -> C
        forward_map[16] = 5'd16;   // Q -> Q
        forward_map[17] = 5'd6;  // R -> G
        forward_map[18] = 5'd25;  // S -> Z
        forward_map[19] = 5'd13;  // T -> N
        forward_map[20] = 5'd15;   // U -> P
        forward_map[21] = 5'd24;  // V -> Y
        forward_map[22] = 5'd5;  // W -> F
        forward_map[23] = 5'd21;   // X -> V
        forward_map[24] = 5'd14;  // Y -> O
        forward_map[25] = 5'd4;  // Z -> E

        // Now define reverse_map based on forward_map
        
        //AJDKS IRUXB LHWTM CQGZN PYFVOE
        //01234 56789 01234 56789 012345
        //ABCDE FGHIJ KLMNO PQRST UVWXYZ
        
        reverse_map[ 0] = 5'd0;   // A <- A
        reverse_map[ 1] = 5'd9;   // B <- J
        reverse_map[ 2] = 5'd15;  // C <- O
        reverse_map[ 3] = 5'd2;   // D <- C
        reverse_map[ 4] = 5'd25;  // E <- X
        reverse_map[ 5] = 5'd22;  // F <- U
        reverse_map[ 6] = 5'd17;  // G <- Q
        reverse_map[ 7] = 5'd11;  // H <- L
        reverse_map[ 8] = 5'd5;   // I <- F
        reverse_map[ 9] = 5'd1;   // J <- B
        reverse_map[10] = 5'd3;   // K <- D
        reverse_map[11] = 5'd10;  // L <- K
        reverse_map[12] = 5'd14;  // M <- N
        reverse_map[13] = 5'd19;  // N <- S
        reverse_map[14] = 5'd24;  // O <- W
        reverse_map[15] = 5'd20;  // P <- P
        reverse_map[16] = 5'd16;  // Q <- Z
        reverse_map[17] = 5'd6;   // R <- G
        reverse_map[18] = 5'd4;   // S <- E
        reverse_map[19] = 5'd13;  // T <- M
        reverse_map[20] = 5'd7;   // U <- H
        reverse_map[21] = 5'd23;  // V <- V
        reverse_map[22] = 5'd12;  // W <- Y
        reverse_map[23] = 5'd8;   // X <- I
        reverse_map[24] = 5'd21;  // Y <- T
        reverse_map[25] = 5'd18;  // Z <- R
    end

    reg [4:0] shifted_in, mapped_char, unshifted_out;

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in) begin
            shifted_in = in_char + offset;
            if (shifted_in >= 26) shifted_in = shifted_in - 26;

            if (!reverse)
                mapped_char = forward_map[shifted_in];
            else
                mapped_char = reverse_map[shifted_in];

            if (mapped_char < offset)
                unshifted_out = mapped_char + 26 - offset;
            else
                unshifted_out = mapped_char - offset;

            out_char <= unshifted_out;
        end
    end
endmodule
