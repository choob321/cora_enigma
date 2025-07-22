`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 17:36:23
// Design Name: 
// Module Name: uart_rx
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


module uart_rx(
    input wire clk,        // 125 MHz clock
    input wire rx,         // UART receive line
    output reg [7:0] data, // Received byte
    output reg received    // Goes high for one clock when byte received
);

    parameter CLK_FREQ = 125_000_000;
    parameter BAUD_RATE = 115200;
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;  // ? 13020
    localparam HALF_BAUD = BAUD_TICKS / 2;

    reg [13:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] rx_shift = 0;

    reg receiving = 0;
    reg rx_d1 = 1, rx_d2 = 1;  // For detecting start bit edge

    always @(posedge clk) begin
        // Double-register rx to prevent metastability
        rx_d1 <= rx;
        rx_d2 <= rx_d1;

        received <= 0;

        if (!receiving) begin
            if (rx_d2 == 0) begin  // Start bit detected (falling edge)
                receiving <= 1;
                baud_counter <= HALF_BAUD;  // Align to middle of start bit
                bit_index <= 0;
            end
        end else begin
            if (baud_counter == BAUD_TICKS - 1) begin
                baud_counter <= 0;
                bit_index <= bit_index + 1;

                if (bit_index >= 1 && bit_index <= 8)
                    rx_shift <= {rx_d2, rx_shift[7:1]};  // LSB first

                if (bit_index == 9) begin
                    data <= rx_shift;
                    received <= 1;
                    receiving <= 0;
                end
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end

endmodule
