class afifo_test_base extends uvm_test;
  
  `uvm_component_utils(afifo_test_base)
  
  afifo_env m_env;

  function new(string name = "afifo_test_base", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    m_env =afifo_env::type_id::create("m_env", this);
  endfunction : build_phase
  
  // tjhis method assigns the seuqencer handles to the handles dervied from
  // the vseq_base class
  function void init_vseq(afifo_vseq_base vseq);
    vseq.wr_seqr =m_env.m_agent_wr.m_sequencer;
    vseq.rd_seqr =m_env.m_agent_rd.m_sequencer;
  endfunction
endclass

class init_vseq_from_test extends afifo_test_base;
  
  `uvm_component_utils(init_vseq_from_test)

  function new(string name = "init_vseq_from_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    afifo_full_empty_seq vseq =fifo_full_empty::type_id::create("vseq", this);

    phase.raise_objection(this);
    
    //intilizing thje virtual sequence before the start of virtual seqs.
    init_vseq(vseq);
    vseq.start(null); //no target sequencer

    phase.drop_objection(this);
  endtask : run_phase
endclass
