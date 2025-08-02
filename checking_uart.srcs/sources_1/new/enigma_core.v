`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.07.2025 22:39:47
// Design Name: 
// Module Name: enigma_core
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


module enigma_core (
    input wire clk,
    input wire [7:0] char_in,
    input wire valid_in,
    output reg [7:0] char_out,
    output reg valid_out
);

    reg [4:0] pos1 = 0, pos2 = 0, pos3 = 0;
    wire [4:0] index_in;
    wire [4:0] step1_out, step2_out, step3_out, refl_out;
    wire [4:0] rev3_out, rev2_out, rev1_out;
    reg [4:0] result;

    assign index_in = (char_in >= "A" && char_in <= "Z") ? (char_in - "A") :
                      (char_in >= "a" && char_in <= "z") ? (char_in - "a") : 0;

    rotor1 r1 (.char_in(index_in), .offset(pos1), .char_out(step1_out), .reverse_in(rev1_out), .reverse_out());
    rotor2 r2 (.char_in(step1_out), .offset(pos2), .char_out(step2_out), .reverse_in(rev2_out), .reverse_out());
    rotor3 r3 (.char_in(step2_out), .offset(pos3), .char_out(step3_out), .reverse_in(rev3_out), .reverse_out());

    reflector refl (.char_in(step3_out), .char_out(refl_out));

    rotor3 r3_rev (.char_in(), .offset(pos3), .char_out(), .reverse_in(refl_out), .reverse_out(rev3_out));
    rotor2 r2_rev (.char_in(), .offset(pos2), .char_out(), .reverse_in(rev3_out), .reverse_out(rev2_out));
    rotor1 r1_rev (.char_in(), .offset(pos1), .char_out(), .reverse_in(rev2_out), .reverse_out(rev1_out));

    always @(posedge clk) begin
        valid_out <= 0;
        if (valid_in && char_in >= "A" && char_in <= "Z") begin
            // Stepping logic: right rotor steps every keypress, others as needed
            pos1 <= pos1 + 1;
            if (pos1 == 25)
                pos2 <= pos2 + 1;
            if (pos2 == 25 && pos1 == 25)
                pos3 <= pos3 + 1;

            result <= rev1_out;
            char_out <= result + "A";
            valid_out <= 1;
        end
    end
endmodule
