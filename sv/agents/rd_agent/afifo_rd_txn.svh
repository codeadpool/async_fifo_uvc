`ifndef AFIFO_RD_TXN
`define AFIFO_RD_TXN
class afifo_rd_txn #(int DATA_WIDTH = 32) extends uvm_sequence_item;

  rand bit rinc;
  logic [DATA_WIDTH -1:0] rdata;
  bit emtpy;
  time timestamp;
  rand bit error_inject;
  
  `uvm_object_utils_begin(afifo_rd_txn)
    `uvm_field_int(rinc, UVM_ALL_ON)
    `uvm_field_int(rdata, UVM_ALL_ON)
    `uvm_field_int(empty, UVM_ALL_ON)
    `uvm_field_int(error_inject, UVM_ALL_ON)
    `uvm_field_time(timestamp, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_rd_txn");
    super.new(name);
  endfunction

  function void pre_randomize ();
    timestamp = $time;
  endfunction

  function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    afifo_rd_txn#(DATA_WIDTH) rhs_;

    if(!$cast(rhs_, rhs))
      return 0;
    return super.do_compare(rhs, comparer) && rinc == rhs_.inc && rdata == rhs_.rdata;
    
  endfunction

  function string convert2string ();
    return $sformatf("rinc = %0b, rdata = 0x%0h, empty = %0b, 
      error_inject = %0b, timestamp = %0t", rinc, rdata, empty, error_inject, timestamp);
  endfunction
endclass
`endif
