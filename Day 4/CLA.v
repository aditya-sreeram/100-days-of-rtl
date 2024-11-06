//author: Aditya Sreeram //date:6/11/24

module FA(
    input a,
    input b,
    input c_in,
    output sum
    );
    assign sum= a ^ b ^ c_in;
endmodule

module CLA(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] sum,
    output c_out
    );
    
    wire[4:0] ci;
    wire[3:0] gi,pi;
    
    FA FA1(a[0],b[0],ci[0],sum[0]);
    FA FA2(a[1],b[1],ci[1],sum[1]);
    FA FA3(a[2],b[2],ci[2],sum[2]);
    FA FA4(a[3],b[3],ci[3],sum[3]);
    
    assign ci[0]=c_in;
    genvar i;
    generate
    for(i=0;i<4;i=i+1)
        begin
            assign pi[i]=a[i]|b[i];
            assign gi[i]=a[i]&b[i];
            assign ci[i+1]=gi[i] | (pi[i]&ci[i]);
        end
    endgenerate
    
    assign c_out=ci[4];
endmodule

