`ifndef RD_PTR_EMPTY
`define RD_PTR_EMPTY
module rd_ptr_empty #(
  parameter PTR_WIDTH = 8;
  )(
  input rinc, rclk, rrst_n,
  input [PTR_WIDTH :0] rq2_wptr,

  output reg [PTR_WIDTH :0] rd_ptr,
  output [PTR_WIDTH -1:0] raddr,
  output reg rempty
);
  
  reg  [PTR_WIDTH :0] r_bin;
  wire [PTR_WIDTH :0] r_gray_next, r_bin_next;

  always_ff @(posedge rclk or negedge rrst_n) begin 
    if(!rrst_n)begin
      r_bin  <=0;
      rd_ptr <=0;
    end else begin
      r_bin <= r_bin_next;
      rd_ptr <= r_gray_next;
    end 
  end

  always_ff @(posedge rclk or negedge rrst_n) begin
    if(!rrst_n)
      rempty <='b1;
    else 
      rempty <=rempty_val;
  end

  assign raddr = r_bin[rd_ptr -1:0];
  assign r_bin_next = r_bin + (rinc & ~rempty);
  assign r_gray_next = (r_bin_next >>1) ^ r_bin_next;

  assign rempty_val = (r_gray_next == rq2_wptr);
endmodule
`endif
