`ifndef AFIFO_WR_DRIVER
`define AFIFO_WR_DRIVER
class afifo_wr_driver extends uvm_driver #(afifo_wr_txn);
  
  virtual afifo_wr_driver_bfm bfm;

  `uvm_component_utils(afifo_wr_driver)

  function new(string name = "afifo_wr_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // the field BFM is to check in the config db 
    // we can change the path while setting LETS SUUUUUUI
    if(!uvm_config_db#(virtual afifo_wr_driver_bfm)::get(this, "", "bfm", bfm))
      `uvm_fatal("afifo_wr_driver", "Failed to get BFM")
  endfunction : build_phase

  function void notify_full();
    `uvm_info("AFIFO_WR_DRIVER", "FIFO is full", UVM_MEDIUM)
  endfunction

  extern task run_phase(uvm_phase phase);
endclass

task afifo_wr_driver::run_phase (uvm_phase phase);
  seq_item_port.get(req);
  bfm.do_write(req.wdata);
  seq_item_port.item_done();
endtask
`endif


