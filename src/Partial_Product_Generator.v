module partialProductGenerator(PP, neg, MD, MRIP1, MRI, MRIM1);
output [17:0] PP;
output neg;

//Multiplicand
input [15:0] MD;

//Multiplier i bit(MRI), i+1 bit (MRIP1), and i-1 bit (MRIM1) to determine
//which operation needs to be done on Multiplicand to get partial product
input MRIP1, MRI, MRIM1;

//Determine each bit of partial product based on multiplicand and multiplier.
boothEncoderDecoder PP0(PP[0], MRIP1, MRI, MRIM1, MD[0], 1'b0);
boothEncoderDecoder PP1(PP[1], MRIP1, MRI, MRIM1, MD[1], MD[0]);
boothEncoderDecoder PP2(PP[2], MRIP1, MRI, MRIM1, MD[2], MD[1]);
boothEncoderDecoder PP3(PP[3], MRIP1, MRI, MRIM1, MD[3], MD[2]);
boothEncoderDecoder PP4(PP[4], MRIP1, MRI, MRIM1, MD[4], MD[3]);
boothEncoderDecoder PP5(PP[5], MRIP1, MRI, MRIM1, MD[5], MD[4]);
boothEncoderDecoder PP6(PP[6], MRIP1, MRI, MRIM1, MD[6], MD[5]);
boothEncoderDecoder PP7(PP[7], MRIP1, MRI, MRIM1, MD[7], MD[6]);
boothEncoderDecoder PP8(PP[8], MRIP1, MRI, MRIM1, MD[8], MD[7]);
boothEncoderDecoder PP9(PP[9], MRIP1, MRI, MRIM1, MD[9], MD[8]);
boothEncoderDecoder PP10(PP[10], MRIP1, MRI, MRIM1, MD[10], MD[9]);
boothEncoderDecoder PP11(PP[11], MRIP1, MRI, MRIM1, MD[11], MD[10]);
boothEncoderDecoder PP12(PP[12], MRIP1, MRI, MRIM1, MD[12], MD[11]);
boothEncoderDecoder PP13(PP[13], MRIP1, MRI, MRIM1, MD[13], MD[12]);
boothEncoderDecoder PP14(PP[14], MRIP1, MRI, MRIM1, MD[14], MD[13]);
boothEncoderDecoder PP15(PP[15], MRIP1, MRI, MRIM1, MD[15], MD[14]);
boothEncoderDecoder PP16(PP[16], MRIP1, MRI, MRIM1, MD[15], MD[15]);
boothEncoderDecoder PP17(PP[17], MRIP1, MRI, MRIM1, MD[15], MD[15]);

//Determine what negate bit to be passed on to next partial product to get
//complete 2's complement if needed
getNegBit n0(neg,MD[15],PP[17],MRIP1, MRI, MRIM1);

endmodule

//Module to determine negate bit based on if -ve operation needs to be done on multiplicand.
module getNegBit(neg,MD_MSB, PP_MSB,MRIP1, MRI, MRIM1);
output neg;
input MRIP1, MRI, MRIM1, MD_MSB, PP_MSB;

wire all_1, all_0, a,b,c,d,e,f;

nand(a,MRIP1,MRI);
not(b,MRIM1);
nor(all_1,a,b);

nor(c,MRIP1,MRI);
not(d,MRIM1);
and(all_0,c,d);

nor(e,all_0,all_1);

xor(f,PP_MSB,MD_MSB);
and(neg,e,f);

endmodule


//Module to generate all 9 18-bit partial products
module generatePartialProducts(PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7,PP8,neg,MD,MR);
output [17:0] PP0,PP1,PP2,PP3,PP4,PP5,PP6,PP7,PP8;
output [7:0] neg;
input [15:0] MD, MR;

wire not_used;

//Calculate all 9 18-bit partial products
partialProductGenerator P0(PP0, neg[0], MD, MR[1], MR[0], 1'b0);
partialProductGenerator P1(PP1, neg[1], MD, MR[3], MR[2], MR[1]);
partialProductGenerator P2(PP2, neg[2], MD, MR[5], MR[4], MR[3]);
partialProductGenerator P3(PP3, neg[3], MD, MR[7], MR[6], MR[5]);
partialProductGenerator P4(PP4, neg[4], MD, MR[9], MR[8], MR[7]);
partialProductGenerator P5(PP5, neg[5], MD, MR[11], MR[10], MR[9]);
partialProductGenerator P6(PP6, neg[6], MD, MR[13], MR[12], MR[11]);
partialProductGenerator P7(PP7, neg[7], MD, MR[15], MR[14], MR[13]);
partialProductGenerator P8(PP8, not_used, MD, MR[15] ,MR[15], MR[15]);

endmodule

