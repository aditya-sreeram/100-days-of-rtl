//author: Aditya Sreeram
//date: 3/11/24

module clockDivider(clockDivider_if vif);
    
    reg [2:0] count = 0; 
    
    always @(posedge vif.clk or posedge vif.rst) begin
        if (vif.rst) count<=0;
        else if (vif.enb) begin
            if(count == 3'd7) count<=0;
            
            else count<= count+1;
        end
    end
    
    assign vif.div2= count[0];
    assign vif.div4= count[1];
    assign vif.div8= count[2];
endmodule


//interface
interface clockDivider_if;
    logic clk, rst, enb;
    logic div2, div4, div8;
endinterface


