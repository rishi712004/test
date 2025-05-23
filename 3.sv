 
Inline Constraint 
 
class Item; 
  rand bit [7:0] id; 
  constraint c_id { id < 25; } 
endclass 
 
module tb; 
  initial begin 
    Item itm = new (); 
    itm.randomize() with { id == 10; };  
    $display ("Item Id = %0d", itm.id); 
  end 
endmodule 
 
output: Item Id = 10 
 
Solve before 
  
 
Random Distribution Example 
class ABC; 
 rand bit [2:0]  b; 
endclass 
 
module tb; 
 initial begin 
  ABC abc = new; 
  for (int i = 0; i < 10; i++) begin 
   abc.randomize(); 
   $display ("b=%0d", abc.b); 
  end 
 end 
endmodule 
 
with solve before 
 
class ABC; 
  rand  bit a; 
  rand  bit [1:0] b; 
  constraint c_ab { a -> b == 3'h3;
                   solve a before b; 
                  } 
endclass 
 
module tb; 
  initial begin 
    ABC abc = new; 
    for (int i = 0; i < 8; i++) begin 
      abc.randomize(); 
      $display ("a=%0d b=%0d", abc.a, abc.b); 
    end 
  end 
endmodule
 
 
 
 
