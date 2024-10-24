`ifndef FIFO_TOP
`define FIFO_TOP
module fifo_top #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
  )(
  input [DATA_WIDTH -1:0] wdata,
  input winc, wclk, wrst_n,
  input rinc, rclk, rrst_n,

  output [DATA_WIDTH -1:0] rdata,
  output wfull, rempty
);

  wire [ADDR_WIDTH -1:0] waddr, raddr;
  wire [ADDR_WIDTH :0] w_ptr, rd_ptr, wq2_rptr, rq2_wptr;

  sync_r2w sync_r2w(
    .wclk     (wclk),
    .wrst_n   (wrst_n),
    .rd_ptr   (rd_ptr),
    
    .wq2_rptr (wq2_rptr)
  );

  sync_w2r sync_w2r(
    .rclk     (rclk),
    .rrst_n   (rrst_n),
    .w_ptr    (w_ptr),

    .rq2_wptr (rq2_wptr)
  );
  
  rd_ptr_empty rd_ptr_empty(
    .rinc     (rinc), 
    .rclk     (rclk),
    .rrst_n   (rrst_n), 
    .rq2_wptr (rq2_wptr),

    .rempty   (rempty),
    .raddr    (raddr),
    .rd_ptr   (rd_ptr)
  );

  w_ptr_full wptr_full(
    .winc     (winc), 
    .wclk     (wclk),
    .wrst_n   (wrst_n),
    .wq2_rptr (wq2_rptr),

    .wfull    (wfull),
    .waddr    (waddr),
    .w_ptr    (w_ptr)
  );

  fifomem fifomem(
    .wdata    (wdata),
    .waddr    (waddr),
    .raddr    (raddr),
    .wclken   (winc),
    .wfull    (wfull),
    .wclk     (wclk),

    .rdata(rdata)
  );
endmodule
`endif
