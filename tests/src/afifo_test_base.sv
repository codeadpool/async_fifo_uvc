class afifo_test_base extends uvm_test;
  
  `uvm_component_utils(afifo_test_base)
  
  afifo_env m_env;
  afifo_vseq_base m_vseq;

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

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_object_wrapper seq_wrapper;
    if(!uvm_config_db#(uvm_object_wrapper)::get(this, "", "vseq_type", seq_wrapper))
      `uvm_fatal("CFG_ERR", "No virtual sequence type isn't specified for the test")

    vseq = afifo_vseq_base::type_id::create("vseq");

    if(!$cast(vseq, seq_wrapper.create_object("vseq")))
      `uvm_fatal("CFG_ERR", "Virutal sequence object is not of type afifo_vseq_base")
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    //intilizing thje virtual sequence before the start of virtual seqs.
    init_vseq(m_vseq);
    vseq.start(null); //no target sequencer

    phase.drop_objection(this);
  endtask : run_phase
endclass

class afifo_backpressure_test extends afifo_test;
  `uvm_component_utils(afifo_backpressure_test)

  function new(string name = "afifo_backpressure_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    afifo_backpressure_vseq vseq = afifo_backpressure_vseq::type_id::create("vseq");
    init_vseq(m_vseq);
    vseq.start(null);

    phase.drop_objection(this);
  endtask : run_phase
endclass

class afifo_full_empty_test extends afifo_test;
  `uvm_component_utils(afifo_full_empty_test)

  function new(string name = "afifo_full_empty_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    afifo_full_empty_vseq vseq = afifo_full_empty_vseq::type_id::create("vseq");
    init_vseq(m_vseq);
    vseq.start(null);

    phase.drop_objection(this);
  endtask : run_phase
endclass

class afifo_reset_test extends afifo_test;
  `uvm_component_utils(afifo_reset_test)

  function new(string name = "afifo_reset_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    afifo_rst_vseq vseq = afifo_rst_vseq::type_id::create("vseq");
    init_vseq(m_vseq);
    vseq.start(null);

    phase.drop_objection(this);
  endtask : run_phase
endclass
