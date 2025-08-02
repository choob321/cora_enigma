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
    input wire [4:0] char_in,
    output reg [4:0] char_out
);
    reg [4:0] refl_map [0:25];

    initial begin
        refl_map[ 0]=24; refl_map[ 1]=17; refl_map[ 2]=20; refl_map[ 3]=7;  refl_map[ 4]=16;
        refl_map[ 5]=18; refl_map[ 6]=11; refl_map[ 7]=3;  refl_map[ 8]=15; refl_map[ 9]=23;
        refl_map[10]=13; refl_map[11]=6;  refl_map[12]=14; refl_map[13]=10; refl_map[14]=12;
        refl_map[15]=8;  refl_map[16]=4;  refl_map[17]=1;  refl_map[18]=5;  refl_map[19]=25;
        refl_map[20]=2;  refl_map[21]=22; refl_map[22]=21; refl_map[23]=9;  refl_map[24]=0;
        refl_map[25]=19;
    end

    always @(*) begin
        char_out = refl_map[char_in];
    end
endmodule

