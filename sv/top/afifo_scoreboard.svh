class afifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(afifo_scoreboard)

  uvm_analysis_imp_write #(afifo_wrtxn, afifo_scoreboard) write_export;
  uvm_analysis_imp_read #(afifo_rtxn, afifo_scoreboard)    read_export;

  afifo_wrtransaction write_queue[$];
  int unsigned max_depth;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    write_export = new("write_export", this);
    read_export = new("read_export", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(int unsigned)::get(this, "", "max_depth", max_depth))
      `uvm_fatal("AFIFO_SCOREBOARD", "Failed to get max_depth")
  endfunction

  function void write_write(afifo_wrtxn tr);
    if (write_queue.size() < max_depth) begin
      write_queue.push_back(tr);
      `uvm_info("AFIFO_SCOREBOARD", $sformatf("Write transaction received: %s", tr.convert2string()), UVM_MEDIUM)
    end else begin
      `uvm_error("AFIFO_SCOREBOARD", "FIFO overflow detected")
    end
  endfunction

  function void write_read(afifo_rtxn tr);
    afifo_wrtransaction expected_tr;
    if (write_queue.size() > 0) begin
      expected_tr = write_queue.pop_front();
      if (tr.data != expected_tr.data)
        `uvm_error("AFIFO_SCOREBOARD", $sformatf("Data mismatch - Expected: %0h, Actual: %0h", expected_tr.data, tr.data))
      else
        `uvm_info("AFIFO_SCOREBOARD", $sformatf("Read transaction matched: %s", tr.convert2string()), UVM_HIGH)
    end else begin
      `uvm_error("AFIFO_SCOREBOARD", "FIFO underflow detected")
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if (write_queue.size() != 0)
      `uvm_warning("AFIFO_SCOREBOARD", $sformatf("%0d transactions left in FIFO at end of test", write_queue.size()))
  endfunction
endclass
