`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2025 17:41:24
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


module uart_tx(
    input clk,              // 100 MHz clock
    output reg uart_tx = 1  // UART TX line (idle high)
);

    parameter CLK_FREQ = 100_000_000;  // 100 MHz
    parameter BAUD_RATE = 115200;
    parameter BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [13:0] baud_cnt = 0;
    reg baud_tick = 0;

    reg [3:0] bit_idx = 0;
    reg [9:0] shift_reg = 10'b0; // start + 8 data + stop
    reg sending = 0;

    reg [23:0] delay_cnt = 0;
    reg send_request = 0;

    // Baud tick generator
    always @(posedge clk) begin
        if (baud_cnt == BAUD_DIV - 1) begin
            baud_cnt <= 0;
            baud_tick <= 1;
        end else begin
            baud_cnt <= baud_cnt + 1;
            baud_tick <= 0;
        end
    end

    // Delay between bytes
    always @(posedge clk) begin
        if (!sending) begin
            if (delay_cnt == 10_000_000) begin  // ~0.1 sec delay
                delay_cnt <= 0;
                send_request <= 1;
            end else begin
                delay_cnt <= delay_cnt + 1;
                send_request <= 0;
            end
        end
    end

    // Transmit state machine
    always @(posedge clk) begin
        if (!sending && send_request) begin
            // Prepare to send ASCII 'A' (8'h41)
            shift_reg <= {1'b1, 8'h41, 1'b0};  // Stop + data + Start
            bit_idx <= 0;
            sending <= 1;
        end else if (sending && baud_tick) begin
            uart_tx <= shift_reg[bit_idx];
            bit_idx <= bit_idx + 1;
            if (bit_idx == 9) begin
                sending <= 0;
                uart_tx <= 1;  // idle
            end
        end
    end

endmodule

