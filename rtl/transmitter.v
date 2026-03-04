`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 02:25:07 AM
// Design Name: 
// Module Name: transmitter
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


module transmitter(
    input wire clk,
    input wire rst,
    input [7:0] data_in,
    input baud_tick,
    input tx_valid,
    output reg tx,
    output busy
);
    parameter idle = 2'b00;
    parameter start = 2'b01;
    parameter data = 2'b10;
    parameter stop = 2'b11;
    
    reg [1:0] state;
    reg [2:0] index;
    reg [7:0] shift_reg;
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            tx <= 1'b1;
            state <= idle;
            index <= 3'b0;
            shift_reg <= 8'd0;
        end
        else begin
            case(state)
                idle: begin
                    tx <= 1;
                    if(tx_valid) begin
                        shift_reg <= data_in;
                        index <= 0;
                        state <= start;
                    end
                end
                start: begin
                    
                    if(baud_tick) begin
                        tx <= 0;
                        state <= data;
                    end
                end
                data: begin
                    if(baud_tick) begin
                        tx <= shift_reg[index];
                        if(index == 7)
                            state <= stop;
                        else
                            index <= index + 1;
                    end
                end
                stop: begin
                    if(baud_tick) begin
                        tx <= 1'b1;
                        state <= idle;
                    end
                end
                default: begin
                    tx <= 1'b1;
                    state <= idle;
                end
            endcase
        end
    end
    assign busy = (state != idle);
endmodule
