//All in one radix 4 16-bit booth encoder decoder to generate 18 bit partial products

module boothEncoderDecoder(PPIJ, BIP1, BI, BIM1, AJ, AJM1);
//Partial product bit
output PPIJ;
input BIP1, BI, BIM1, AJ, AJM1;

wire a,b,c,d,e,f,g,h,i;

//Combinational circuit to determine individual bits of partial product.
xor(a,BI,BIM1);
xor(b,BIP1,BI);
xor(c,BIP1,AJM1);
xor(d,BI,BIM1);
xor(e,BIP1,AJ);
nand(f,b,c);
nand(g,d,e);
nor(h,a,f);
not(i,h);
nand(PPIJ,i,g);

endmodule  