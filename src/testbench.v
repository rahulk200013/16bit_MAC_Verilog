`timescale 1ps/1ps

module testMAC;
  //Input multiplicand and multiplier a & b respectively
  reg [15:0] a, b;
  reg clk, rst;

  //Wire for 27-bit final rounded off output
  wire [26:0] out_rounded;

  //Support variable for proper functioning of testbench
  //NOTE: below count variables has nothing to do with actual main counter in RTL
  integer count, setup_count, accumulation_shown;

  //Real variable to store fractional decimal values of output to display in transcript/console
  real a_fractional,b_fractional,out_fractional;

//Instantiate MAC module
mac_16bit mac0(out_rounded,a,b,clk,rst);

//Invert clock on every 5ps
//Since it's ideal simulation, we don't need to use actual time period.
always #5 clk = ~clk;

initial begin

//Send reset signal to MAC. (Reset is active low).
clk = 1;
rst = 0;
count = 0;
setup_count = 0;
accumulation_shown = 0;

#6
rst = 1;

//Send first corner case
a = 16'b1000_000000000000;  //-8

b = 16'b1000_000000000000;  //-8

//Wait for all 256 cycles to complete
#2600

//Reset MAC
rst = 0;

//Send second corner case
a = 16'b0111_111111111111; //+7.999755859375
 
b = 16'b1000_000000000000; //-8

#10
//Set reset to high and enable MAC
rst = 1;

//Wait for all 256 cycles to complete
#2610

//Reset MAC
rst = 0;

//Send Third corner case
a = 16'b0111_111111111111; //+7.999755859375

b = 16'b0111_111111111111; //+7.999755859375

#10
//Set reset to high and enable MAC
rst =1;

end

//Always block to convert binary fraction to decimal fraction to display on transcript/console
always @ (posedge clk)
begin
count = count + 1;

if(a[15] == 0)
a_fractional = (a*(2.0**-12));
else
a_fractional = -(-a*(2.0**-12));

if(b[15] == 0)
b_fractional = (b*(2.0**-12));
else
b_fractional = -(-b*(2.0**-12));

if(out_rounded[26] == 0)
out_fractional = (out_rounded*(2.0**-11));
else
out_fractional = -(-out_rounded*(2.0**-11));

//Show all accumulation result for first corner case
if(accumulation_shown == 0)
$display ("  MD: %f   MR: %f   Simulation Output: %f", a_fractional, b_fractional, out_fractional); 

//Check if first corner case test is successful or not
if(count == 261) begin

accumulation_shown = 1;
$display(" ");
$display(" ");
$display(" ");

//Compare output with actual output
if(out_fractional == 16384.0)
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: 16384  Test: Successful", a_fractional, b_fractional, out_fractional); 
else
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: 16384  Test: Failed", a_fractional, b_fractional, out_fractional); 
end

//Check if second corner case test is successful or not
else if(count == 522)begin

//Compare output with actual output
if(out_fractional == -16383.5)
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: -16383.5  Test: Successful", a_fractional, b_fractional, out_fractional); 
else
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: -16383.5  Test: Failed", a_fractional, b_fractional, out_fractional);
end

//Check if third corner case test is successful or not
else if(count == 784) begin

//Compare output with actual output
if(out_fractional == 16383)
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: 16383  Test: Successful", a_fractional, b_fractional, out_fractional); 
else
$display ("  MD: %f   MR: %f   Simulation Output: %f  Correct Output: 16383  Test: Failed", a_fractional, b_fractional, out_fractional);
end

end

endmodule
