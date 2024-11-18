`ifndef AFIFO_RDRIVER_BFM
`define AFIFO_RDRIVER_BFM
interface afifo_rdriver_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rif.drv_port bus);// can drive RINC

  // increases RINC
  task do_read(output logic [DATA_WIDTH -1:0] dout);
    if(!bus.rempty) begin
      bus.rinc <=1'b1;
      @(posedge bus.rclk);
      dout <=bus.rdata;
      @(posedge bus.rclk);
      bus.rinc <=1'b0;
    end else begin
      dout <= 'X;
      //`uvm_info(get_type_name(), "FIFO is empty, cannot read", UVM_MEDIUM)
      // doesn't want uvm in here, need this synthesizable
    end
  endtask

  task automatic wait_fr_rst ();
    @(negedge bus.rrst_n);
    @(posedge bus.rrst_n);
  endtask
endinterface 
`endif
