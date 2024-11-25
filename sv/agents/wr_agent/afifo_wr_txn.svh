`ifndef AFIFO_WR_TXN
`define AFIFO_WR_TXN
class afifo_wr_txn #(int DATA_WIDTH =32) extends uvm_sequence_item;
  // need to recheck the parameter

  rand bit winc;
  rand logic [DATA_WIDTH -1:0] wdata;

  `uvm_object_utils_begin(afifo_wr_txn)
    `uvm_field_int( winc, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_wr_txn");
    super.new(name);
  endfunction
endclass
`endif
