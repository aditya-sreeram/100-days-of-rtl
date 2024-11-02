//Author: Aditya Sreeram KS
//Date: 2/11/2024
module clockDivider(
    input rst, clk, enb,
    output div2, div4, div8
    );
    
    reg [2:0] count = 0; 
    
    always @(posedge clk or posedge rst) begin
        if (rst) count<=0;
        else if (enb) begin
            if(count == 3'd7) count<=0;
            
            else count<= count+1;
        end
    end
    
    assign div2= count[0];
    assign div4= count[1];
    assign div8= count[2];
endmodule



