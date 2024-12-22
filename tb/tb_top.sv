module tb_top#(
  parameter int FIFO_DEPTH = 32;
  )(
);
  import uvm_pkg::*;
  import afifo_test_pkg::*;

  logic wr_clk, rd_clk, rst_n;
  real wr_freq_mhz, rd_freq_mhz;

  // Clock generation
  clkgen #(.FREQ_MHZ(wr_freq_mhz), .JITTER_PERCENT(1.0)) wr_clk_gen (.clk(wr_clk));
  clkgen #(.FREQ_MHZ(rd_freq_mhz), .JITTER_PERCENT(1.0)) rd_clk_gen (.clk(rd_clk));

  afifo_dut dut (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst_n(rst_n),
  );

  afifo_wr_if wr_if (.clk(wr_clk), .rst_n(rst_n));
  afifo_rd_if rd_if (.clk(rd_clk), .rst_n(rst_n));

  initial begin
    wr_freq_mhz = 100.0;
    rd_freq_mhz = 75.0;

    uvm_config_db#(int)::set(null, "*", "FIFO_DEPTH", FIFO_DEPTH);

    uvm_config_db#(virtual afifo_wr_if)::set(null, "*", "wr_vif", wr_if);
    uvm_config_db#(virtual afifo_rd_if)::set(null, "*", "rd_vif", rd_if);
    
    // For backpressure test
    // uvm_config_db#(uvm_config_wrapper)::set(null, "*.afifo_test", "vseq_type", 
    //                                     afifo_backpressure_vseq::type_id::get())

    // For full/empty test
    // uvm_config_db#(uvm_object_wrapper)::set(null, "*.afifo_test", "vseq_type",
    //                                     afifo_full_empty_vseq::type_id::get());

    // For reset test
    // uvm_config_db#(uvm_object_wrapper)::set(null, "*.afifo_test", "vseq_type", 
    //                                     afifo_reset_vseq::type_id::get());;

    run_test();
  end
endmodule
