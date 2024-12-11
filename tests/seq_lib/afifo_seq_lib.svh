class afifo_base_wr_seq extends uvm_sequence #(afifo_wr_txn);
  
  `uvm_object_utils(afifo_base_wr_seq)

  function new(string name = "afifo_base_wr_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask

  task post_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask
endclass

class afifo_npkt_wr_seq extends afifo_base_wr_seq;
  
  `uvm_object_utils(afifo_npkt_wr_seq)

  function new(string name = "afifo_npkt_wr_seq");
    super.new(name);
  endfunction

  virtual task body();
    afifo_wr_txn req;
    `uvm_info(get_type_name(), "Executing npkt_wr_seq", UVM_NONE)
    
    repeat (10) begin
      req =afifo_wr_txn::type_id::create("req", this);
      assert(req.randomize()) else
        `uvm_fatal("afifo_base_wr_seq", "Failed to randomize req")
      `uvm_do(req) 
    end
  endtask
endclass

class afifo_base_rd_seq extends uvm_sequence #(afifo_rd_txn);
  
  `uvm_object_utils(afifo_base_rd_seq)

  function new(string name = "afifo_base_rd_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask

  task post_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask
endclass

class afifo_npkt_rd_seq extends afifo_base_rd_seq;
  
  `uvm_object_utils(afifo_npkt_rd_seq)

  function new(string name = "afifo_npkt_rd_seq");
    super.new(name);
  endfunction

  virtual task body();
    afifo_rd_txn req;
    `uvm_info(get_type_name(), "Executing npkt_rd_seq", UVM_NONE)

    repeat (10) begin
      req =afifo_rd_txn::type_id::create("req", this);
      assert(req.randomize()) else
        `uvm_fatal("afifo_base_rd_seq", "Failed to randomize req")
      `uvm_do(req) 
    end
  endtask
endclass
