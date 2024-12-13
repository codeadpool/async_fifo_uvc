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


// VSequence to stress full and empty conditions
class afifo_stress_vseq extends uvm_sequence;
  `uvm_object_utils(afifo_stress_vseq)

  rand int num_iterations; 

  function new(string name = "afifo_stress_vseq");
    super.new(name);
  endfunction

  task body();
    full_fifo_sequence full_seq;
    empty_fifo_sequence empty_seq;

    repeat (num_iterations) begin
      full_seq = full_fifo_sequence::type_id::create("full_seq");
      assert(full_seq.randomize());
      full_seq.start(m_sequencer); 

      empty_seq = empty_fifo_sequence::type_id::create("empty_seq");
      assert(empty_seq.randomize());
      empty_seq.start(m_sequencer);
    end
  endtask

  constraint num_iterations_c { num_iterations inside {[5:20]}; }
endclass

// Sequence to test reset behavior
class afifo_rst_vseq extends uvm_sequence #(afifo_txn);

  virtual afifo_wr_driver_bfm m_bfm_wr;
  virtual afifo_rd_driver_bfm m_bfm_rd;

  `uvm_object_utils(afifo_rst_vseq)

  function new(string name = "afifo_rst_vseq");
    super.new(name);
  endfunction

  task body();
    afifo_txn req = afifo_txn::type_id::create("req", this);

    // Pre-Reset Checks
    // Check initial FIFO state (should be empty)
    assert (m_bfm_rd.is_empty()) else `uvm_error("afifo_rst_vseq", "FIFO not initially empty"); 
    assert (!m_bfm_wr.is_full()) else `uvm_error("afifo_rst_vseq", "FIFO initially full"); 

    // Write Data to the FIFO
    repeat (10) begin 
      assert(req.randomize() with {winc == 1; rinc == 0;});
      `uvm_do(req); 
    end

    // Reset FIFOO
    m_bfm_wr.do_reset(); 

    // Post-Reset Checks
    // Check FIFO status (empty &< not full)
    assert (m_bfm_rd.is_empty()) else `uvm_error("afifo_rst_vseq", "FIFO not empty after reset"); 
    assert (!m_bfm_wr.is_full()) else `uvm_error("afifo_rst_vseq", "FIFO full after reset"); 

    #5; // od we need this? 

    // Post-Reset Functionality Test
    assert(req.randomize() with {winc == 1; rinc == 0; data == 8'hAA});
    `uvm_do(req);

    assert(req.randomize() with {winc == 0; rinc == 1;}); 
    `uvm_do(req); 

    // do these ...  
    // assert(req.data == 8'hAA);)

    // Corner Case: Reset during write operation
    fork 
      begin
        // Start a write operation
        assert(req.randomize() with {winc == 1; rinc == 0;});
        `uvm_do(req);
      end
      begin
        #2; m_bfm_wr.do_reset();
      end
    join_none 

  endtask
endclass
