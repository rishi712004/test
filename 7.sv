module sync_fifo #(parameter DEPTH = 8, WIDTH = 8) ( 
input logic clk, rst, wr_en, rd_en, 
input logic [WIDTH-1:0] din, 
output logic [WIDTH-1:0] dout, 
output logic full, empty 
); 
logic [WIDTH-1:0] mem [DEPTH-1:0]; 
logic [$clog2(DEPTH):0] wptr, rptr; 
assign full  = (wptr == DEPTH-1); 
assign empty = (wptr == rptr); 
always_ff @(posedge clk or posedge rst) begin 
if (rst) begin 
wptr <= 0; 
rptr <= 0; 
end else begin 
if (wr_en && !full) begin 
mem[wptr] <= din; 
wptr <= wptr + 1; 
end 
if (rd_en && !empty) begin 
dout <= mem[rptr]; 
rptr <= rptr + 1; 
end 
end 
end 
endmodule
module async_fifo #(parameter DEPTH = 8, WIDTH = 8) ( 
input logic wclk, rclk, rst, wr_en, rd_en, 
input logic [WIDTH-1:0] din, 
output logic [WIDTH-1:0] dout, 
output logic full, empty 
); 
logic [WIDTH-1:0] mem [DEPTH-1:0]; 
logic [$clog2(DEPTH):0] wptr, rptr;
     logic [$clog2(DEPTH):0] wptr_gray, rptr_gray; 
     
    function automatic logic [$clog2(DEPTH):0] bin2gray(logic [$clog2(DEPTH):0] bin); 
        return (bin >> 1) ^ bin; 
    endfunction 
        assign full  = (wptr_gray == bin2gray(rptr + 1)); 
    assign empty = (rptr_gray == wptr_gray); 
     
    always_ff @(posedge wclk or posedge rst) begin 
        if (rst) begin 
            wptr <= 0; 
            wptr_gray <= 0; 
        end else if (wr_en && !full) begin 
            mem[wptr] <= din; 
            wptr <= wptr + 1; 
            wptr_gray <= bin2gray(wptr + 1); 
        end 
    end 
     
    always_ff @(posedge rclk or posedge rst) begin 
        if (rst) begin 
            rptr <= 0; 
            rptr_gray <= 0; 
        end else if (rd_en && !empty) begin 
            dout <= mem[rptr]; 
            rptr <= rptr + 1; 
            rptr_gray <= bin2gray(rptr + 1); 
        end 
    end
module fifo_tb; 
    logic clk, rst, wr_en, rd_en; 
    logic [7:0] din, dout; 
    logic full, empty; 
     
    sync_fifo #(.DEPTH(8), .WIDTH(8)) dut ( 
        .clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en), .din(din), .dout(dout), .full(full), .empty(empty) 
    ); 
     
    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end 

endmodule
     
    initial begin 
        rst = 1; wr_en = 0; rd_en = 0; din = 0; 
        #10 rst = 0; 
        #10 wr_en = 1; din = 8'hAA;  
        #10 wr_en = 1; din = 8'hBB;  
        #10 wr_en = 0; rd_en = 1; 
        #10 rd_en = 0; 
        #50 $finish; 
    end 
    covergroup fifo_cov; 
        coverpoint wr_en; 
        coverpoint rd_en; 
        coverpoint full; 
        coverpoint empty; 
    endgroup 
     
    fifo_cov cov_inst = new(); 
        always @(posedge clk) begin 
        cov_inst.sample(); 
        assert (!(full && wr_en)) else $error("Write attempted on full FIFO"); 
        assert (!(empty && rd_en)) else $error("Read attempted on empty FIFO"); 
    end 
endmodule
