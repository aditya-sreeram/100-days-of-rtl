`timescale 1ns / 1ps

module clockDivider_tb;

    reg rst, clk, enb;
    wire div2, div4, div8;
    
    clockDivider DUT(.rst(rst),.clk(clk),.enb(enb),.div2(div2),.div4(div4),.div8(div8));
    
    parameter duty=5;
    
    initial begin
    {clk,rst}=1'b0;
    enb=1'b1;
    forever #duty clk=~clk;
    end
    
    initial begin
    #50 rst=1'b1;
    #50 {rst,enb}=2'b00;
    #25 enb=1'b1;
    #50 $finish;
    
    end
endmodule