`ifndef AFIFO_R_DRIVER
`define AFIFO_R_DRIVER
class afifo_r_driver extends uvm_driver #(afifo_r_txn);

  virtual afifo_rif rvif;
  
  `uvm_component_utils(afifo_r_driver);

  function new(string name = "afifo_r_driver", uvm_component parent);
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
  
  virtual task run_phase(uvm_phase phase);
    @(negedge rvif.rrst_n);
    @(posedge rvif.rrst_n);
    `uvm_info(get_type_name(), "Reset Dropped", UVM_MEDIUM);

    forever begin
      @(posedge rvif.rclk);
      seq_item_port.get(req);
      drive_pkt(req);
      seq_item_port.item_done();
    end
  endtask : run_phase

  virtual task drive_item(afifo_r_txn item);
    @(posedge rvif.rclk);
    if (!rvif.rempty) begin
      rvif.rinc <= item.rinc;
      @(posedge rvif.rclk);
      rvif.rinc <= 1'b0;
    end else begin
      `uvm_info(get_type_name(), "FIFO is empty, cannot read", UVM_MEDIUM)
    end
  endtask
endclass
`endif