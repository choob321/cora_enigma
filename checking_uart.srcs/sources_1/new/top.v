`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 17:33:08
// Design Name: 
// Module Name: top
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


module top(
    input clk,              // 125 MHz clock
    input uart_rx,          // UART receive line
    output led0_b      // Output LED toggles on character received
);


    uart_rx_toggle uut (
        .clk(clk),
        .rx(uart_rx),
        .led_out(led0_b)
    );

endmodule

