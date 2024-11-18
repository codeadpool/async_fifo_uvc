`ifndef AFIFO_RMONITOR
`define AFIFO_RMONITOR
class afifo_rmonitor extends uvm_monitor;
  
  virtual afifo_rmonitor_bfm m_bfm;
  uvm_analysis_port #(afifo_rtxn) ap;
  
  `uvm_component_utils(afifo_rmonitor)

  function new(string name = "afifo_rmonitor", uvm_component parent);
    super.new(name, parent);
    ap =new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual afifo_rmonitor_bfm)::get(this, "", "bfm", m_bfm))
      `uvm_fatal("afifo_rmonitor", "Failed to get BFM")
  endfunction : build_phase
 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_bfm.set_proxy(this);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    m_bfm.monitor_read();
  endtask
  
  function void write(afifo_rtxn tr);
    ap.write(tr); 
  endfunction
endclass

/*task afifo_r_monitor::do_monitor();
  afifo_rtxn tr;

  @(posedge rvif.clk);
  if(rvif.rinc && !rvif.rempty)begin
    tr = afifo_r_txn::type_id::create("tr");
    tr.data = rvif.rdata;

    `uvm_info("COLLECT", $sformat("Collected TXN: %s," tr.convert2string()), UVM_HIGH)
    ap.write(tr);
  end
endtask*/

`endif
