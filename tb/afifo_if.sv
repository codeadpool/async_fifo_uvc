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
  // Write side signals
  logic              winc, wfull;
  logic [DATA_WIDTH - 1:0] wdata; 

  task write(input logic [DATA_WIDTH - 1:0] data);
    wdata <= data;
    winc  <= 1'b1;
    @(posedge wclk);
    winc  <= 1'b0;
  endtask

  clocking wb_cb @(posedge wclk);
    output wdata, winc;
    input wfull;
  endclocking

  modport WR_DRV (clocking wb_cb, input wrst_n);
  
  modport WR_MON (input wclk, wrst_n, wdata, winc, wfull);
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

  task read(output logic [DATA_WIDTH - 1:0] data_out);
    rinc     <= 1'b1;
    @(posedge rclk);
    data_out <= rdata;
    rinc     <= 1'b0;
  endtask

  clocking rb_cb @(posedge rclk);
    input rdata, rempty;
    output rinc;
  endclocking

  modport RD_DRV (clocking rb_cb, input rrst_n);
  
  modport RD_MON (input rclk, rrst_n, rdata, rinc, rempty);
endinterface
`endif
