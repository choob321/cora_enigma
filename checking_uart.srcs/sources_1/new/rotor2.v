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
    input wire [4:0] char_in,
    input wire [4:0] offset,
    output reg [4:0] char_out,
    input wire [4:0] reverse_in,
    output reg [4:0] reverse_out
);
    reg [4:0] forward_map [0:25];
    reg [4:0] reverse_map [0:25];
    integer i;

    initial begin
        forward_map[ 0]=0;  forward_map[ 1]=9;  forward_map[ 2]=3;  forward_map[ 3]=10; forward_map[ 4]=18;
        forward_map[ 5]=8;  forward_map[ 6]=17; forward_map[ 7]=20; forward_map[ 8]=23; forward_map[ 9]=1;
        forward_map[10]=11; forward_map[11]=7;  forward_map[12]=22; forward_map[13]=19; forward_map[14]=12;
        forward_map[15]=2;  forward_map[16]=16; forward_map[17]=6;  forward_map[18]=25; forward_map[19]=13;
        forward_map[20]=15; forward_map[21]=24; forward_map[22]=5;  forward_map[23]=21; forward_map[24]=14;
        forward_map[25]=4;

        for (i = 0; i < 26; i = i + 1)
            reverse_map[forward_map[i]] = i;
    end

    always @(*) begin
        char_out = (forward_map[(char_in + offset) % 26] + (26 - offset)) % 26;
        reverse_out = (reverse_map[(reverse_in + offset) % 26] + (26 - offset)) % 26;
    end
endmodule

