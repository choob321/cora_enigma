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
    reg [4:0] reflect_map [0:25];

    initial begin
        // Reflector B: YRUHQSLDPXNGOKMIEBFZCWVJAT
        reflect_map[ 0] = 5'd24;  // A -> Y
        reflect_map[ 1] = 5'd17;
        reflect_map[ 2] = 5'd20;
        reflect_map[ 3] = 5'd7;
        reflect_map[ 4] = 5'd16;
        reflect_map[ 5] = 5'd18;
        reflect_map[ 6] = 5'd11;
        reflect_map[ 7] = 5'd3;
        reflect_map[ 8] = 5'd15;
        reflect_map[ 9] = 5'd23;
        reflect_map[10] = 5'd13;
        reflect_map[11] = 5'd6;
        reflect_map[12] = 5'd14;
        reflect_map[13] = 5'd10;
        reflect_map[14] = 5'd12;
        reflect_map[15] = 5'd8;
        reflect_map[16] = 5'd4;
        reflect_map[17] = 5'd1;
        reflect_map[18] = 5'd5;
        reflect_map[19] = 5'd25;
        reflect_map[20] = 5'd2;
        reflect_map[21] = 5'd22;
        reflect_map[22] = 5'd21;
        reflect_map[23] = 5'd9;
        reflect_map[24] = 5'd0;
        reflect_map[25] = 5'd19;
    end

    always @(posedge clk) begin
        valid_out <= valid_in;
        if (valid_in)
            out_char <= reflect_map[in_char];
    end
endmodule

