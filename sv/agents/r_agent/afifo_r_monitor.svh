`ifndef AFIFO_R_MONITOR
`define AFIFO_R_MONITOR
class afifo_r_monitor extends uvm_monitor;
  
  virtual afifo_rif rvif;
  uvm_analysis_port #(afifo_r_txn) ap;
  
  `uvm_component_utils(afifo_r_monitor);

  function new(string name = "afifo_r_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual afifo_if)::get(this, "", "rvif", rvif))
      `uvm_fatal("afifo_r_monitor", "virtual interface hasn't setup for rvif")
  endfunction : build_phase


endclass
`endif
