`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2025 16:05:05
// Design Name: 
// Module Name: uart_rx_toggle
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


module uart_rx_toggle(
    input wire clk,         // 125 MHz system clock
    input wire rx,          // UART receive line
    output reg led_out      // Toggles on valid character received
);

    parameter CLK_FREQ = 125_000_000;
    parameter BAUD_RATE = 115200;
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;  // ? 1086 ticks per bit

    reg [13:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] rx_shift = 10'b1111111111;
    reg receiving = 0;

    reg rx_sync_0 = 1;
    reg rx_sync_1 = 1;

    // Synchronize rx line to clk domain
    always @(posedge clk) begin
        rx_sync_0 <= rx;
        rx_sync_1 <= rx_sync_0;
    end

    always @(posedge clk) begin
        if (!receiving) begin
            // Wait for falling edge (start bit)
            if (rx_sync_1 == 0) begin
                receiving <= 1;
                baud_counter <= BAUD_TICKS / 2;  // Sample mid start bit
                bit_index <= 0;
            end
        end else begin
            if (baud_counter == 0) begin
                baud_counter <= BAUD_TICKS - 1;

                if (bit_index < 9) begin
                    rx_shift <= {rx_sync_1, rx_shift[9:1]};
                    bit_index <= bit_index + 1;
                end else begin
                    // Bit 9 is stop bit; if it's high, valid transmission
                    if (rx_sync_1 == 1) begin
                        led_out <= ~led_out;  // Toggle LED
                    end
                    receiving <= 0;
                end
            end else begin
                baud_counter <= baud_counter - 1;
            end
        end
    end
endmodule
