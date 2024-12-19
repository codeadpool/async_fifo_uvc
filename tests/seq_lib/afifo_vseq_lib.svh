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

// VSequence to apply backpressure condition
class afifo_backpressure_vseq extends uvm_vseq_base;
  `uvm_object_utils(afifo_backpressure_vseq)
  `uvm_analysis_imp_decl(_afifo_full)
  `uvm_analysis_imp_decl(_afifo_empty)

  uvm_analysis_imp(_afifo_full )#(bit, afifo_backpressure_vseq) afifo_full_imp;
  uvm_analysis_imp(_afifo_empty)#(bit, afifo_backpressure_vseq) afifo_empty_imp;
  
  bit afifo_full, afifo_empty;
  int FIFO_DEPTH; 
  rand int num_writes;
  rand int num_reads;

  constraint num_writes_c {
    num_writes <= FIFO_DEPTH; 
  }
  constraint num_read_c {
    num_reads < num_writes;
  }

  function new(string name = "afifo_backpressure_vseq");
    super.new(name);
    
    afifo_full_imp  = new( "afifo_full_imp", this);
    afifo_empty_imp = new("afifo_empty_imp", this);
  endfunction

  task body();

    if(!uvm_config_db#(int)::get(this, "", "FIFO_DEPTH", FIFO_DEPTH))
      `uvm_fatal(get_type_name(), "Couldn't retrieve FIFO_DEPTH")

    if(!afifo_full) begin
      repeat (num_writes) begin
        afifo_npkt_wr_seq wr_seq = afifo_npkt_wr_seq::type_id::create("wr_seq", this);
        wr_seq.start(wr_seqr);
      end
    end else 
      `uvm_info(get_type_name(), "FIFO is full during write", UVM_MEDIUM)

    if(!afifo_empty) begin
      repeat (num_reads) begin
        afifo_npkt_rd_seq rd_seq = afifo_npkt_rd_seq::type_id::create("rd_seq", this); 
        rd_seq.start(rd_seqr);
      end
    end else 
      `uvm_info(get_type_name(), "FIFO is empty during read", UVM_MEDIUM)
  endtask

  virtual function void write_afifo_full (bit is_full);
    afifo_full = is_full; 
  endfunction

  virtual function void write_afifo_empty (bit is_empty);
    afifo_empty = is_empty;
  endfunction

  // constraint num_iterations_c { num_iterations inside {[5:20]}; }
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

// Test
class afifo_backpressure_vseq extends uvm_sequence;
  `uvm_object_utils(afifo_backpressure_vseq)

  rand int unsigned num_items;
  rand int unsigned backpressure_interval;
  rand int unsigned backpressure_duration;
  rand bit apply_write_backpressure;

  constraint c_num_items { num_items inside {[100:500]}; }
  constraint c_backpressure_interval { backpressure_interval inside {[10:50]}; }
  constraint c_backpressure_duration { backpressure_duration inside {[5:20]}; }

  afifo_config cfg;

  function new(string name = "afifo_backpressure_vseq");
    super.new(name);
  endfunction

  task body();
    bit fifo_full, fifo_empty;

    if (!uvm_config_db#(afifo_config)::get(null, "", "afifo_config", cfg))
      `uvm_fatal(get_type_name(), "Failed to get afifo_config from config_db")

    `uvm_info(get_type_name(), $sformatf("Starting backpressure sequence with %0d items", num_items), UVM_MEDIUM)

    fork
      // Write process
      begin
        afifo_npkt_wr_seq write_seq = afifo_npkt_wr_seq::type_id::create("write_seq");
        for (int i = 0; i < num_items; i++) begin
          if (apply_write_backpressure && bus.is_full()) begin
            `uvm_info(get_type_name(), "Applying write backpressure", UVM_MEDIUM)
            #(backpressure_duration * cfg.write_clk_period);
          end

          write_seq.start(wr_seqr);
          get_fifo_status(fifo_full, fifo_empty);

          if (bus.is_full()) 
            `uvm_info(get_type_name(), "FIFO full detected during write", UVM_MEDIUM)
        end
      end

      // Read process with backpressure
      begin
        afifo_npkt_rd_seq read_seq = afifo_npkt_rd_seq::type_id::create("read_seq");
        for (int i = 0; i < num_items; i++) begin
          if (!apply_write_backpressure && i % backpressure_interval == 0) begin
            `uvm_info(get_type_name(), "Applying read backpressure", UVM_MEDIUM)
            #(backpressure_duration * cfg.read_clk_period);
          end
          read_seq.start(p_sequencer.read_sequencer);
          get_fifo_status(fifo_full, fifo_empty);
          if (fifo_empty) `uvm_info(get_type_name(), "FIFO empty detected during read", UVM_MEDIUM)
        end
      end
    join

    `uvm_info(get_type_name(), "Backpressure sequence completed", UVM_MEDIUM)
  endtask

  task get_fifo_status(output bit full, output bit empty);
    // Implement this task to read FIFO status flags
    // This could involve reading from the DUT or from a predictor in the scoreboard
  endtask

endclass
