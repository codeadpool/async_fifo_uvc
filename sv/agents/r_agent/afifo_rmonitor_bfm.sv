`ifndef AFIFO_RMONITOR_BFM
`define AFIFO_RMONITOR_BFM
interface afifo_rmonitor_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rif.mon_port bus);
  
  import afifo_pkg::afifo_rmonitor;
  import afifo_pkg::afifo_rtxn;
  afifo_rmonitor proxy; //back-pointer to the HVL Monitor
  // pulling isn't effective than pushing :0, pushing data to monitor-proxy

  // instead of using new(); we are passing the reference cause of flexibitly
  // if we use new() it tightly couples with the bfm 
  // and this method is SYNTHESIZABLE
  function void set_proxy (afifo_rmonitor p);
    proxy =p; 
  endfunction

  task monitor_read();
    forever begin
      @(posedge bus.rclk);
      if(!bus.rempty)begin
        tr =afifo_rtxn::type_id::create("tr", this);
        tr.rdata =bus.rdata;
        proxy.write(tr);
      end
    end
  endtask 
endinterface
`endif
