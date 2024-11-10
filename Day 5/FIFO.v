//author: Aditya Sreeram //date: 9/11/24
module FIFO#(parameter width= 4)(
    input [width-1:0]data_in,
    input clk,rst,rd,wr,
    output reg[width-1:0]data_out,
    output full,empty
    
    );
    reg [3:0]wptr=0,rptr=0;//pointer
    reg [4:0]cnt=0;//count elements
    reg [width-1:0]mem [15:0]; //4x16
    
    always @(posedge clk)begin
        if(rst==1'b1){wptr,rptr,cnt}<=0;
        
        else if(wr && !full)begin
            mem[wptr]<=data_in;
            wptr <=wptr+1;
            cnt <=cnt+1;
        end
        
        else if(rd && !empty)begin
            data_out <= mem[rptr];
            rptr <= rptr +1;
            cnt <= cnt-1;
        end
    end
    
    assign empty = (cnt==0)? 1'b1: 1'b0;
    assign full = (cnt==16)? 1'b1: 1'b0; 
endmodule


