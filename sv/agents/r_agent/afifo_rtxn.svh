`ifndef AFIFO_RTXN
`define AFIFO_RTXN
class afifo_rtxn extends uvm_sequence_item;
  
  rand bit rinc;
  
  `uvm_object_utils_begin(afifo_rtxn)
    `uvm_field_int(rinc, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_rtxn");
    super.new(name);
  endfunction
endclass
`endif
