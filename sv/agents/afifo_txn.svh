`ifndef AFIFO_TXN
`define AFIFO_TXN
class afifo_txn#(int DATA_WIDTH =32) extends uvm_sequence_item;

  rand bit winc;
  rand bit rinc;
  rand logic [DATA_WIDTH -1:0] wdata;

  //for a parametrized object class we need to
  typedef afifo_txn#(DATA_WIDTH) this_t;
  `uvm_object_utils_begin(this_t)
    `uvm_field_int( winc, UVM_ALL_ON)
    `uvm_field_int( rinc, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_txn");
    super.new(name);
  endfunction
endclass
`endif
