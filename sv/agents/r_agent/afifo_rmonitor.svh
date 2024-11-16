`ifndef AFIFO_RMONITOR
`define AFIFO_RMONITOR
class afifo_rmonitor extends uvm_monitor;
  
  virtual afifo_rif rvif;
  uvm_analysis_port #(afifo_r_txn) ap;
  
  `uvm_component_utils(afifo_rmonitor);

  function new(string name = "afifo_rmonitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual afifo_if)::get(this, "", "rvif", rvif))
      `uvm_fatal("afifo_r_monitor", "virtual interface hasn't setup for rvif")
  endfunction : build_phase
  
  task run_phase(uvm_phase phase);
    forever begin
      do_monitor();
    end
  endtask

  extern task do_monitor();
endclass

task afifo_r_monitor::do_monitor();
  afifo_rtxn tr;

  @(posedge rvif.clk);
  if(rvif.rinc && !rvif.rempty)begin
    tr = afifo_r_txn::type_id::create("tr");
    tr.data = rvif.rdata;

    `uvm_info("COLLECT", $sformat("Collected TXN: %s," tr.convert2string()), UVM_HIGH)
    ap.write(tr);
  end
endtask

`endif
