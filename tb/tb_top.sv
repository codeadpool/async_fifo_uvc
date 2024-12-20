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

    run_test();
  end

  initial begin
    rst_n = 0;
    #100ns rst_n = 1;
  end
endmodule
