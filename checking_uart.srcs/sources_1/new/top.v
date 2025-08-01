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


module top (
    input wire clk,
    input wire rx,
    output wire tx
);
    wire [7:0] rx_data;
    wire [7:0] tx_data;
    wire rx_valid, tx_busy, tx_start, enigma_valid;

    uart_rx #(.CLK_FREQ(125_000_000), .BAUD_RATE(9600)) urx (
        .clk(clk),
        .rx(rx),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );

    enigma_core enigma (
        .clk(clk),
        .char_in(rx_data),
        .valid_in(rx_valid),
        .char_out(tx_data),
        .valid_out(enigma_valid)
    );

    uart_tx #(.CLK_FREQ(125_000_000), .BAUD_RATE(9600)) utx (
        .clk(clk),
        .send(enigma_valid),
        .data_in(tx_data),
        .tx(tx),
        .busy(tx_busy)
    );
endmodule
