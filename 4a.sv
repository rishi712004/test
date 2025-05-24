module counter (  
input logic clk,  
input logic reset,  
output logic [3:0] count  
);   
always_ff @(posedge clk or posedge reset) begin  
if (reset)  
count <= 4'b0000; // Reset to 0  
else  
count <= count + 1;  
end  
assert property (@(posedge clk) disable iff (reset) 
count == count[3:0] + 1)  
else $fatal("Counter did not increment by 1 at 
me %0t.", $me);   
assert property (@(posedge clk) disable iff (reset) 
count < 16)  
else $fatal("Counter overflow detected at me 
%0t.", $me);  
endmodule  
  
module tb_counter;    
logic clk;  
logic reset;  
logic [3:0] count; 
counter uut (  
.clk(clk),  
.reset(reset),  
.count(count)  
);   
always begin  
#5 clk = ~clk;  
end   
ini al begin   
clk = 0;  
reset = 0;   
reset = 1;   
#10 reset = 0;  
#100;   
$stop;  
end   
ini al begin  
$monitor("Time = %0t, clk = %b, reset = %b, count 
= %d", $me, clk, reset, count);  
end   
endmodule
