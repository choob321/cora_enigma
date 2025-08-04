`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2025 10:10:10
// Design Name: 
// Module Name: enigma_core_tb
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


`timescale 1ns / 1ps

module enigma_core_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] ascii_in;
    reg valid_in;

    // Outputs
    wire [7:0] ascii_out;
    wire valid_out;

    // Instantiate the DUT
    enigma_core uut (
        .clk(clk),
        .reset(reset),
        .ascii_in(ascii_in),
        .valid_in(valid_in),
        .ascii_out(ascii_out),
        .valid_out(valid_out)
    );

    // Clock generation: 10ns period = 100MHz
    always #5 clk = ~clk;

    // Task to send a single character
    task send_char(input [7:0] ch);
    begin
        @(posedge clk);
        ascii_in <= ch;
        valid_in <= 1;
        @(posedge clk);
        valid_in <= 0;
        wait (valid_out == 1);
        $display("Encrypted '%s' => '%s'", ch, ascii_out);
    end
    endtask

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        ascii_in = 8'd0;
        valid_in = 0;

        // Release reset
        @(posedge clk);
        reset <= 0;

        // Wait a few cycles
        repeat (10) @(posedge clk);

        // Send test characters (A to E)
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");
        send_char("A");

        // Done
        $display("Testbench completed.");
        $stop;
    end

endmodule

