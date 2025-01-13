`ifndef AFIFO_RD_DRIVER_BFM
`define AFIFO_RD_DRIVER_BFM
interface afifo_rd_driver_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rd_if.drv_port bus);// can drive RINC

  import afifo_pkg::*;
  afifo_rd_driver proxy;

  function set_proxy(afifo_rd_driver p);
    proxy =p; 
  endfunction

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
      if(proxy !=null) proxy.notify_empty();
      //`uvm_info(get_type_name(), "FIFO is empty, cannot read", UVM_MEDIUM)
      // doesn't want uvm in here, need this synthesizable
    end
  endtask

  function bit is_empty();
    return bus.rempty; 
  endfunction

  task do_reset;
    @(posedge bus.rclk);
    bus.rrst_n <= 'b0;
    bus.rinc   <= 'b0;

    @(posedge bus.rclk);
    bus.rrst_n <= 'b1;
  endtask
endinterface 
`endif
