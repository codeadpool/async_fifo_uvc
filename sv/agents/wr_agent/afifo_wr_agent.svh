`ifndef AFIFO_WR_AGENT
`define AFIFO_WR_AGENT
class afifo_wr_agent extends uvm_agent;
  `uvm_component_utils(afifo_wr_agent)
  
  uvm_sequencer #(afifo_wr_txn) m_sequencer;
  afifo_wr_driver   m_driver;
  afifo_wr_monitor m_monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active() == UVM_ACTIVE) begin 
      m_sequencer = uvm_sequencer#(afifo_wr_txn)::type_id::create("m_sequencer", this); 
      m_driver    = afifo_wr_driver ::type_id::create("m_driver",  this);
    end
    m_monitor = afifo_wr_monitor::type_id::create("m_monitor", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE)
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction
endclass
`endif
