`ifndef afifo_env
`define afifo_env
class afifo_env extends uvm_env;
  
  `uvm_component_utils(afifo_env)

  function new(string name = "afifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  
endclass
`endif
