`ifndef AFIFO_RD_AGENT
`define AFIFO_RD_AGENT
class afifo_rd_agent extends uvm_agent;
  uvm_active_passive_enum is_active =UVM_ACTIVE;
  
  `uvm_component_utils(afifo_rd_agent)
  
  uvm_sequencer #(afifo_rd_txn) m_sequencer;
  afifo_rd_driver                m_driver;
  afifo_rd_monitor              m_monitor;

  function new(string name ="afifo_rd_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    m_sequencer =uvm_sequencer #(afifo_rd_txn)::type_id::create("m_sequencer", this);
    m_driver    =  afifo_rd_driver::type_id::create("m_driver", this);
    m_monitor   =afifo_rd_monitor::type_id::create("m_monitor", this);
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction : connect_phase
endclass
`endif
