`ifndef AFIFO_MCSEQR
`define AFIFO_MCSEQR
class afifo_mcseqr extends uvm_sequencer;
  
  `uvm_component_utils(afifo_mcseqr)
  
  // stock stuff
  uvm_sequencer #(afifo_wrtxn) wrseqr;
  uvm_sequencer #(afifo_rtxn)   rseqr;

  function new(string name = "afifo_mcseqr", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wrseqr =uvm_sequencer#(wrtxn)::type_id::create("wrseqr", this);
    rseqr  =uvm_sequencer#( rtxn)::type_id::create(" rseqr", this);
  endfunction : build_phase
endclass
`endif
