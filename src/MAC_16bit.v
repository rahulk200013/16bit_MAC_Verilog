////////////////////////////////////////////////////////////////////////////
////                  Main 16 bit MAC Module                            ////
////////////////////////////////////////////////////////////////////////////

module mac_16bit(out_rounded,md,mr,clk,rst);
output reg [26:0] out_rounded;
input [15:0] md,mr;              //md: Multiplicand, mr: Multiplier
input clk,rst;

//Registor to store input multiplicand and multiplier
reg [15:0] MD,MR;

//Accumulator resgistor to store sum of all miltiplications
reg [39:0] acc;

//Wire coming out from multiplier
wire [39:0] mult_out;

//Wire coming out from partial product generator
wire [17:0] PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7,PP8;

//Registor to store sign extended 32 bit partial products
reg [31:0] PP0_reg,PP1_reg,PP2_reg,PP3_reg,PP4_reg,PP5_reg,PP6_reg,PP7_reg,PP8_reg;

//Wire of sign extended 32 bit partial product which will be assigned
//to above registors at every clock cycle
wire [31:0] PP0_FULL,PP1_FULL,PP2_FULL,PP3_FULL,PP4_FULL,PP5_FULL,PP6_FULL,PP7_FULL,PP8_FULL;

//Negate bit to get complete 2's complement when calculating partial products
wire [7:0] neg;

//Wire of sum and carry of all 7 Carry Save Adders used in wallace tree
wire [31:0] sum0,carry0,sum1,carry1,sum2,carry2,sum3,carry3,sum4,carry4,sum5,carry5,sum6,carry6;

//Wire for latest accumulator value
wire [39:0] new_acc;

//Counts clock cycle before the first output comes. Due to pipelining
//this needs to be done so that main counter can be started at 
//correct clock cycle 
reg [2:0] setup_count;

//Flag to denote set up of circuit is done to produce first output
reg setup_completed;

//Counter registor to count number of operations done
reg [8:0] count;

//Generate 18 bit partial procucts and connect them to wires
generatePartialProducts PP(.PP0(PP0),.PP1(PP1),.PP2(PP2),.PP3(PP3),.PP4(PP4),.PP5(PP5),.PP6(PP6),.PP7(PP7),.PP8(PP8),.neg(neg),.MD(MD),.MR(MR));


//Sign extend 18 bit Partial products to 32 bit and also add negate bit wherever necessary
genvar i;

assign PP0_FULL[16:0] = PP0;
for(i=31; i>16; i=i-1) begin
  assign PP0_FULL[i] = PP0_FULL[16];
end

assign PP1_FULL[18:2] = PP1;
for(i=31; i>18; i=i-1) begin
  assign PP1_FULL[i] = PP1_FULL[18];
end
assign PP1_FULL[1] = 1'b0;
assign PP1_FULL[0] = neg[0];

assign PP2_FULL[20:4] = PP2;
for(i=31; i>20; i=i-1) begin
  assign PP2_FULL[i] = PP2_FULL[20];
end
assign PP2_FULL[3] = 1'b0;
assign PP2_FULL[2] = neg[1];
for(i=0; i<2; i=i+1) begin
  assign PP2_FULL[i] = 1'b0;
end

assign PP3_FULL[22:6] = PP3;
for(i=31; i>22; i=i-1) begin
  assign PP3_FULL[i] = PP3_FULL[22];
end
assign PP3_FULL[5] = 1'b0;
assign PP3_FULL[4] = neg[2];
for(i=0; i<4; i=i+1) begin
  assign PP3_FULL[i] = 1'b0;
end

assign PP4_FULL[24:8] = PP4;
for(i=31; i>24; i=i-1) begin
  assign PP4_FULL[i] = PP4_FULL[24];
end
assign PP4_FULL[7] = 1'b0;
assign PP4_FULL[6] = neg[3];
for(i=0; i<6; i=i+1) begin
  assign PP4_FULL[i] = 1'b0;
end

assign PP5_FULL[26:10] = PP5;
for(i=31; i>26; i=i-1) begin
  assign PP5_FULL[i] = PP5_FULL[26];
end
assign PP5_FULL[9] = 1'b0;
assign PP5_FULL[8] = neg[4];
for(i=0; i<8; i=i+1) begin
  assign PP5_FULL[i] = 1'b0;
end

assign PP6_FULL[28:12] = PP6;
for(i=31; i>28; i=i-1) begin
  assign PP6_FULL[i] = PP6_FULL[28];
end
assign PP6_FULL[11] = 1'b0;
assign PP6_FULL[10] = neg[5];
for(i=0; i<10; i=i+1) begin
  assign PP6_FULL[i] = 1'b0;
end

assign PP7_FULL[30:14] = PP7;
assign PP7_FULL[31] = PP7_FULL[30];
assign PP7_FULL[13] = 1'b0;
assign PP7_FULL[12] = neg[6];
for(i=0; i<12; i=i+1) begin
  assign PP7_FULL[i] = 1'b0;
end

assign PP8_FULL[31:16] = PP8[15:0];
assign PP8_FULL[15] = 1'b0;
assign PP8_FULL[14] = neg[7];
for(i=0; i<14; i=i+1) begin
  assign PP8_FULL[i] = 1'b0;
end

//Wallace tree of 7 Carry Save Adders to get final sum and carry
carrySaveAdder32bit csa0(.sum(sum0),.carry(carry0),.in1(PP0_reg),.in2(PP1_reg),.in3(PP2_reg));
carrySaveAdder32bit csa1(.sum(sum1),.carry(carry1),.in1(PP3_reg),.in2(PP4_reg),.in3(PP5_reg));
carrySaveAdder32bit csa2(.sum(sum2),.carry(carry2),.in1(PP6_reg),.in2(PP7_reg),.in3(PP8_reg));
carrySaveAdder32bit csa3(.sum(sum3),.carry(carry3),.in1(sum0),.in2(carry0),.in3(sum1));
carrySaveAdder32bit csa4(.sum(sum4),.carry(carry4),.in1(carry1),.in2(sum2),.in3(carry2));
carrySaveAdder32bit csa5(.sum(sum5),.carry(carry5),.in1(sum3),.in2(carry3),.in3(sum4));
carrySaveAdder32bit csa6(.sum(sum6),.carry(carry6),.in1(sum5),.in2(carry5),.in3(carry4));

//Add final sum and carry to get booth encoded wallace tree multiplier output
carrySelectAdder32bit cla0(.sum(mult_out[31:0]), .in1(sum6), .in2(carry6));

//Sign extend 32 bit multiplier output to 40 bit to make it ready for adding in accumulator
for(i=32; i<40; i=i+1) begin
  assign mult_out[i] = mult_out[31];
end

//Add new multiplier output to accumulator registor's previous value
carrySelectAdder40bit cla1(.sum(new_acc), .in1(mult_out), .in2(acc));


//Wires for determining whether the output needs to be
//rounded up or down to get final 27 bit output
wire a,b,c,d,e,f,g,h,j,k,l,m,OR;

//Flag telling whether we need to round up or round down.
//For round up: up_down_select = 1;
////For round down: up_down_select = 0;
wire up_down_select;

//Combinational circuit to determine up_down_select flag
nor(a,acc[1],acc[0]);
nor(b,acc[3],acc[2]);
nor(c,acc[5],acc[4]);
nor(d,acc[7],acc[6]);
nor(e,acc[9],acc[8]);
nor(f,acc[11],acc[10]);
and(g,a,b);
and(h,c,d);
and(m,e,f);
and(j,h,m);
nand(OR,g,j);

nand(k,acc[12],acc[13]);
nand(l,acc[12],OR);
nand(up_down_select,k,l);

//Wires for rouned up output and final rounded off output
wire [27:0] out_up;
wire [26:0] out_rounded_wire;

//Calculate rounded up value. Used 28bit adder instead of 27 bit because CSeLA is 
//implemented using 4-bit CSeLA.
carrySelectAdder28bit add0(out_up, acc[39:13], 28'b0000000000000000000000000001);

//Combinational circuit with 2:1 Mux to get final rounded off output based on up_down_select flag
mux2to1 m0(out_rounded_wire[0], up_down_select, acc[13], out_up[0]);
mux2to1 m1(out_rounded_wire[1], up_down_select, acc[14], out_up[1]);
mux2to1 m2(out_rounded_wire[2], up_down_select, acc[15], out_up[2]);
mux2to1 m3(out_rounded_wire[3], up_down_select, acc[16], out_up[3]);
mux2to1 m4(out_rounded_wire[4], up_down_select, acc[17], out_up[4]);
mux2to1 m5(out_rounded_wire[5], up_down_select, acc[18], out_up[5]);
mux2to1 m6(out_rounded_wire[6], up_down_select, acc[19], out_up[6]);
mux2to1 m7(out_rounded_wire[7], up_down_select, acc[20], out_up[7]);
mux2to1 m8(out_rounded_wire[8], up_down_select, acc[21], out_up[8]);
mux2to1 m9(out_rounded_wire[9], up_down_select, acc[22], out_up[9]);
mux2to1 m10(out_rounded_wire[10], up_down_select, acc[23], out_up[10]);
mux2to1 m11(out_rounded_wire[11], up_down_select, acc[24], out_up[11]);
mux2to1 m12(out_rounded_wire[12], up_down_select, acc[25], out_up[12]);
mux2to1 m13(out_rounded_wire[13], up_down_select, acc[26], out_up[13]);
mux2to1 m14(out_rounded_wire[14], up_down_select, acc[27], out_up[14]);
mux2to1 m15(out_rounded_wire[15], up_down_select, acc[28], out_up[15]);
mux2to1 m16(out_rounded_wire[16], up_down_select, acc[29], out_up[16]);
mux2to1 m17(out_rounded_wire[17], up_down_select, acc[30], out_up[17]);
mux2to1 m18(out_rounded_wire[18], up_down_select, acc[31], out_up[18]);
mux2to1 m19(out_rounded_wire[19], up_down_select, acc[32], out_up[19]);
mux2to1 m20(out_rounded_wire[20], up_down_select, acc[33], out_up[20]);
mux2to1 m21(out_rounded_wire[21], up_down_select, acc[34], out_up[21]);
mux2to1 m22(out_rounded_wire[22], up_down_select, acc[35], out_up[22]);
mux2to1 m23(out_rounded_wire[23], up_down_select, acc[36], out_up[23]);
mux2to1 m24(out_rounded_wire[24], up_down_select, acc[37], out_up[24]);
mux2to1 m25(out_rounded_wire[25], up_down_select, acc[38], out_up[25]);
mux2to1 m26(out_rounded_wire[26], up_down_select, acc[39], out_up[26]);

//Always block to run on every +ve clock edge
always @ (posedge clk)
begin

//If MAC is ready to produce first output, start count.
if(setup_count == 3 && !setup_completed && rst)
begin
setup_completed <= 1;
MD <= md;
MR <= mr;
PP0_reg <= PP0_FULL;
PP1_reg <= PP1_FULL;
PP2_reg <= PP2_FULL;
PP3_reg <= PP3_FULL;
PP4_reg <= PP4_FULL;
PP5_reg <= PP5_FULL;
PP6_reg <= PP6_FULL;
PP7_reg <= PP7_FULL;
PP8_reg <= PP8_FULL;
acc <= new_acc;
out_rounded <= out_rounded_wire;
count <= 1;
end

//If setup is not yet completed keep passing data to next registors
else if(!setup_completed && rst)
begin
MD <= md;
MR <= mr;
PP0_reg <= PP0_FULL;
PP1_reg <= PP1_FULL;
PP2_reg <= PP2_FULL;
PP3_reg <= PP3_FULL;
PP4_reg <= PP4_FULL;
PP5_reg <= PP5_FULL;
PP6_reg <= PP6_FULL;
PP7_reg <= PP7_FULL;
PP8_reg <= PP8_FULL;
acc <= new_acc;
out_rounded <= out_rounded_wire;
setup_count <= setup_count + 1;
end

//If main counter has started and no reset signal is given (Reset is active low).
if(count != 0 && rst)
begin
MD <= md;
MR <= mr;
PP0_reg <= PP0_FULL;
PP1_reg <= PP1_FULL;
PP2_reg <= PP2_FULL;
PP3_reg <= PP3_FULL;
PP4_reg <= PP4_FULL;
PP5_reg <= PP5_FULL;
PP6_reg <= PP6_FULL;
PP7_reg <= PP7_FULL;
PP8_reg <= PP8_FULL;
acc <= new_acc;
count <= count + 1;
out_rounded <= out_rounded_wire;
end

//If reset signal is recieved. Reset all registors. Reset is active low.
if(!rst)
begin
acc <= 0;
MD <= 0;
MR <= 0;
out_rounded <= 0;
setup_count <= 0;
setup_completed <= 0;
count <= 0;
PP0_reg <= 0;
PP1_reg <= 0;
PP2_reg <= 0;
PP3_reg <= 0;
PP4_reg <= 0;
PP5_reg <= 0;
PP6_reg <= 0;
PP7_reg <= 0;
PP8_reg <= 0;
end

//If all 256 operations are completed, reset all registors to 0.
if(count == 256)
begin
acc <= 0;
out_rounded <= 0;
setup_count <= 1;
setup_completed <= 0;
count <= 0;
PP0_reg <= 0;
PP1_reg <= 0;
PP2_reg <= 0;
PP3_reg <= 0;
PP4_reg <= 0;
PP5_reg <= 0;
PP6_reg <= 0;
PP7_reg <= 0;
PP8_reg <= 0;
end

end
endmodule

