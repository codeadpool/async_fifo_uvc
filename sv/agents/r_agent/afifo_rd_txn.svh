`ifndef AFIFO_RD_TXN
`define AFIFO_RD_TXN
class afifo_rd_txn extends uvm_sequence_item;
  
  rand bit rinc;
  
  `uvm_object_utils_begin(afifo_rd_txn)
    `uvm_field_int(rinc, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_rd_txn");
    super.new(name);
  endfunction
endclass
`endif
