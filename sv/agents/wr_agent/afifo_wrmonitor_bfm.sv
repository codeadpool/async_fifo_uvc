`ifndef AFIFO_WRMONITOR_BFM
`define AFIFO_WRMONITOR_BFM
interface afifo_wrmonitor_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8;
  )(afifo_wif.mon_port bus);
  
  import afifo_pkg::*;
  afifo_wrmonitor proxy; // back-pointer to the HVL Monitor

  function void set_proxy (afifo_wrmonitor p);
    proxy =p; 
  endfunction

  task monitor_write();
    forever begin
      @(posedge bus.wclk);
      if(bus.winc && !bus.wfull)begin
        afifo_wrtxn tr;
        tr =afifo_wrtxn::type_id::create("tr", this);
        tr.wdata =bus.wdata;
        proxy.write(tr);
      end
    end 
  endtask
endinterface
`endif
