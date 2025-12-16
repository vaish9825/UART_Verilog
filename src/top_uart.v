`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2025 02:19:27
// Design Name: 
// Module Name: top_uart
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


module top_uart (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire [7:0] data_in,
    output wire       tx_serial,
    output wire       tx_done,
    output wire       rx_done,
    output wire [7:0] rx_data
);

    wire tick;

    baud_rate_generator #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(115200)
    ) baud_gen (
        .clk(clk),
        .reset(reset),
        .tick(tick)
    );

    uart_tx tx (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tick(tick),
        .tx_data(data_in),
        .tx_serial(tx_serial),
        .tx_done(tx_done)
    );

    uart_rx rx (
        .clk(clk),
        .reset(reset),
        .rx_serial(tx_serial),
        .tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
endmodule
