`ifndef AFIFO_RD_MONITOR_BFM
`define AFIFO_RD_MONITOR_BFM
interface afifo_rd_monitor_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rd_if.mon_port bus);
  
  import afifo_pkg::afifo_rd_monitor;
  import afifo_pkg::afifo_rd_txn;
  afifo_rd_monitor proxy; //back-pointer to the HVL Monitor
  // pulling isn't effective than pushing :0, pushing data to monitor-proxy

  // instead of using new(); we are passing the reference cause of flexibitly
  // if we use new() it tightly couples with the bfm 
  // and this method is SYNTHESIZABLE
  function void set_proxy (afifo_rd_monitor p);
    proxy =p; 
  endfunction

  task monitor_read();
    forever begin
      @(posedge bus.rclk);
      if(!bus.rempty)begin
        tr =afifo_rd_txn::type_id::create("tr", this);
        tr.rdata =bus.rdata;
        proxy.write(tr);
      end
    end
  endtask 
endinterface
`endif
