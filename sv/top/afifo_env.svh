`ifndef afifo_env
`define afifo_env
class afifo_env extends uvm_env;
  
  `uvm_component_utils(afifo_env)
  
  afifo_wr_agent wr_agent;
  afifo_rd_agent rd_agent;

  afifo_scoreboard sb;

  function new(string name = "afifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    wr_agent =afifo_wr_agent::type_id::create(.name("wr_agent"), .contxt(get_full_name()));
    rd_agent =afifo_rd_agent::type_id::create(.name("rd_agent"), .contxt(get_full_name()));
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    wr_agent.m_monitor.ap.connect(sb.write_export);
    rd_agent.m_monitor.ap.connect(sb.read_export );
  endfunction : connect_phase
  
endclass
`endif
