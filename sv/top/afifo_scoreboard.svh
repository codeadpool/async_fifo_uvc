`ifndef AFIFO_SCOREBOARD
`define AFIFO_SCOREBOARD
class afifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(afifo_scoreboard)

  uvm_analysis_imp_write #(afifo_wrtxn, afifo_scoreboard) write_export;
  uvm_analysis_imp_read #(afifo_rtxn, afifo_scoreboard)    read_export;

  afifo_wrtransaction write_queue[$];

  int unsigned num_writes;
  int unsigned num_reads;
  int unsigned num_errors;

  int unsigned max_depth;
  // do we need data_width???

  covergroup afifo_cg;
    // want to know how often the size of the queue matches with the bin
    fifo_depth: coverpoint write_queue.size() {
       bins empty      ={0};
       bins full       ={max_depth};
       bins near_full  ={max_depth-2 :max_depth-1};
       bins near_empty ={[1:2]};
       bins mid        ={[3:max_depth-3]};
    }
    rd_wr_ops: cross fifo_depth, rd_wr_op;
  endgroup 

  function new(string name, uvm_component parent);
    super.new(name, parent);
    write_export =new("write_export", this);
    read_export  =new("read_export", this);
    fifo_cg      =new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(int unsigned)::get(this, "", "max_depth", max_depth))
      `uvm_fatal("AFIFO_SCOREBOARD", "Failed to get max_depth")

    // if(!uvm_config_db#(int unsigned)::get(this, "", data_width, data_width))
  endfunction

  function void write_write(afifo_wrtxn tr);
    if (write_queue.size() < max_depth) begin
      write_queue.push_back(tr);
      num_writes++;

      `uvm_info("AFIFO_SCOREBOARD", $sformatf("Write transaction received: %s", tr.convert2string()), UVM_MEDIUM)
    end else begin
      `uvm_error("AFIFO_SCOREBOARD", "FIFO overflow detected")
      num_errors++;
    end
    fifo_cg.sample();
  endfunction

  function void write_read(afifo_rtxn tr);
    afifo_wrtransaction expected_tr;
    if (write_queue.size() > 0) begin
      expected_tr = write_queue.pop_front();
      num_reads++;
      if (tr.data != expected_tr.data)begin
        `uvm_error("AFIFO_SCOREBOARD", $sformatf("Data mismatch - Expected: %0h, Actual: %0h", expected_tr.data, tr.data))
        num_errors++;
      end else
        `uvm_info("AFIFO_SCOREBOARD", $sformatf("Read transaction matched: %s", tr.convert2string()), UVM_HIGH)
    end else begin
      `uvm_error("AFIFO_SCOREBOARD", "FIFO underflow detected")
      num_errors++;
    end
  endfunction

  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (write_queue.size() != 0)
      `uvm_warning("AFIFO_SCOREBOARD", $sformatf("%0d transactions left in FIFO at end of test", write_queue.size()))
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AFIFO_SCOREBOARD", $sformatf("FIFO Scoreboard Report:"), UVM_LOW)
    `uvm_info("AFIFO_SCOREBOARD", $sformatf("  Total Writes: %0d", num_writes), UVM_LOW)
    `uvm_info("AFIFO_SCOREBOARD", $sformatf("  Total Reads: %0d", num_reads), UVM_LOW)
    `uvm_info("AFIFO_SCOREBOARD", $sformatf("  Total Errors: %0d", num_errors), UVM_LOW)
    `uvm_info("AFIFO_SCOREBOARD", $sformatf("  Final FIFO depth: %0d", write_queue.size()), UVM_LOW)
  endfunction

  assert_overflow: assert (write_queue.size() <= max_depth) 
    else $fatal("AFIFO_SCOREBOARD", "FIFO overflow detected in assertion")
    
  assert_underflow: assert (num_reads <= num_writes) 
    else `uvm_error("AFIFO_SCOREBOARD", "FIFO underflow detected in assertion")
    
 // assert_data_width: assert (tr.data.size() == data_width) 
 //   else `uvm_error("AFIFO_SCOREBOARD", $sformatf("Data width mismatch. Expected: %0d, Actual: %0d", data_width, tr.data.size()))
endclass
`endif
