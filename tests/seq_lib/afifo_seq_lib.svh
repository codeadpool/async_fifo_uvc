class afifo_base_seq extends uvm_sequence #(afifo_txn);
  
  `uvm_object_utils(afifo_base_seq)
  int FIFO_DEPTH;

  function new(string name = "afifo_base_seq");
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

// Sequence to fill the FIFO
class afifo_npkt_wr_seq extends afifo_base_seq;
  
  `uvm_object_utils(afifo_npkt_wr_seq)

  function new(string name = "afifo_npkt_wr_seq");
    super.new(name);
  endfunction

  virtual task body();
    // Retriving FIFO_DEPTH from the config db
    if(!uvm_config_db#(int)::get(this, "", FIFO_DEPTH, FIFO_DEPTH))
      `uvm_fatal("afifo_npkt_wr_seq", "Failed to Retrieve FIFO_DEPTH from config_db")
    `uvm_info(get_type_name(), "Executing npkt_wr_seq", UVM_NONE)

    `uvm_info("afifo_npkt_wr_seq", $sformatf("Running Sequence with FIFO_DEPTH: %d", FIFO_DEPTH), UVM_MEDIUM)
    
    repeat (FIFO_DEPTH) begin
      afifo_txn req =afifo_txn::type_id::create("req", this);
      assert(req.randomize() with {winc ==1; rinc ==0;}) else
        `uvm_fatal("afifo_base_seq", "Failed to randomize req")

      `uvm_do(req) 
    end
  endtask
endclass

// Sequence to empty the FIFO
class afifo_npkt_rd_seq extends afifo_base_seq;
  
  `uvm_object_utils(afifo_npkt_seq)
  
  function new(string name = "afifo_npkt_seq");
    super.new(name);
  endfunction

  virtual task body();
    // Retriving FIFO_DEPTH from the config db
    if(!uvm_config_db#(int)::get(this, "", FIFO_DEPTH, FIFO_DEPTH))
      `uvm_fatal("afifo_npkt_rd_seq", "Failed to Retrieve FIFO_DEPTH from config_db")
    `uvm_info(get_type_name(), "Executing npkt_rd_seq", UVM_NONE)

    repeat (FIFO_DEPTH) begin
      afifo_txn req =afifo_txn::type_id::create("req", this);
      assert(req.randomize() with {winc ==0; rinc ==1;}) else
        `uvm_fatal("afifo_base_seq", "Failed to randomize req")

      `uvm_do(req) 
    end
  endtask
endclass

// Sequence to test reset behavior
class afifo_rst_seq extends uvm_sequence #(afifo_txn);

  virtual afifo_wr_driver_bfm m_bfm;
  `uvm_object_utils(afifo_rst_seq)

  function new(string name = "afifo_rst_seq");
    super.new(name);
  endfunction

  task body();
    afifo_txn req = afifo_txn::type_id::create("req", this);

    // Write some data to the FIFO
    assert(req.randomize() with {winc == 1; rinc == 0;});
    `uvm_do(req) 

    m_bfm.do_reset();

    // Check FIFO status
    assert (fifo_empty) else `uvm_error("afifo_rst_seq", "FIFO not empty after reset"); 
  endtask
endclass
