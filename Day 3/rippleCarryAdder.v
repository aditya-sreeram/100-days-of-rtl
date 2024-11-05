//author: Aditya Sreeram //date:5/11/24

module fullAdder(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
    );   
    assign sum= a^b^c_in;
    assign c_out=(a&b)|(b&c_in)|(c_in&a);
endmodule

module rippleCarryAdder(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] sum,
    output c_out
    );   
    wire [2:0]w;
    
    fullAdder fa1(a[0],b[0],c_in,sum[0],w[0]);
    fullAdder fa2(a[1],b[1],w[0],sum[1],w[1]);
    fullAdder fa3(a[2],b[2],w[1],sum[2],w[2]);
    fullAdder fa4(a[3],b[3],w[2],sum[3],c_out);
    
endmodule

