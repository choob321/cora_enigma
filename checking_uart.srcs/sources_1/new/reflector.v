`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 23:24:04
// Design Name: 
// Module Name: reflector
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


module reflector (
    input wire clk,
    input wire [4:0] in_char,
    input wire valid_in,
    output reg [4:0] out_char,
    output reg valid_out
);
    reg [4:0] map [0:25];

    always @(*) begin
        // Reflector B: YRUHQSLDPXNGOKMIEBFZCWVJAT
        map[ 0] = 5'd24; // A ? Y
        map[ 1] = 5'd17; // B ? R
        map[ 2] = 5'd20; // C ? U
        map[ 3] = 5'd7;  // D ? H
        map[ 4] = 5'd16; // E ? Q
        map[ 5] = 5'd18; // F ? S
        map[ 6] = 5'd11; // G ? L
        map[ 7] = 5'd3;  // H ? D
        map[ 8] = 5'd15; // I ? P
        map[ 9] = 5'd23; // J ? X
        map[10] = 5'd13; // K ? N
        map[11] = 5'd6;  // L ? G
        map[12] = 5'd14; // M ? O
        map[13] = 5'd10; // N ? K
        map[14] = 5'd12; // O ? M
        map[15] = 5'd8;  // P ? I
        map[16] = 5'd4;  // Q ? E
        map[17] = 5'd1;  // R ? B
        map[18] = 5'd5;  // S ? F
        map[19] = 5'd25; // T ? Z
        map[20] = 5'd2;  // U ? C
        map[21] = 5'd22; // V ? W
        map[22] = 5'd21; // W ? V
        map[23] = 5'd9;  // X ? J
        map[24] = 5'd0;  // Y ? A
        map[25] = 5'd19; // Z ? T
    end

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in)
            out_char <= map[in_char];
    end
endmodule
