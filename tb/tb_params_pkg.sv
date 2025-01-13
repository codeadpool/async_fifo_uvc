package tb_params_pkg;
  import afifo_rd_agent_pkg::*; 
  import afifo_wr_agent_pkg::*;

  class afifo#( 
    parameter DATA_WIDTH = 32,  
    parameter ADDR_WIDTH =  8
    ); 

    initial begin
      assert(DATA_WIDTH > 0 && DATA_WIDTH < 1024)
      else $error("Invalid DATA_WIDTH");

      assert(ADDR_WIDTH > 0 && ADDR_WIDTH < 10)
      else $error("Invalid ADDR_WIDTH");
    end        
  endclass 

  typedef afifo_wr_txn #(afifo::DATA_WIDTH) afifo_wr_txn_t;
  typedef afifo_rd_txn #(afifo::DATA_WIDTH) afifo_rd_txn_t;

  typedef afifo_wr_agent #()
endpackage
