`ifndef AFIFO_WRMONITOR
`define AFIFO_WRMONITOR
class afifo_wrmonitor extends uvm_monitor;
  
  virtual afifo_wrmonitor_bfm m_bfm;
  uvm_analysis_port #(afifo_wrtxn) ap;

  `uvm_component_utils(afifo_wrmonitor)

  function new(string name = "afifo_wrmonitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual afifo_wrmonitor)::get(this, "", bfm, m_bfm))
      `uvm_fatal("afifo_wrmonitor", "Failed to get BFM")
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_bfm.set_proxy(this);
  endfunction : connect_phase

  extern task run_phase(uvm_phase phase);
  function void write(afifo_wrtxn tr);
    ap.write(tr);
  endfunction
endclass

task afifo_wrmonitor::run_phase(uvm_phase phase);
  m_bfm.monitor_write(); 
endtask
`endif
