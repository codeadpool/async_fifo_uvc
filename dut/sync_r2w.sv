`ifndef SYNC_R2W
`define SYNC_R2W
module sync_r2w #(
  parameter PTR_WIDTH = 8
  )(
  input wclk, wrst_n,
  input [PTR_WIDTH -1:0] rd_ptr,
  output reg [PTR_WIDTH -1:0] wq2_rptr
);
  // temp ff
  reg [PTR_WIDTH -1:0] wq1_rptr;
  // usng multiple ffs for synchornizing, metastability issues
  always_ff @(posedge wclk or negedge wrst_n) begin 
    if(!wrst_n) begin
      wq1_rptr <=0;
      wq2_rptr <=0;
    end else begin
      wq1_rptr <=rptr;
      wq2_rptr <=wq1_rptr;
    end
  end
endmodule
`endif
