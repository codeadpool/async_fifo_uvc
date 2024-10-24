`ifndef SYNC_W2R
`define SYNC_W2R
module sync_w2r #(
  parameter PTR_WIDTH = 8;
  )(
  input rclk, rrst_n,
  input [PTR_WIDTH -1:0] w_ptr,
  output reg [PTR_WIDTH -1:0] rq2_wptr
);
  
  reg [PTR_WIDTH -1:0] rq1_wptr;
  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n) begin
      rq1_wptr <=0;
      rq2_wptr <=0;
    end else begin
      rq1_wptr <=w_ptr;
      rq2_wptr <=rq1_wptr;
    end
  end
endmodule
`endif
