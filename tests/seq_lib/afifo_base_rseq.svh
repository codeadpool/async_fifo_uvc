class afifo_base_rseq extends uvm_sequence #(afifo_rtxn);
  
  `uvm_object_utils(afifo_base_rseq)

  function new(string name = "afifo_base_rseq");
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

class afifo_npkt_rseq extends uvm_sequence;
  
  `uvm_object_utils(afifo_npkt_rseq)

  function new(string name = "afifo_npkt_rseq");
    super.new(name);
  endfunction

  virtual task body();
    afifo_rtxn req;
    `uvm_info(get_type_name(), "Executing npkt_rseq", UVM_NONE)

    repeat (10) begin
      req =afifo_rtxn::type_id::create("req", this);
      assert(req.randomize()) else
        `uvm_fatal("afifo_base_rseq", "Failed to randomize req")
      `uvm_do(req) 
    end
  endtask
endclass
