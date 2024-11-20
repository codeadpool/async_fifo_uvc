`ifndef AFIFO_WRDRIVER
`define AFIFO_WRDRIVER
class afifo_wrdriver extends uvm_driver #(afifo_wrtxn);
  
  virtual afifo_wrdriver_bfm m_bfm;
  `uvm_component_utils(afifo_wrdriver)

  function new(string name = "afifo_wrdriver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // the field BFM is to check in the config db 
    // we can change the path while setting LETS SUUUUUUI
    if(!uvm_config_db#(virtual afifo_wrdriver_bfm)::get(this, "", "bfm", m_bfm))
      `uvm_fatal("afifo_wrdriver", "Failed to get BFM")
  endfunction : build_phase

  function void notify_full();
    `uvm_info("AFIFO_WRDRIVER", "FIFO is full", UVM_MEDIUM)
  endfunction

  extern task run_phase(uvm_phase phase);
endclass

task afifo_wrdriver::run_phase (uvm_phase phase);
  seq_item_port.get(req);
  m_bfm.do_write(req.wdata);
  seq_item_port.item_done();
endtask
`endif


