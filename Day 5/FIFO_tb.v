`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2024 10:28:37 AM
// Design Name: 
// Module Name: FIFO_tb
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


module FIFO_tb;
    parameter width=4;
    reg [width-1:0]data_in;
    reg clk,rst,rd,wr;
    wire [width-1:0]data_out;
    wire full,empty;
    
    integer i;
    
    FIFO DUT(.data_in(data_in),.clk(clk),.rst(rst),.rd(rd),.wr(wr),.data_out(data_out),.full(full),.empty(empty));
    
    initial begin
        {clk,rst,rd,wr}=0;
        forever #5 clk=~clk;
    end
    
    initial begin
        #7
        wr=1'b1;
        for(i=0;i<18;i=i+1)begin
            data_in=i;
            #10;
        end
        
        wr=1'b0;
        rd=1'b1;
        #100 $finish;
    end
endmodule
