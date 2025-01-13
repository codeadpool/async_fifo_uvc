`ifndef FIFO_INTERFACES
`define FIFO_INTERFACES

// Write Interface
interface afifo_wr_if #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
)(
  input wclk,
  input wrst_n,
  input winc, wfull,
  input [DATA_WIDTH -1:0] wdata
);
  // write side signals

  modport mon_port (
    input wclk,
    input wrst_n,
    input winc,
    input wdata,
    input wfull
  );

  modport drv_port (
    input wclk,
    input wrst_n,
    input wfull,
    output wdata,
    output winc
  );
endinterface

// Read Interface
interface afifo_rd_if #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
)(
  input rclk,
  input rrst_n,
  input rinc, rempty,
  input [DATA_WIDTH -1:0] rdata
);
  // Read side signals

  modport mon_port (
    input rclk, 
    input rrst_n,              
    input rinc,          
    input rdata,     
    input rempty                    
    );

  modport drv_port (
    input rclk, 
    input rrst_n,              
    input rempty,                    
    input rdata,
    output rinc                      
  );
  endinterface
`endif
