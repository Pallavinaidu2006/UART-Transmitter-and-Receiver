`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2025 19:30:05
// Design Name: 
// Module Name: transmitter_tb
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


module transmitter_tb();

    reg clk = 0;
    reg rst = 0;
    reg btn = 0;
    reg [7:0] data = 8'b01010101; // example data
    wire TxD;

    // Clock generation (100 MHz)
    always #5 clk = ~clk;  // 10 ns period ? 100 MHz

    // Instantiate the DUT (top-level design)
    topmodule uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .data(data),
        .TxD(TxD)
    );

    initial begin
        // Reset pulse
        rst = 1; #20; rst = 0;

        // Wait and then simulate button press
        #100000;     // wait some time
        btn = 1;     // press the button
        #100000;     // keep pressed
        btn = 0;     // release

        // Wait for UART transmission
        #1000000;

        $stop;
    end
endmodule

