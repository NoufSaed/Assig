
module top;
// SYSTEMVERILOG: timeunit and timeprecision specification
timeunit 1ns;
timeprecision 1ns;
logic         clk =0;
parameter DATA_WIDTH = 8;
parameter DEPTH = 32;
fifo_intf  #(DATA_WIDTH) mif (clk); 
always #5 clk = ~clk;

fifo_test #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH) )  test (.clk(clk), .mif(mif.TB));

synchronous_fifo #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH) )  memory ( .clk(mif.clk),
  .rst_n(mif.rst_n),
  .w_en(mif.wr_en),
  .r_en(mif.rd_en),
  .data_in(mif.data_in),
  .data_out(mif.data_out),
  .full(mif.full),
  .empty(mif.empty));
    
    
    //(.clk(clk), .mif(mif.DUT)    );

endmodule
