`ifndef afifo_env
`define afifo_env
class afifo_env extends uvm_env;
  
  `uvm_component_utils(afifo_env)
  
  afifo_mcseqr      vseqr; //virtual sequencer
  afifo_wr_agent wr_agent;
  afifo_rd_agent rd_agent;

  function new(string name = "afifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    vseqr    =afifo_mcseqr::type_id::create(.name("vseqr"), .contxt(get_full_name()));

    wr_agent =afifo_wr_agent::type_id::create(.name("wr_agent"), .contxt(get_full_name()));
    rd_agent =afifo_rd_agent::type_id::create(.name("rd_agent"), .contxt(get_full_name()));
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    vseqr.wr_seqr =wr_agent.m_sequencer;
    vseqr.rd_seqr =rd_agent.m_sequencer;
  endfunction : connect_phase
  
endclass
`endif
