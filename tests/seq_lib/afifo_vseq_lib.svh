class afifo_vseq_base extends uvm_sequence;
  // vseq_base has handles for each of the target sequencers
  
  `uvm_object_utils(afifo_mcseq_lib)

  uvm_sequencer#(afifo_wr_txn) wr_seqr;
  uvm_sequencer#(afifo_rd_txn) rd_seqr;

  function new(string name = "afifo_mcseq_lib");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    phase = starting_phase;

    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    phase = starting_phase;

    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body
endclass

class afifo_full_empty_vseq extends afifo_vseq_base;

  `uvm_object_utils(afifo_full_empty_vseq)

  function new(string name = "afifo_full_empty_vseq");
    super.new(name); 
  endfunction

  task body();
    afifo_npkt_wr_seq wr_seq = afifo_npkt_wr_seq::type_id::create("wr_seq", this);
    afifo_npkt_rd_seq rd_seq = afifo_npkt_rd_seq::type_id::create("rd_seq", this);

    wr_seq.start(wr_seqr);
    rd_seq.start(rd_seqr);
  endtask
endclass
