`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 22:17:11
// Design Name: 
// Module Name: uart_a_sender
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


module uart_a_sender(
    input wire clk,         // 125 MHz system clock
    output wire uart_tx     // UART transmit line (to IO3 / T15)
);

    // UART Config
    parameter CLK_FREQ = 125_000_000;  // 125 MHz
    parameter BAUD_RATE = 115200;
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE; // about 13020 clock cycles per uart bit

    // UART TX logic
    reg [13:0] baud_counter = 0; // counts to 13020, then triggers baud tick
    reg baud_tick = 0; 

    reg [9:0] tx_shift = 10'b1111111111;  // UART frame (idle by default)
    reg [3:0] bit_index = 0; // counts how many bits are left to send

    reg [31:0] one_sec_counter = 0; // counts to 125 M
    wire send_now = (one_sec_counter >= CLK_FREQ);

    assign uart_tx = tx_shift[0];

    always @(posedge clk) begin
        // Baud tick generator
        if (baud_counter == BAUD_TICKS - 1) begin
            baud_counter <= 0;
            baud_tick <= 1;
        end else begin
            baud_counter <= baud_counter + 1;
            baud_tick <= 0;
        end

        // 1-second send timer
        if (one_sec_counter >= CLK_FREQ)
            one_sec_counter <= 0;
        else
            one_sec_counter <= one_sec_counter + 1;

        // Start sending 'A' (0x41) if idle and it's time
        if (send_now && bit_index == 0) begin
            tx_shift <= {1'b1, 8'h41, 1'b0}; // stop, data, start
            bit_index <= 10;
        end

        // Transmit bits on baud_tick
        if (baud_tick && bit_index > 0) begin
            tx_shift <= {1'b1, tx_shift[9:1]};  // shift in idle
            bit_index <= bit_index - 1;
        end
    end

endmodule

