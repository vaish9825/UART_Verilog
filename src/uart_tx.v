`timescale 1ns / 1ps
module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       tx_start,
    input  wire       tick,      // Expecting 16x oversampling tick
    input  wire [7:0] tx_data,
    output reg        tx_serial,
    output reg        tx_done
);

    localparam IDLE  = 2'b00,
               START = 2'b01,
               DATA  = 2'b10,
               STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_index;
    reg [7:0] data_buf;
    reg [3:0] tick_count; // Counter to hold bit for 16 ticks

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state      <= IDLE;
            tx_serial  <= 1'b1;
            tx_done    <= 1'b0;
            bit_index  <= 0;
            tick_count <= 0;
        end else begin
            tx_done <= 1'b0;
            case (state)
                IDLE: begin
                    tx_serial <= 1'b1;
                    if (tx_start) begin
                        data_buf   <= tx_data;
                        state      <= START;
                        tick_count <= 0;
                    end
                end

                START: begin
                    tx_serial <= 1'b0; // Send Start Bit
                    if (tick) begin
                        if (tick_count == 15) begin
                            state      <= DATA;
                            bit_index  <= 0;
                            tick_count <= 0;
                        end else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end

                DATA: begin
                    tx_serial <= data_buf[bit_index];
                    if (tick) begin
                        if (tick_count == 15) begin
                            tick_count <= 0;
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
                    tx_serial <= 1'b1; // Send Stop Bit
                    if (tick) begin
                        if (tick_count == 15) begin
                            tx_done <= 1'b1;
                            state   <= IDLE;
                        end else begin
                            tick_count <= tick_count + 1;
                        end
                    end
                end
            endcase
        end
    end
endmodule