`ifndef AFIFO_RD_MONITOR
`define AFIFO_RD_MONITOR
class afifo_rd_monitor extends uvm_monitor;
  
  virtual afifo_rd_monitor_bfm m_bfm;
  uvm_analysis_port #(afifo_rd_txn) ap;
  
  `uvm_component_utils(afifo_rd_monitor)

  function new(string name = "afifo_rd_monitor", uvm_component parent);
    super.new(name, parent);
    ap =new("ap", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual afifo_rd_monitor_bfm)::get(this, "", "bfm", m_bfm))
      `uvm_fatal("afifo_rd_monitor", "Failed to get BFM")
  endfunction : build_phase
 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_bfm.set_proxy(this);
  endfunction : connect_phase

  task run_phase(uvm_phase phase);
    m_bfm.monitor_read();
  endtask
  
  function void write(afifo_rd_txn tr);
    ap.write(tr); 
  endfunction
endclass

/*task afifo_rd_monitor::do_monitor();
  afifo_rd_txn tr;

  @(posedge rvif.clk);
  if(rvif.rinc && !rvif.rempty)begin
    tr = afifo_r_txn::type_id::create("tr");
    tr.data = rvif.rdata;

    `uvm_info("COLLECT", $sformat("Collected TXN: %s," tr.convert2string()), UVM_HIGH)
    ap.write(tr);
  end
endtask*/

`endif
