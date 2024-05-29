module carrySelectAdder40bit(sum, in1, in2);
output [39:0] sum;
input [39:0] in1, in2;

//Intermideate wires for connection
wire c0,c1,c2,c3,c4,c5,c6,c7,c8,cout;

//Calculate 40 bit sum using 10 4-bit carry select adders.
carrySlelectAdder4bit cla0(sum[3:0], c0, in1[3:0], in2[3:0], 1'b0);
carrySlelectAdder4bit cla1(sum[7:4], c1, in1[7:4], in2[7:4], c0);
carrySlelectAdder4bit cla2(sum[11:8], c2, in1[11:8], in2[11:8], c1);
carrySlelectAdder4bit cla3(sum[15:12], c3, in1[15:12], in2[15:12], c2);
carrySlelectAdder4bit cla4(sum[19:16], c4, in1[19:16], in2[19:16], c3);
carrySlelectAdder4bit cla5(sum[23:20], c5, in1[23:20], in2[23:20], c4);
carrySlelectAdder4bit cla6(sum[27:24], c6, in1[27:24], in2[27:24], c5);
carrySlelectAdder4bit cla7(sum[31:28], c7, in1[31:28], in2[31:28], c6);
carrySlelectAdder4bit cla8(sum[35:32], c8, in1[35:32], in2[35:32], c7);
carrySlelectAdder4bit cla9(sum[39:36], cout, in1[39:36], in2[39:36], c8);

endmodule
