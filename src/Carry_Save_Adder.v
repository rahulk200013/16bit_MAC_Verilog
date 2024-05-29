module carrySaveAdder32bit(sum,carry,in1,in2,in3);
output [31:0] sum, carry;
input [31:0] in1, in2, in3;

//Wire to stor final cout which we don't need
wire garbage;

//32 bit carry save adder using 32 Full Adders
assign carry[0] = 1'b0;
fullAdder f0(.sum(sum[0]),.cout(carry[1]),.a(in1[0]),.b(in2[0]),.cin(in3[0]));
fullAdder f1(.sum(sum[1]),.cout(carry[2]),.a(in1[1]),.b(in2[1]),.cin(in3[1]));
fullAdder f2(.sum(sum[2]),.cout(carry[3]),.a(in1[2]),.b(in2[2]),.cin(in3[2]));
fullAdder f3(.sum(sum[3]),.cout(carry[4]),.a(in1[3]),.b(in2[3]),.cin(in3[3]));
fullAdder f4(.sum(sum[4]),.cout(carry[5]),.a(in1[4]),.b(in2[4]),.cin(in3[4]));
fullAdder f5(.sum(sum[5]),.cout(carry[6]),.a(in1[5]),.b(in2[5]),.cin(in3[5]));
fullAdder f6(.sum(sum[6]),.cout(carry[7]),.a(in1[6]),.b(in2[6]),.cin(in3[6]));
fullAdder f7(.sum(sum[7]),.cout(carry[8]),.a(in1[7]),.b(in2[7]),.cin(in3[7]));
fullAdder f8(.sum(sum[8]),.cout(carry[9]),.a(in1[8]),.b(in2[8]),.cin(in3[8]));
fullAdder f9(.sum(sum[9]),.cout(carry[10]),.a(in1[9]),.b(in2[9]),.cin(in3[9]));
fullAdder f10(.sum(sum[10]),.cout(carry[11]),.a(in1[10]),.b(in2[10]),.cin(in3[10]));
fullAdder f11(.sum(sum[11]),.cout(carry[12]),.a(in1[11]),.b(in2[11]),.cin(in3[11]));
fullAdder f12(.sum(sum[12]),.cout(carry[13]),.a(in1[12]),.b(in2[12]),.cin(in3[12]));
fullAdder f13(.sum(sum[13]),.cout(carry[14]),.a(in1[13]),.b(in2[13]),.cin(in3[13]));
fullAdder f14(.sum(sum[14]),.cout(carry[15]),.a(in1[14]),.b(in2[14]),.cin(in3[14]));
fullAdder f15(.sum(sum[15]),.cout(carry[16]),.a(in1[15]),.b(in2[15]),.cin(in3[15]));
fullAdder f16(.sum(sum[16]),.cout(carry[17]),.a(in1[16]),.b(in2[16]),.cin(in3[16]));
fullAdder f17(.sum(sum[17]),.cout(carry[18]),.a(in1[17]),.b(in2[17]),.cin(in3[17]));
fullAdder f18(.sum(sum[18]),.cout(carry[19]),.a(in1[18]),.b(in2[18]),.cin(in3[18]));
fullAdder f19(.sum(sum[19]),.cout(carry[20]),.a(in1[19]),.b(in2[19]),.cin(in3[19]));
fullAdder f20(.sum(sum[20]),.cout(carry[21]),.a(in1[20]),.b(in2[20]),.cin(in3[20]));
fullAdder f21(.sum(sum[21]),.cout(carry[22]),.a(in1[21]),.b(in2[21]),.cin(in3[21]));
fullAdder f22(.sum(sum[22]),.cout(carry[23]),.a(in1[22]),.b(in2[22]),.cin(in3[22]));
fullAdder f23(.sum(sum[23]),.cout(carry[24]),.a(in1[23]),.b(in2[23]),.cin(in3[23]));
fullAdder f24(.sum(sum[24]),.cout(carry[25]),.a(in1[24]),.b(in2[24]),.cin(in3[24]));
fullAdder f25(.sum(sum[25]),.cout(carry[26]),.a(in1[25]),.b(in2[25]),.cin(in3[25]));
fullAdder f26(.sum(sum[26]),.cout(carry[27]),.a(in1[26]),.b(in2[26]),.cin(in3[26]));
fullAdder f27(.sum(sum[27]),.cout(carry[28]),.a(in1[27]),.b(in2[27]),.cin(in3[27]));
fullAdder f28(.sum(sum[28]),.cout(carry[29]),.a(in1[28]),.b(in2[28]),.cin(in3[28]));
fullAdder f29(.sum(sum[29]),.cout(carry[30]),.a(in1[29]),.b(in2[29]),.cin(in3[29]));
fullAdder f30(.sum(sum[30]),.cout(carry[31]),.a(in1[30]),.b(in2[30]),.cin(in3[30]));
fullAdder f31(.sum(sum[31]),.cout(garbage),.a(in1[31]),.b(in2[31]),.cin(in3[31]));

endmodule 