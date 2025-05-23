
interface apb_if(input logic PCLK, PRESETn); 
logic PSEL, PENABLE, PWRITE; 
logic [31:0] PADDR, PWDATA, PRDATA; 
logic PREADY, PSLVERR; 
modport master (output PSEL, PENABLE, PWRITE, PADDR, PWDATA, input PRDATA, PREADY, 
PSLVERR); 
modport slave  (input PSEL, PENABLE, PWRITE, PADDR, PWDATA, output PRDATA, PREADY, 
PSLVERR); 
endinterface 
module apb_master(apb_if.master apb); 
initial begin 
apb.PSEL = 0; 
apb.PENABLE = 0; 
apb.PWRITE = 0; 
apb.PADDR = 0; 
apb.PWDATA = 0; 
#10; 
apb.PSEL = 1; 
apb.PWRITE = 1; 
apb.PADDR = 32'h00000004; 
apb.PWDATA = 32'hA5A5A5A5; 
#10; 
apb.PENABLE = 1; 
#10; 
apb.PSEL = 0; 
apb.PENABLE = 0; 
end 
endmodule 
module apb_slave(apb_if.slave apb); 
always_ff @(posedge apb.PCLK or negedge apb.PRESETn) begin 
if (!apb.PRESETn) begin 
apb.PREADY  <= 0; 
apb.PSLVERR <= 0; 
end else if (apb.PSEL && apb.PENABLE) begin 
apb.PREADY  <= 1; 
apb.PSLVERR <= 0; 
apb.PRDATA  <= (apb.PWRITE) ? 32'h00000000 : 32'hDEADBEEF;
end else begin 
apb.PREADY  <= 0; 
end 
end 
endmodule 
module apb_tb; 
logic PCLK, PRESETn; 
apb_if apb(PCLK, PRESETn); 
apb_master master (.apb(apb)); 
apb_slave slave (.apb(apb));  
initial begin 
PCLK = 0; 
forever #5 PCLK = ~PCLK; 
end 
initial begin 
PRESETn = 0; 
#10 PRESETn = 1; 
end 
endmodule 
