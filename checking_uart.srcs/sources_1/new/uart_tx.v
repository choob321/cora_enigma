`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2025 14:15:52
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
    input wire clk,
    input wire send,
    input wire [7:0] data_in,
    output wire tx,
    output reg busy
);
    parameter CLK_FREQ = 125_000_000;
    parameter BAUD_RATE = 9600;
    localparam integer BAUD_TICKS = CLK_FREQ / BAUD_RATE;

    reg [13:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_shift = 10'b1111111111;

    assign tx = tx_shift[0];

    always @(posedge clk) begin
        if (!busy && send) begin
            tx_shift <= {1'b1, data_in, 1'b0}; // stop + data + start
            bit_index <= 10;
            busy <= 1;
            baud_counter <= BAUD_TICKS - 1;
        end else if (busy) begin
            if (baud_counter == 0) begin
                tx_shift <= {1'b1, tx_shift[9:1]};
                bit_index <= bit_index - 1;
                baud_counter <= BAUD_TICKS - 1;

                if (bit_index == 1) begin
                    busy <= 0;
                end
            end else begin
                baud_counter <= baud_counter - 1;
            end
        end
    end
endmodule
