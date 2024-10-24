`ifndef FIFO_MEM
`define FIFO_MEM

module fifo_mem #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
  )(
  input wclken, wfull, wclk,
  input [ADDR_WIDTH -1:0] waddr, raddr,
  input [DATA_WIDTH -1:0] wdata,
  output reg [DATA_WIDTH -1:0] rdata
);
  
  localparam FIFO_DEPTH = 1<<ADDR_WIDTH;
  reg [DATA_WIDTH -1:0] fifo_mem [0:FIFO_DEPTH -1];

  assign rdata = fifo_mem[raddr];
  always_ff @(posedge wclk) begin
    if(wclken && !wfull) fifo_mem[waddr] <= wdata;
  end
endmodule
`endif
