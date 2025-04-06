class my_monitor extends uvm_monitor;

`uvm_component_utils(my_monitor)
my_sequence_item my_sequence_item_insta;
virtual intf v_intf;                                      // declaring virtual interface
uvm_analysis_port #(my_sequence_item) put_port_monitor;   // declare analysis port for communication between monitor and subscriber & scoreboard
int i = 1 ;                                               // transaction index

// the constructor
function new (string name = "my_monitor", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta",this);
  put_port_monitor = new("put_port_monitor",this);
  if(uvm_config_db #(virtual intf)::get(this,"","my_vif",v_intf))
  	`uvm_info ("Monitor", $sformatf ("[%s] found %p", this.get_name(), v_intf), UVM_MEDIUM)
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
endfunction

task run_phase (uvm_phase phase);

  while (1) begin
    //monitoring the transaction from dut
    @(v_intf.mon_cb);
      if(v_intf.Enable) begin
      my_sequence_item_insta.Data_In        = v_intf.Data_In;
      my_sequence_item_insta.Key            = v_intf.Key;
      my_sequence_item_insta.Enable         = v_intf.Enable; 
      my_sequence_item_insta.Data_Out       = v_intf.Data_Out;
      my_sequence_item_insta.Data_Out_VLD   = v_intf.Data_Out_VLD;
      if(my_sequence_item_insta.Data_Out_VLD) begin
        $display("Monitor: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h, Data_out=%0h, Data_Out_VLD=%0h",
                  i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key, my_sequence_item_insta.Enable, my_sequence_item_insta.Data_Out,my_sequence_item_insta.Data_Out_VLD); // for debugging
        i = i + 1;
        put_port_monitor.write(my_sequence_item_insta);  // using calling write function to deliver the transaction to scoreboard & subscriber
      end
    end
    else if(!v_intf.Enable) begin
      my_sequence_item_insta.Data_In        = v_intf.Data_In;
      my_sequence_item_insta.Key            = v_intf.Key;
      my_sequence_item_insta.Enable         = v_intf.Enable; 
      #820       // wait 82 clock cycles
      my_sequence_item_insta.Data_Out       = v_intf.Data_Out;
      my_sequence_item_insta.Data_Out_VLD   = v_intf.Data_Out_VLD;
      $display("Monitor: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h, Data_out=%0h, Data_Out_VLD=%0h",
                i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key, my_sequence_item_insta.Enable, my_sequence_item_insta.Data_Out,my_sequence_item_insta.Data_Out_VLD); // for debugging
      i = i + 1;
      put_port_monitor.write(my_sequence_item_insta);  // using calling write function to deliver the transaction to scoreboard & subscriber
    end
  end
endtask

endclass