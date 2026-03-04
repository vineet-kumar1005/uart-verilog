`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 10:31:46 AM
// Design Name: 
// Module Name: receiver
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


module receiver(
    input clk, rst, rx, baud_tick,
    output reg [7:0] data_out,
    output reg       data_valid,
    output wire      data_busy
);
    parameter idle = 2'b00;
    parameter valid_start = 2'b01;
    parameter data = 2'b11;
    parameter stop = 2'b10;
    
    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] index;
    reg [3:0] sampling_counter;
    
    reg rx_sync1;
    reg rx_sync2;
    reg rx_prev;
    always@(posedge clk) begin
        rx_sync1 <= rx;
        rx_sync2 <= rx_sync1;
        rx_prev <= rx_sync2;
    end
    
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            shift_reg <= 0;
            data_valid <= 0;
            data_out <= 0;
            index <= 0;
            sampling_counter <= 0;
            state <= idle;
        end
        else begin
            data_valid <= 0;
            case(state)
                idle: begin
                    sampling_counter <= 0;
                    index <= 0;
                    if(!rx_sync2 && rx_prev) begin
                        state <= valid_start;
                    end
                end
                
                valid_start: begin
                    if(baud_tick) begin
                        sampling_counter <= sampling_counter + 1;
                        if(sampling_counter == 4'd7) begin
                            if(!rx_sync2) begin
                                sampling_counter <= 0;
                                state <= data;
                            end
                            else begin
                                state <= idle;
                            end
                        end
                    end
                end
                data: begin
                    if(baud_tick) begin
                        sampling_counter <= sampling_counter + 1;
                        if(sampling_counter == 4'd15) begin
                            sampling_counter <= 0;
                            shift_reg[index] <= rx_sync2;
                                
                            if(index == 3'd7) begin
                                index <= 0;
                                state <= stop;
                            end
                            else begin
                                index <= index + 1;
                            end
                        end   
                     end 
                end
                stop: begin
                    if(baud_tick) begin
                        sampling_counter <= sampling_counter + 1;
                        if(sampling_counter == 4'd15) begin
                            sampling_counter <= 0;
                            if(rx_sync2) begin
                                data_out <= shift_reg;
                                data_valid <= 1'b1;
                            end
                            state <= idle;
                        end
                    end
                end
                default: begin
                    state <= idle;
                end
            endcase
        end
    end
    assign data_busy = (state != idle);
endmodule