`ifndef AFIFO_WR_TXN
`define AFIFO_WR_TXN
class afifo_wr_txn #(int DATA_WIDTH = 32) extends uvm_sequence_item;
  rand bit winc;
  rand logic [DATA_WIDTH-1:0] wdata;
  bit full;
  time timestamp;
  rand bit error_inject;

  constraint c_winc { winc dist {1 := 80, 0 := 20}; }
  constraint c_data { wdata inside {[0:((1<<DATA_WIDTH)-1)]}; }

  `uvm_object_utils_begin(afifo_wr_txn#(DATA_WIDTH))
    `uvm_field_int(winc, UVM_ALL_ON)
    `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_field_int(full, UVM_ALL_ON)
    `uvm_field_int(error_inject, UVM_ALL_ON)
    `uvm_field_time(timestamp, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "afifo_wr_txn");
    super.new(name);
  endfunction

  function void pre_randomize();
    timestamp = $time;
  endfunction

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    afifo_write_txn#(DATA_WIDTH) rhs_;
    if (!$cast(rhs_, rhs)) return 0;
    return super.do_compare(rhs, comparer) &&
           winc == rhs_.winc &&
           wdata == rhs_.wdata;
  endfunction

  function string convert2string();
    return $sformatf("winc=%0b, wdata=0x%0h, full=%0b, error_inject=%0b, timestamp=%0t",
                     winc, wdata, full, error_inject, timestamp);
  endfunction
endclass
`endif
