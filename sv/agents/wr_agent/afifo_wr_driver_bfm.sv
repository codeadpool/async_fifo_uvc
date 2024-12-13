`ifndef AFIFO_WR_DRIVER_BFM
`define AFIFO_WR_DRIVER_BFM
interface afifo_wr_driver_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_wr_if.drv_port bus);
  
  import afifo_pkg::*;
  afifo_wr_driver proxy;

  function set_proxy (afifo_wr_driver p);
    proxy =p; 
  endfunction

  function is_full ();
    return bus.wfull; 
  endfunction

  task do_write (input [DATA_WIDTH -1:0] write_data);
    @(posedge bus.wclk);
    if(!bus.wfull)begin
      bus.winc <='b1;
      bus.wdata <=write_data;
      @(posedge bus.wclk);
      bus.winc <='b0;
    end else begin
      proxy.notify_full();
    end
  endtask

  task do_reset ();
    @(posedge bus.wclk);
    bus.wrst_n <= 'b0;
    bus.winc   <= 'b0;
    
    @(posedge bus.wclk);
    bus.wrst_n <= 'b1;
  endtask
endinterface
`endif
