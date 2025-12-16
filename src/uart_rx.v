`timescale 1ns / 1ps
module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       rx_serial,
    input  wire       tick,      // Expecting 16x oversampling tick
    output reg  [7:0] rx_data,
    output reg        rx_done
);

    localparam IDLE  = 2'b00,
               START = 2'b01,
               DATA  = 2'b10,
               STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [3:0] tick_count; // Counter for 16x ticks

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state      <= IDLE;
            rx_data    <= 8'd0;
            rx_done    <= 1'b0;
            bit_index  <= 0;
            tick_count <= 0;
        end else begin
            rx_done <= 1'b0; // Default low
            
            case (state)
                IDLE: begin
                    if (rx_serial == 1'b0) begin
                        state      <= START;
                        tick_count <= 0;
                    end
                end

                START: begin
                    if (tick) begin
                        if (tick_count == 7) begin // Middle of start bit
                            state      <= DATA;
                            bit_index  <= 0;
                            tick_count <= 0;
                        end else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                DATA: begin
                    if (tick) begin
                        if (tick_count == 15) begin // Middle of data bit
                            tick_count <= 0;
                            rx_data[bit_index] <= rx_serial;
                            if (bit_index == 7)
                                state <= STOP;
                            else
                                bit_index <= bit_index + 1;
                        end else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                STOP: begin
                    if (tick) begin
                        if (tick_count == 15) begin // Middle of stop bit
                            state   <= IDLE;
                            rx_done <= 1'b1;
                        end else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule