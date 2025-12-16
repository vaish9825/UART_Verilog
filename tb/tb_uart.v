`timescale 1ns / 1ps
module tb_uart;
    reg clk = 0;
    reg reset = 1;
    reg tx_start = 0;
    reg [7:0] data_in = 0;

    wire tx_serial, tx_done, rx_done;
    wire [7:0] rx_data;
    wire tick;

    // 50 MHz clock
    always #10 clk = ~clk; 

    // Use standard 115200 Baud Rate
    baud_rate_generator #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(115200)
    ) baud_gen (clk, reset, tick);

    uart_tx tx (clk, reset, tx_start, tick, data_in, tx_serial, tx_done);
    uart_rx rx (clk, reset, tx_serial, tick, rx_data, rx_done);

    initial begin
        // Reset sequence
        #100 reset = 0;

        // Send 'A' (0x41)
        data_in = 8'h41; 
        tx_start = 1; 
        #20 tx_start = 0; // Pulse start signal
        
        // Wait for receiver to finish
        wait(rx_done);
        
        // Check result
        if (rx_data == 8'h41)
             $display("SUCCESS: Received correct data %h", rx_data);
        else
             $display("ERROR: Received %h, expected 41", rx_data);

        // Run long enough for 115200 baud (approx 8.6us per bit, 100us total)
        #200000 $finish; 
    end
endmodule