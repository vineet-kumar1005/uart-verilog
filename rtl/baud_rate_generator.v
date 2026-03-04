`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 01:16:37 AM
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator(
    input wire clk,
    input wire rst,
    output wire tx_en,
    output wire rx_en
    );
    reg [8:0] tx_counter = 0;
    reg [4:0] rx_counter = 0;
    
    always@(posedge rst or posedge clk) begin
        if(rst)
            tx_counter <= 1'b0;
        else if(tx_counter == 9'b110110001)
            tx_counter <= 1'b0;
        else
            tx_counter <= tx_counter + 1;
    end
    always@(posedge rst or posedge clk) begin
        if(rst)
            rx_counter <= 1'b0;
        else if(rx_counter == 5'b11010)
            rx_counter <= 1'b0;
        else
            rx_counter <= rx_counter + 1;
    end
    assign tx_en = (tx_counter == 0) ? 1'b1 : 1'b0;
    assign rx_en = (rx_counter == 0) ? 1'b1 : 1'b0;
endmodule