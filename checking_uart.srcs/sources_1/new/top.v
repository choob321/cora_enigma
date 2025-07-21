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
    input wire uart_rx,
    output wire uart_tx
);
    wire [7:0] rx_data;
    wire rx_valid;
    wire tx_busy;

    reg send_flag = 0;
    reg [7:0] tx_buffer = 0;

    uart_rx #(.CLK_FREQ(125_000_000), .BAUD_RATE(9600)) rx_inst (
        .clk(clk),
        .rx(uart_rx),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );

    uart_tx #(.CLK_FREQ(125_000_000), .BAUD_RATE(9600)) tx_inst (
        .clk(clk),
        .send(send_flag),
        .data_in(tx_buffer),
        .tx(uart_tx),
        .busy(tx_busy)
    );

    always @(posedge clk) begin
        send_flag <= 0;
        if (rx_valid && !tx_busy) begin
            tx_buffer <= rx_data;
            send_flag <= 1;
        end
    end
endmodule
