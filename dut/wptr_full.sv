`ifndef WPTR_FULL
`define WPTR_FULL
module wptr_full #(
  parameter PTR_wIDTH = 8;
  )(
  input winc, wclk, wrst_n,
  input [PTR_wIDTH :0] wq2_rptr,
  output reg [PTR_wIDTH :0] w_ptr,
  output [PTR_wIDTH -1:0] waddr,
  output reg wfull
);
 
  reg [PTR_wIDTH :0] w_bin;
  wire [PTR_wIDTH :0] w_gray_next, w_bin_next;
  
  always_ff @(posedge wclk or negedge wrst_n) begin 
    if(!wrst_n) begin
      w_bin <=0;
      w_ptr <=0;
    end else begin
      w_bin <= w_bin_next;
      w_ptr <=w_gray_next;
    end
  end
  
  assign waddr = w_bin[PTR_wIDTH -1:0];
  assign w_bin_next = wbin +(winc & ~wfull);
  assign w_gray_next = (w_bin_next >>1) ^ w_bin_next;

  assign wfull_val = (w_gray_next == {~wq2_rptr[PTR_wIDTH:PTR_wIDTH -1],wq2_rptr[PTR_wIDTH -2:0]});

  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n)
      wfull <='b0;
    else 
      wfull <=wfull_val;
  end
endmodule
`endif
