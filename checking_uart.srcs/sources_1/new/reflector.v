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

    // Reflector B wiring: YRUHQSLDPXNGOKMIEBFZCWVJAT
    always @(*) begin
        case (char_in)
            5'd0:  char_out = 5'd24; // A ? Y
            5'd1:  char_out = 5'd17; // B ? R
            5'd2:  char_out = 5'd20; // C ? U
            5'd3:  char_out = 5'd7;  // D ? H
            5'd4:  char_out = 5'd16; // E ? Q
            5'd5:  char_out = 5'd18; // F ? S
            5'd6:  char_out = 5'd11; // G ? L
            5'd7:  char_out = 5'd3;  // H ? D
            5'd8:  char_out = 5'd15; // I ? P
            5'd9:  char_out = 5'd23; // J ? X
            5'd10: char_out = 5'd13; // K ? N
            5'd11: char_out = 5'd6;  // L ? G
            5'd12: char_out = 5'd14; // M ? O
            5'd13: char_out = 5'd10; // N ? K
            5'd14: char_out = 5'd12; // O ? M
            5'd15: char_out = 5'd8;  // P ? I
            5'd16: char_out = 5'd4;  // Q ? E
            5'd17: char_out = 5'd1;  // R ? B
            5'd18: char_out = 5'd5;  // S ? F
            5'd19: char_out = 5'd25; // T ? Z
            5'd20: char_out = 5'd2;  // U ? C
            5'd21: char_out = 5'd22; // V ? W
            5'd22: char_out = 5'd21; // W ? V
            5'd23: char_out = 5'd9;  // X ? J
            5'd24: char_out = 5'd0;  // Y ? A
            5'd25: char_out = 5'd19; // Z ? T
            default: char_out = 5'd0;
        endcase
    end

endmodule

