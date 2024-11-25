`ifndef AFIFO_MCSEQR
`define AFIFO_MCSEQR
class afifo_mcseqr extends uvm_sequencer;
  
  `uvm_component_utils(afifo_mcseqr)
  
  // stock stuff
  uvm_sequencer #(afifo_wr_txn) wr_seqr;
  uvm_sequencer #(afifo_rd_txn) rd_seqr;

  function new(string name = "afifo_mcseqr", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_seqr =uvm_sequencer#(afifo_wr_txn)::type_id::create("wr_seqr", this);
    rd_seqr =uvm_sequencer#(afifo_rd_txn)::type_id::create("rd_seqr", this);
  endfunction : build_phase
endclass
`endif
