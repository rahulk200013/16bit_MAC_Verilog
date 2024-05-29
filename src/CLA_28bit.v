module carrySelectAdder28bit(sum, in1, in2);
output [27:0] sum;
input wire [26:0] in1; 
input wire [27:0] in2;

//Wire for sign extened input so that we can use it as an input to 28 bit CSeLA.
wire [27:0] in1_padded;
assign in1_padded[26:0] = in1;
assign in1_padded[27] = in1[26];

//Intermideate wires for connection
wire c0,c1,c2,c3,c4,c5,c6,cout;

//Calculate 28 bit sum using 7 4-bit carry select adders.
carrySlelectAdder4bit cla0(sum[3:0], c0, in1_padded[3:0], in2[3:0], 1'b0);
carrySlelectAdder4bit cla1(sum[7:4], c1, in1_padded[7:4], in2[7:4], c0);
carrySlelectAdder4bit cla2(sum[11:8], c2, in1_padded[11:8], in2[11:8], c1);
carrySlelectAdder4bit cla3(sum[15:12], c3, in1_padded[15:12], in2[15:12], c2);
carrySlelectAdder4bit cla4(sum[19:16], c4, in1_padded[19:16], in2[19:16], c3);
carrySlelectAdder4bit cla5(sum[23:20], c5, in1_padded[23:20], in2[23:20], c4);
carrySlelectAdder4bit cla6(sum[27:24], c6, in1_padded[27:24], in2[27:24], c5);

endmodule
