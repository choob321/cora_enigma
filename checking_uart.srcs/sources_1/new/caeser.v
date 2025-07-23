`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 14:16:23
// Design Name: 
// Module Name: caeser
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


module caeser (
    input wire [7:0] char_in,
    output reg [7:0] char_out
);
    parameter SHIFT = 3;

    always @(*) begin
        // Encrypt only uppercase letters A-Z (ASCII 65–90)
        if (char_in >= "A" && char_in <= "Z")
            char_out = ((char_in - "A" + SHIFT) % 26) + "A";
        // Encrypt only lowercase letters a–z (ASCII 97–122)
        else if (char_in >= "a" && char_in <= "z")
            char_out = ((char_in - "a" + SHIFT) % 26) + "a";
        else
            char_out = char_in; // Leave digits/punctuation unchanged
    end
endmodule