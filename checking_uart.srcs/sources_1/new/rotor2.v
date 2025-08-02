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
    input wire [4:0] offset,
    input wire reverse,
    output reg [4:0] out_char
);
    reg [4:0] forward_map [0:25];
    reg [4:0] backward_map [0:25];

    wire [5:0] shifted_in = in_char + offset;
    wire [4:0] shifted_index = (shifted_in > 25) ? shifted_in - 26 : shifted_in;
    wire [4:0] raw_out = reverse ? backward_map[shifted_index] : forward_map[shifted_index];

    wire [5:0] unshifted_out = raw_out + (26 - offset);
    wire [4:0] final_out = (unshifted_out > 25) ? unshifted_out - 26 : unshifted_out[4:0];

    always @(*) begin
        out_char = final_out;
    end

    initial begin
        forward_map[ 0] = 5'd0;  // A?A
        forward_map[ 1] = 5'd9;  // B?J
        forward_map[ 2] = 5'd3;
        forward_map[ 3] = 5'd10;
        forward_map[ 4] = 5'd18;
        forward_map[ 5] = 5'd8;
        forward_map[ 6] = 5'd17;
        forward_map[ 7] = 5'd20;
        forward_map[ 8] = 5'd23;
        forward_map[ 9] = 5'd1;
        forward_map[10] = 5'd11;
        forward_map[11] = 5'd7;
        forward_map[12] = 5'd22;
        forward_map[13] = 5'd19;
        forward_map[14] = 5'd12;
        forward_map[15] = 5'd2;
        forward_map[16] = 5'd16;
        forward_map[17] = 5'd6;
        forward_map[18] = 5'd25;
        forward_map[19] = 5'd13;
        forward_map[20] = 5'd5;
        forward_map[21] = 5'd21;
        forward_map[22] = 5'd14;
        forward_map[23] = 5'd4;
        forward_map[24] = 5'd24;
        forward_map[25] = 5'd15;

        backward_map[ 0] = 5'd0;
        backward_map[ 9] = 5'd1;
        backward_map[15] = 5'd2;
        backward_map[2]  = 5'd3;
        backward_map[23] = 5'd4;
        backward_map[20] = 5'd5;
        backward_map[17] = 5'd6;
        backward_map[11] = 5'd7;
        backward_map[5]  = 5'd8;
        backward_map[3]  = 5'd9;
        backward_map[1]  = 5'd10;
        backward_map[10] = 5'd11;
        backward_map[14] = 5'd12;
        backward_map[19] = 5'd13;
        backward_map[22] = 5'd14;
        backward_map[25] = 5'd15;
        backward_map[16] = 5'd16;
        backward_map[6]  = 5'd17;
        backward_map[4]  = 5'd18;
        backward_map[13] = 5'd19;
        backward_map[7]  = 5'd20;
        backward_map[21] = 5'd21;
        backward_map[12] = 5'd22;
        backward_map[8]  = 5'd23;
        backward_map[24] = 5'd24;
        backward_map[18] = 5'd25;
    end
endmodule
