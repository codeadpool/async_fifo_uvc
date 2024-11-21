`ifndef AFIFO_MCSEQ_LIB
`define AFIFO_MCSEQ_LIB
class afifo_mcseq_lib extends uvm_sequence;
  
  `uvm_object_utils(afifo_mcseq_lib)
  `uvm_declare_p_sequencer(afifo_mcseqr)

  afifo_npkt_wrseqr npkt_wrseq;
  afifo_npkt_rseqr   npkt_rseq;

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

  task body();
    `uvm_info("afifo_mcseq_lib", "Executing mc_seq", UVM_MEDIUM)
     
    `uvm_do_on(npkt_wrseq, p_sequencer.wrseqr)
    `uvm_do_on(npkt_rseq, p_sequencer.rseqr  )
  endtask
endclass
`endif
