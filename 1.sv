module tb; 
 bit [7:0] m_data;   
 initial begin  
  m_data = 8'hA2; 
  for (int i = 0; i < $size(m_data); i++) begin 
   $display ("m_data[%0d] = %b", i, m_data[i]); 
  End 
 end 
 
module tb;  
   string   fruits[$] =  { "orange", "apple", "kiwi" }; 
 initial begin 
    foreach (fruits[i]) 
      $display ("fruits[%0d] = %s", i, fruits[i]); 
    $display ("fruits = %p", fruits);
       fruits = {}; 
       $display ("After deletion, fruits = %p", fruits); 
 end 
endmodule
    
module tb; 
 typedef enum {TRUE, FALSE} e_true_false; 
 initial begin 
  e_true_false  answer; 
  answer = TRUE; 
  $display ("answer = %s", answer.name); 
 end 
endmodule 
