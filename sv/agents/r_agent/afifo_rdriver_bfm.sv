`ifndef AFIFO_RDRIVER_BFM
`define AFIFO_RDRIVER_BFM
interface afifo_rdriver_bfm#(
  parameter DATA_WIDTH =32,
  parameter ADDR_WIDTH =8
  )(afifo_rif bus);

  task do_read(output logic [DATA_WIDTH -1:0] dout);
    if(!bus.rempty) begin
      bus.rinc <=1'b1;
      @(posedge bus.rclk);
      dout <=bus.rdata;
      @(posedge bus.rclk);
      bus.rinc <=1'b0;
    end // else print or do something
  endtask
   
endinterface 
`endif
