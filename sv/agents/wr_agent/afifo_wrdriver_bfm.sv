`ifndef AFIFO_WRDRIVER_BFM
`define AFIFO_WRDRIVER_BFM
interface afifo_wrdriver_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_wif.drv_port bus);
  
  import afifo_pkg::*;
  afifo_wrdriver proxy;

  function set_proxy (afifo_wrdriver p);
    proxy =p; 
  endfunction

  task do_write (input [DATA_WIDTH -1:0] write_data);
    @(posedge bus.wclk);
    if(!bus.wfull)begin
      bus.winc <='b1;
      bus.wdata <=write_data;
      @(posedge bus.wclk);
      bus.winc <='b0;
    end else begin
      proxy.notify_null();
    end
  endtask
endinterface
`endif
