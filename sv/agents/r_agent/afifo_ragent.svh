`ifndef AFIFO_RAGENT
`define AFIFO_RAGENT
class afifo_ragent extends uvm_agent;
  uvm_active_passive_enum is_active =UVM_ACTIVE;
  
  `uvm_component_utils(afifo_ragent)
  
  uvm_sequencer #(afifo_rtxn) rseqr;
  afifo_rdriver             rdriver;
  afifo_rmonitor           rmonitor;

  function new(string name ="afifo_ragent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    rseqr    =uvm_sequencer #(afifo_rtxn)::type_id::create("rseqr", this);
    rdriver  =  afifo_rdriver::type_id::create("rdriver", this);
    rmonitor =afifo_rmonitor::type_id::create("rmonitor", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    rdriver.seq_item_port.connect(rseqr.seq_item_export);
  endfunction : connect_phase
endclass
`endif
