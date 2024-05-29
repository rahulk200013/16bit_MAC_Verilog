module fullAdder(sum,cout,a,b,cin);
output sum,cout;
input a,b,cin;

wire m,n,o;

//Determine sum and carry
xor(m,a,b);
and(n,a,b);
xor(sum,m,cin);
and(o,m,cin);
or(cout,o,n);

endmodule 
