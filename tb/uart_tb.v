`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2026 04:07:53 PM
// Design Name: 
// Module Name: uart_tb
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

module uart_tb;

reg clk;
reg rst;
reg [7:0] data_in;
reg tx_valid;

wire tx;
wire busy;
wire [7:0] data_out;
wire data_valid;
wire data_busy;
wire tx_en;
wire rx_en;
wire rx_line;

// loopback connection
assign rx_line = tx;

// Instantiate modules
baud_rate_generator baud_gen(
    .clk(clk),
    .rst(rst),
    .tx_en(tx_en),
    .rx_en(rx_en)
);

transmitter tx_inst(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .baud_tick(tx_en),
    .tx_valid(tx_valid),
    .tx(tx),
    .busy(busy)
);

receiver rx_inst(
    .clk(clk),
    .rst(rst),
    .rx(rx_line),
    .baud_tick(rx_en),
    .data_out(data_out),
    .data_valid(data_valid),
    .data_busy(data_busy)
);

initial begin
    clk = 0;
end
always #5 clk = ~clk;   // 100 MHz clock

initial begin
    rst = 1;
    tx_valid = 0;
    data_in = 0;
    #100;
    rst = 0;

// Send first byte
    @(posedge clk);
    data_in = 8'hA5;
    tx_valid = 1;
    @(posedge clk);
    tx_valid = 0;
    wait(data_valid);
    $display("Received: %h", data_out);

// Send second byte
    repeat(20000) @(posedge clk);
    data_in = 8'h3C;
    tx_valid = 1;
    @(posedge clk);
    tx_valid = 0;
    wait(data_valid);
    $display("Received: %h", data_out);

// Send third byte
    repeat(20000) @(posedge clk);
    data_in = 8'hF0;
    tx_valid = 1;
    @(posedge clk);
    tx_valid = 0;
    wait(data_valid);
    $display("Received: %h", data_out);


// Send fourth byte
    repeat(20000) @(posedge clk);
    data_in = 8'h0F;
    tx_valid = 1;
    @(posedge clk);
    tx_valid = 0;
    wait(data_valid);
    $display("Received: %h", data_out);
    

// Send fifth byte
    repeat(20000) @(posedge clk);
    data_in = 8'hAB;
    tx_valid = 1;
    @(posedge clk);
    tx_valid = 0;
    wait(data_valid);
    $display("Received: %h", data_out);

//stop
    #50000;
    $stop;

end
endmodule