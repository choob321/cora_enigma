`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2025 14:15:52
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

 
`timescale 1ns / 1ps

module uart_rx (
    input wire clk,
    input wire rx,
    output reg [7:0] data_out,
    output reg data_valid
);
    parameter CLK_FREQ = 125_000_000;
    parameter BAUD_RATE = 9600;
    localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    localparam IDLE     = 3'b000;
    localparam START    = 3'b001;
    localparam DATA     = 3'b010;
    localparam STOP     = 3'b011;
    localparam CLEANUP  = 3'b100;

    reg [2:0] state = IDLE;
    reg [13:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] rx_shift = 0;

    always @(posedge clk) begin
        data_valid <= 0;

        case (state)
            IDLE: begin
                clk_count <= 0;
                bit_index <= 0;
                if (rx == 0) begin  // Start bit detected
                    state <= START;
                end
            end

            START: begin
                if (clk_count == (CLKS_PER_BIT/2)) begin
                    clk_count <= 0;
                    state <= DATA;
                end else begin
                    clk_count <= clk_count + 1;
                end
            end

            DATA: begin
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    rx_shift[bit_index] <= rx;
                    if (bit_index < 7) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                end
            end

            STOP: begin
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    data_out <= rx_shift;
                    data_valid <= 1;
                    clk_count <= 0;
                    state <= CLEANUP;
                end
            end

            CLEANUP: begin
                state <= IDLE;
            end

            default: state <= IDLE;
        endcase
    end
endmodule

