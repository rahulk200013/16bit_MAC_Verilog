module carryLookAheadAdder4bit(sum, cout, a, b, c0);
output [3:0] sum;
output cout;
input [3:0] a,b;
input c0;

wire p0,p1,p2,p3,p0not,p1not,p2not,p3not;
wire g0,g1,g2,g3,g0not,g1not,g2not,g3not;
wire c1,c2,c3,c0not;

not(c0not,c0);

nand(g0not,a[0],b[0]);
not(g0,g0not);
xnor(p0not,a[0],b[0]);
not(p0,p0not);

nand(g1not,a[1],b[1]);
not(g1,g1not);
xnor(p1not,a[1],b[1]);
not(p1,p1not);

nand(g2not,a[2],b[2]);
not(g2,g2not);
xnor(p2not,a[2],b[2]);
not(p2,p2not);

nand(g3not,a[3],b[3]);
not(g3,g3not);
xnor(p3not,a[3],b[3]);
not(p3,p3not);

cy1 carry1(.c1(c1),.p0(p0),.c0(c0),.g0not(g0not));
cy2 carry2(.c2(c2),.p0(p0),.p1(p1),.c0not(c0not),.g0(g0),.g1not(g1not));
cy3 carry3(.c3(c3),.p1(p1),.p2(p2),.p0not(p0not),.c0(c0),.g0not(g0not),.g1(g1),.g2not(g2not));
cy4 carry4(.c4(cout),.p2(p2),.p3(p3),.p1(p1),.p0(p0),.c0not(c0not),.g0(g0),.g1(g1),.g2(g2),.g3(g3));

xor(sum[0],p0,c0);
xor(sum[1],p1,c1);
xor(sum[2],p2,c2);
xor(sum[3],p3,c3);

endmodule 

module cy1(c1,p0,c0,g0not);
output c1;
input p0,c0,g0not;

wire a;

nand(a,p0,c0);
nand(c1,a,g0not);

endmodule

module cy2(c2,p0,p1,c0not,g0,g1not);
output c2;
input p0,p1,c0not,g0,g1not;

wire a,b,c,d;

nand(a,p0,p1);
nor(c,a,c0not);
nand(b,p1,g0);
nand(d,b,g1not);
or(c2,c,d);

endmodule

module cy3(c3,p1,p2,p0not,c0,g0not,g1,g2not);
output c3;
input p1,p2,p0not,c0,g0not,g1,g2not;

wire a,b,c,e,f,g,h;

nand(a,p1,p2);
or(g,a,g0not);
nand(b,p2,g1);
nor(c,a,p0not);
nand(e,b,g2not);
nand(f,c,c0);
nand(h,f,g);
or(c3,h,e);

endmodule 

module cy4(c4,p2,p3,p1,p0,c0not,g0,g1,g2,g3);
output c4;
input p2,p3,p1,p0,c0not,g0,g1,g2,g3;

wire a,b,c,d,e,f,g,h,i,j,k,l,m;

and(a,p3,g2);
and(b,p3,p2);
nand(c,p3,p2);
nand(d,p1,g0);
nand(e,p3,p2);
nand(f,p1,p0);
nor(g,g3,a);
nand(h,b,g1);
or(i,c,d);
or(j,e,f);
and(k,h,i);
or(l,j,c0not);
and(m,k,l);
nand(c4,g,m);

endmodule 