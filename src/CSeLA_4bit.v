module carrySlelectAdder4bit (sum, cout, a, b, cin);
output [3:0] sum;
output cout;
input [3:0] a,b;
input cin;

wire [3:0] sum_0, sum_1;
wire cout_0, cout_1;


//Sum and carry for cin = 0
carryLookAheadAdder4bit cla0(sum_0[3:0], cout_0, a, b, 1'b0);

//Sum and carry for cin = 1
carryLookAheadAdder4bit cla1(sum_1[3:0], cout_1, a, b, 1'b1);

mux2to1 m0(sum[0], cin, sum_0[0], sum_1[0]);
mux2to1 m1(sum[1], cin, sum_0[1], sum_1[1]);
mux2to1 m2(sum[2], cin, sum_0[2], sum_1[2]);
mux2to1 m3(sum[3], cin, sum_0[3], sum_1[3]);

mux2to1 m4(cout, cin, cout_0, cout_1);

endmodule

