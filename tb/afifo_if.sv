`ifndef FIFO_INTERFACES
`define FIFO_INTERFACES

// Write Interface
interface afifo_wif #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
)(
  input logic wclk,
  input logic wrst_n
);
  // write side signals
  logic winc;
  logic DATA_WIDTH -1:0] wdata;
  logic wfull;

  modport mon_port (
    input wclk,
    input wrst_n,
    input winc,
    input wdata,
    input wfull
  );

  modport init_port (
    input wclk,
    input wrst_n,
    input wfull,
    output winc,
    output wdata
  );
endinterface

// Read Interface
interface afifo_rif #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 8
)(
  input logic rclk,
  input logic rrst_n
);
  // Read side signals
  logic             rinc, rempty;
  logic [DATA_WIDTH - 1:0] rdata;

  modport mon_port (
    input rclk, 
    input rrst_n,              
    input rinc,          
    input rdata,     
    input rempty                    
    );

  modport init_port (
    input rclk, 
    input rrst_n,              
    input rempty,                    
    output rinc                      
  );
  endinterface
`endif
