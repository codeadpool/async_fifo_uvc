module tb_top#(
  parameter int FIFO_DEPTH = 32;
  ) (
);
 
  initial begin
    uvm_config_db#(int)::set(null, "*", FIFO_DEPTH, FIFO_DEPTH);
    run_test();
  end
endmodule
