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
    input wire clk,          // 125 MHz system clock
    output wire uart_tx      // UART transmit line
);

    parameter CLK_FREQ = 125_000_000;
    parameter BAUD_RATE = 115200;
    localparam BAUD_TICKS = CLK_FREQ / BAUD_RATE;   // ? 1086
    localparam FRAME_BITS = 10; // start + 8 data + stop

    // 1 Hz timer
    reg [26:0] sec_counter = 0;
    wire send_now = (sec_counter == CLK_FREQ - 1);

    // UART transmission state
    reg [13:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_shift = 10'b1111111111;
    reg busy = 0;
    assign uart_tx = tx_shift[0];

    always @(posedge clk) begin
        // 1 second trigger
        if (sec_counter >= CLK_FREQ - 1)
            sec_counter <= 0;
        else
            sec_counter <= sec_counter + 1;

        // Start transmission if it's time and not busy
        if (send_now && !busy) begin
            tx_shift <= {1'b1, 8'h41, 1'b0};  // stop + data + start
            bit_index <= FRAME_BITS;
            busy <= 1;
            baud_counter <= 0;
        end

        // Transmit bits at baud rate
        if (busy) begin
            if (baud_counter >= BAUD_TICKS - 1) begin
                baud_counter <= 0;
                tx_shift <= {1'b1, tx_shift[9:1]};
                bit_index <= bit_index - 1;
                if (bit_index == 1)
                    busy <= 0;
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end

endmodule

