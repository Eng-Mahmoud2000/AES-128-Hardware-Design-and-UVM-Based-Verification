class my_driver extends uvm_driver #(my_sequence_item);

`uvm_component_utils(my_driver)           // registering
my_sequence_item my_sequence_item_insta;
virtual intf v_intf;                      // declaring virtual interface
int i = 0;                                // transaction index

// the constructor
function new (string name = "my_driver", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta",this);
  if(uvm_config_db #(virtual intf)::get(this,"","my_vif",v_intf))      // retrive the virtual interface from configuration database
  	`uvm_info ("Driver", $sformatf ("[%s] found %p", this.get_name(), v_intf), UVM_MEDIUM)

endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);

  #10
  v_intf.RST = 1'b0;   // Apply reset (active low)
  #10;                 // Wait for 10 time units
  v_intf.RST = 1'b1;   // Release reset*/
    
  while (1) begin
    seq_item_port.get_next_item(my_sequence_item_insta);
    //Drive the transaction to dut
    @(v_intf.drv_cb)
      v_intf.Data_In    <= my_sequence_item_insta.Data_In;
      v_intf.Key        <= my_sequence_item_insta.Key; 
      v_intf.Enable     <= my_sequence_item_insta.Enable; 
    if (my_sequence_item_insta.Enable) begin
    @(posedge v_intf.Data_Out_VLD)
      i = i+1;
      $display("Driver: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h",
                  i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key,my_sequence_item_insta.Enable); // for debugging
      seq_item_port.item_done();
    end
    else begin
      i = i+1;
      $display("Driver: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h",
                i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key,my_sequence_item_insta.Enable); // for debugging
      #820 // wait 82 clock cycles
      seq_item_port.item_done();
    end
  end

endtask

endclass