`ifndef AFIFO_RD_DRIVER
`define AFIFO_RD_DRIVER
class afifo_rd_driver extends uvm_driver #(afifo_rd_txn);
  
  virtual afifo_rd_driver_bfm bfm;

  `uvm_component_utils(afifo_rd_driver)

  function new(string name = "afifo_rd_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // CIFV, field is name(key to lookup inthe db), Value is data
    if(!uvm_config_db#(virtual afifo_rd_driver_bfm)::get(this, "", "bfm", bfm))
      `uvm_fatal("afifo_rd_driver", "Failed to get BFM")
    // which is better get_full_name or name???
  endfunction : build_phase 

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    bfm.set_proxy(this);
  endfunction : connect_phase

  function void start_of_simulation_phase (uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Start of the simulation phase: %s", get_full_name()), UVM_HIGH)
  endfunction
  
  extern task run_phase(uvm_phase phase);

  function void notify_empty();
    `uvm_info("afifo_rd_driver", "FIFO is empty", UVM_MEDIUM)
  endfunction
endclass

task afifo_rd_driver::run_phase(uvm_phase phase);
  forever begin
    // ISSUE: what is the goal now, do nothing?
    seq_item_port.get(req);
    if(!bfm.is_emtpy())begin
      bfm.do_read(read_data);
      req.rdata =read_data;
      `uvm_info("afifo_rd_driver", $sformatf("Read data: %0h", read_data), UVM_NONE)
    end else begin
      `uvm_info("afifo_rd_driver", "FIFO is empty, Skipping read", UVM_MEDIUM)
    end
    seq_item_port.item_done();
  end
endtask : run_phase
`endif
