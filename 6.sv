 
module single_port_ram #( 
    parameter DATA_WIDTH = 8, 
    parameter ADDR_WIDTH = 4 
) 
( 
    input logic clk, we, 
    input logic [ADDR_WIDTH-1:0] addr, 
    input logic [DATA_WIDTH-1:0] din, 
    output logic [DATA_WIDTH-1:0] dout 
); 
    logic [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0]; 
     
    always_ff @(posedge clk) begin 
        if (we) 
            ram[addr] <= din;  
    end 
     
    always_ff @(posedge clk) begin 
        dout <= ram[addr];  
    end 
endmodule 
 
module dual_port_ram #( 
    parameter DATA_WIDTH = 8, 
    parameter ADDR_WIDTH = 4 
)  
( 
    input logic clk, 
    input logic we1, we2, 
    input logic [ADDR_WIDTH-1:0] addr1, addr2, 
    input logic [DATA_WIDTH-1:0] din1, din2, 
    output logic [DATA_WIDTH-1:0] dout1, dout2 
); 
    logic [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0]; 
     
    always_ff @(posedge clk) begin 
        if (we1 && !(we2 && addr1 == addr2)) 
            ram[addr1] <= din1; 
        if (we2) 
            ram[addr2] <= din2; 
    end 
     
    always_ff @(posedge clk) begin
        dout1 <= ram[addr1]; 
        dout2 <= ram[addr2]; 
    end 
endmodule 
 
covergroup single_port_coverage @(posedge clk); 
    coverpoint we { bins write = {1}; bins read = {0}; } 
    coverpoint addr { bins addr_bins[] = {[0:15]}; } 
    coverpoint din; 
    cross we, addr, din; 
endgroup 
 
module single_port_tb; 
    logic clk, we; 
    logic [3:0] addr; 
    logic [7:0] din, dout; 
    single_port_ram uut (.clk(clk), .we(we), .addr(addr), .din(din), .dout(dout)); 
    single_port_coverage cov = new(); 
     
    always #5 clk = ~clk; 
     
    initial begin 
        clk = 0; we = 0; addr = 0; din = 0; 
        repeat (10) begin 
            #10 assert(std::randomize(we, addr, din)); 
            cov.sample(); 
        end 
        #50 $finish; 
    end 
endmodule 
 
covergroup dual_port_coverage @(posedge clk); 
    coverpoint we1; 
    coverpoint we2; 
    coverpoint addr1; 
    coverpoint addr2; 
    coverpoint din1; 
    coverpoint din2; 
    cross we1, we2, addr1, addr2, din1, din2; 
endgroup 
 
module dual_port_tb; 
    logic clk, we1, we2; 
    logic [3:0] addr1, addr2; 
    logic [7:0] din1, din2, dout1, dout2; 
    dual_port_ram uut (.clk(clk), .we1(we1), .we2(we2), .addr1(addr1), .addr2(addr2), .din1(din1), 
.din2(din2), .dout1(dout1), .dout2(dout2));
    dual_port_coverage cov = new(); 
     
    always #5 clk = ~clk; 
     
    initial begin 
        clk = 0; we1 = 0; we2 = 0; addr1 = 0; addr2 = 0; din1 = 0; din2 = 0; 
        repeat (10) begin 
            #10 assert(std::randomize(we1, we2, addr1, addr2, din1, din2)); 
            cov.sample(); 
        end 
        #50 $finish; 
    end 
endmodule 
