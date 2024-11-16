`ifndef AFIFO_RMONITOR_BFM
`define AFIFO_RMONITOR_BFM
interface afifo_rmonitor_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rif bus);
  
endinterface
`endif
