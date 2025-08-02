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
    // UART RX wires
    wire [7:0] rx_data;
    wire rx_valid;

    // Enigma wires
    wire [7:0] enc_out;
    wire enc_valid;

    // UART TX control
    reg tx_start = 0;
    wire tx_busy;

    // --- UART Receiver ---
    uart_rx #(
        .CLK_FREQ(125_000_000),
        .BAUD_RATE(9600)
    ) uart_receiver (
        .clk(clk),
        .rx(rx),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );

    // --- Enigma Core ---
    wire enigma_ready = ~tx_busy;

    enigma_core enigma (
        .clk(clk),
        .reset(1'b0),
        .ascii_in(rx_data),
        .valid_in(rx_valid & enigma_ready),
        .ascii_out(enc_out),
        .valid_out(enc_valid)
    );

    // --- UART Transmitter ---
    uart_tx #(
        .CLK_FREQ(125_000_000),
        .BAUD_RATE(9600)
    ) uart_transmitter (
        .clk(clk),
        .send(tx_start),
        .data_in(enc_out),
        .tx(tx),
        .busy(tx_busy)
    );

    // --- Control logic for tx_start ---
    always @(posedge clk) begin
        if (enc_valid && !tx_busy)
            tx_start <= 1;
        else
            tx_start <= 0;
    end
endmodule
