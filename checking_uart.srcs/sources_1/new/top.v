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
    input wire uart_rx, // pin T14, io[2], connected to tx of ch340g
    output wire uart_tx // pin T15, io[3], connected to rx of ch340g
);
    wire [7:0] rx_data; // output character of uart_rx, the one the user typed
    wire rx_valid;
    wire tx_busy;

    reg send_flag = 0;
    reg [7:0] tx_buffer = 0;
    
    wire [7:0] encrypted_char; // output char after going through enigma
    
    uart_rx #(.CLK_FREQ(125_000_000), .BAUD_RATE(9600)) rx_inst (
        .clk(clk),
        .rx(uart_rx),
        .data_out(rx_data),
        .data_valid(rx_valid)
    );
    
    caeser caeser_inst (
        .char_in(rx_data),
        .char_out(encrypted_char)
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
            tx_buffer <= encrypted_char;
            send_flag <= 1;
        end
    end
endmodule
