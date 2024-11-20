`ifndef AFIFO_WRTXN
`define AFIFO_WRTXN
class afifo_wrtxn #(int DATA_WIDTH =32) extends uvm_sequence_item;
  // need to recheck the parameter

  rand bit winc;
  rand logic [DATA_WIDTH -1:0] wdata;

  `uvm_object_utils_begin(afifo_wrtxn)
    `uvm_field_int( winc, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_wrtxn");
    super.new(name);
  endfunction
endclass
`endif
