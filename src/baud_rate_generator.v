`timescale 1ns / 1ps
module baud_rate_generator #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200
)(
    input  wire clk,
    input  wire reset,
    output reg  tick // Generates 16 ticks per bit
);

    // Calculate divisor for 16x oversampling
    localparam integer MAX_COUNT = CLK_FREQ / (BAUD_RATE * 16); 
    reg [$clog2(MAX_COUNT)-1:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            tick    <= 1'b0;
        end else begin
            if (counter == MAX_COUNT-1) begin
                counter <= 0;
                tick    <= 1'b1;
            end else begin
                counter <= counter + 1;
                tick    <= 1'b0;
            end
        end
    end
endmodule