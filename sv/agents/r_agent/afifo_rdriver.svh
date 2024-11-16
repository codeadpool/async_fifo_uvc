`ifndef AFIFO_RDRIVER
`define AFIFO_RDRIVER
class afifo_rdriver extends uvm_driver #(afifo_rtxn);
  
  afifo_rdriver_bfm bfm;

  `uvm_component_utils(afifo_rdriver);

  function new(string name = "afifo_rdriver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // CIFV, field is name, Value is data
    if(!uvm_config_db#(virtual fifo_read_if)::get(this, "", "rvif", rvif))
      `uvm_fatal("afifo_r_driver", "virtual interface isn't setup for read_if")
  endfunction : build_phase 

  function void start_of_simulation_phase (uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Start of the simulation phase: %s", get_full_name()), UVM_HIGH)
  endfunction
  
  extern task run_phase(uvm_phase phase);
  extern task drive_pkt(afifo_rtxn item);
endclass

task afifo_rdriver::run_phase(uvm_phase phase);
  // @(negedge bus.rrst_n);
  // @(posedge bus.rrst_n);
  // `uvm_info(get_type_name(), "Reset Dropped", UVM_MEDIUM);

  forever begin
    @(posedge bfm.rclk);
    seq_item_port.get(req);
    drive_pkt(req);
    seq_item_port.item_done();
  end
endtask : run_phase

task afifo_rdriver::drive_item(afifo_r_txn item); 
  @(posedge bfm.rclk); 
  if (!bfm.rempty) begin 
    bfm.rinc <= item.rinc; 
    @(posedge rvif.rclk); 
    bfm.rinc <= 1'b0; 
  end else begin 
    `uvm_info(get_type_name(), "FIFO is empty, cannot read", UVM_MEDIUM) 
  end 
endtask 
`endif
