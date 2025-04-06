module top();
  import uvm_pkg::*;
  import pack1::*;
  intf intf1 ();
  // Instantiate the AES and connect interface signals to the AES module

  AES_TOP AES_inst(
    .Data_In(intf1.Data_In),
    .Key(intf1.Key),
    .Enable(intf1.Enable),
    .CLK(intf1.CLK),
    .RST(intf1.RST),
    .Data_Out(intf1.Data_Out),
    .Data_Out_VLD(intf1.Data_Out_VLD)
  );
  // Generating Clock signal
  initial begin
    intf1.CLK = 0;
    forever #5 intf1.CLK = ~intf1.CLK; // Generate a 10-time unit clock (50% duty cycle)
  end


  initial begin
    // set interface in configuration database 
    uvm_config_db #(virtual intf)::set(null,"uvm_test_top.my_env_insta.my_agent_insta.*","my_vif",intf1); // keep tracking in hierarchical name
    run_test("my_test");
  end

endmodule
