# Asynchronous FIFO Verification

This project demonstrates the verification of an Asynchronous FIFO design using UVM. It emphasizes an efficient and scalable approach by leveraging the "Dual Top" methodology.

## Project Structure

The project is divided into two primary modules:

* **`hdl_top`:**  Encapsulates the Design Under Test (DUT) and Bus Functional Models (BFMs). The BFMs provide the hardware interface for interacting with the FIFO.
* **`hvl_top`:** Houses the UVM testbench, including agents, drivers, and monitors. These components orchestrate the test sequence and verify the DUT's behavior. Communication with the `hdl_top` occurs through virtual interface handles via remote-proxy method.

```
├── doc
│   └── README.md
├── dut
│   ├── fifomem.sv
│   ├── fifo_top.sv
│   ├── rd_ptr_empty.sv
│   ├── sync_r2w.sv
│   ├── sync_w2r.sv
│   └── wptr_full.sv
├── README.md
├── sv
│   ├── afifo_mcseqr.svh
│   ├── afifo_pkg.sv
│   ├── agents
│   │   ├── afifo_txn.svh
│   │   ├── rd_agent
│   │   │   ├── afifo_rd_agent_pkg.sv
│   │   │   ├── afifo_rd_agent.svh
│   │   │   ├── afifo_rd_driver_bfm.sv
│   │   │   ├── afifo_rd_driver.svh
│   │   │   ├── afifo_rd_monitor_bfm.sv
│   │   │   ├── afifo_rd_monitor.svh
│   │   │   └── afifo_rd_txn.svh
│   │   └── wr_agent
│   │       ├── afifo_wr_agent_pkg.sv
│   │       ├── afifo_wr_agent.svh
│   │       ├── afifo_wr_driver_bfm.sv
│   │       ├── afifo_wr_driver.svh
│   │       ├── afifo_wr_monitor_bfm.sv
│   │       ├── afifo_wr_monitor.svh
│   │       └── afifo_wr_txn.svh
│   └── top
│       ├── afifo_env_pkg.sv
│       ├── afifo_env.svh
│       └── afifo_scoreboard.svh
├── tb
│   ├── afifo_if.sv
│   ├── afifo_tb_pkg.sv
│   ├── clkgen.sv
│   ├── dut_harness.sv
│   ├── hw_top.sv
│   ├── tb_params_pkg.sv
│   └── tb_top.sv
└── tests
    ├── seq_lib
    │   ├── afifo_seq_lib.svh
    │   ├── afifo_seq_pkg.sv
    │   └── afifo_vseq_lib.svh
    └── src
        ├── afifo_test_base.sv
        └── afifo_test_pkg.sv
```

## Key Verification Methodologies

* **HDL and HVL:**
    * **HDL:**  Models the timed behavior of the asynchronous FIFO at the pin level using Verilog or SystemVerilog.
    * **HVL:** Employs SystemVerilog with UVM to create a higher-level, untimed verification environment focused on functionality.

* **TLM (Transaction-Level Modeling):**  Abstracts read/write operations on the FIFO, enabling efficient communication between UVM agents and BFMs.

* **Virtual Interface Handling:**  Facilitates communication between the `hdl_top` and `hvl_top`. Virtual interface references are passed through the `uvm_config_db`, allowing UVM components (agents, monitors, drivers) to access and control the BFM interfaces in the `hdl_top`.

* **Core-Proxy Method (Optional):**  For advanced scenarios, this method (co-modeling or co-emulation) can be used to bridge the gap between the high-level verification environment and the low-level design.

## Methodology Benefits

* **Separation of Concerns:**  Clear division between design (`hdl_top`) and verification (`hvl_top`) promotes modularity and allows independent development by separate teams.

* **Synthesizability and Acceleration:** The `hdl_top` is designed to be synthesizable, enabling hardware acceleration and co-emulation for faster and more efficient simulations. This scalability is crucial for complex designs.

