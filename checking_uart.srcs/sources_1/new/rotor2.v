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
    input wire [4:0] in_char,
    input wire reverse,
    input wire [4:0] position,
    output reg [4:0] out_char
);

    reg [4:0] forward_map [0:25];
    
    integer i;

    initial begin
        // Rotor II: AJDKSIRUXBLHWTMCQGZNPYFVOE
        forward_map[0] = 5'd0;   // A -> A
        forward_map[1] = 5'd9;   // B -> J
        forward_map[2] = 5'd3;   // C -> D
        forward_map[3] = 5'd10;  // D -> K
        forward_map[4] = 5'd18;  // E -> S
        
        forward_map[5] = 5'd8;   // F -> G
        forward_map[6] = 5'd17;  // G -> D
        forward_map[7] = 5'd20;  // H -> Q
        forward_map[8] = 5'd23;   // I -> V
        forward_map[9] = 5'd1;  // J -> Z
        
        forward_map[10] = 5'd11;   // K -> N
        forward_map[11] = 5'd7;  // L -> T
        forward_map[12] = 5'd22;  // M -> O
        forward_map[13] = 5'd19;   // N -> W
        forward_map[14] = 5'd12;  // O -> Y
        
        forward_map[15] = 5'd2;   // P -> H
        forward_map[16] = 5'd16;  // Q -> X
        forward_map[17] = 5'd6;  // R -> U
        forward_map[18] = 5'd25;   // S -> S
        forward_map[19] = 5'd13;  // T -> P
        
        forward_map[20] = 5'd15;   // U -> A
        forward_map[21] = 5'd24;  // V -> I
        forward_map[22] = 5'd5;  // W -> B
        forward_map[23] = 5'd21;   // X -> R
        forward_map[24] = 5'd14;  // Y -> C
        forward_map[25] = 5'd4;   // Z -> J

    end

    //reg [4:0] temp, adjusted_in, adjusted_out;

    always @(*) begin
        if (!reverse) begin
            out_char = (forward_map[(in_char + position) % 26] + 26 - position) % 26;
        end else begin
            for (i = 0; i < 26; i = i + 1) begin
                if (forward_map[i] == (in_char + position) % 26)
                    out_char = (i + 26 - position) % 26;
            end
        end
    end
endmodule
