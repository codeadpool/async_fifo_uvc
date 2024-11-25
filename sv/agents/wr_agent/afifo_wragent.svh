`ifndef AFIFO_WRAGENT
`define AFIFO_WRAGENT
class afifo_wragent extends uvm_agent;
  `uvm_component_utils(afifo_wragent)
  
  afifo_wrdriver   wrdriver;
  afifo_wrmonitor wrmonitor;
  uvm_sequencer #(afifo_wrtxn) wrseqr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    wrdriver  =afifo_wrdriver ::type_id::create("wrdriver",  this);
    wrmonitor =afifo_wrmonitor::type_id::create("wrmonitor", this);
    wrseqr    =uvm_sequencer#(afifo_wrtxn)::type_id::create("wrseqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    wrdriver.seq_item_port.connect(wrseqr.seq_item_export);
  endfunction
endclass
`endif
