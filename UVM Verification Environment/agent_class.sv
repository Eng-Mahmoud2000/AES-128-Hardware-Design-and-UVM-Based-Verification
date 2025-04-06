class my_agent extends uvm_agent;

`uvm_component_utils(my_agent)

// instances of classes
my_sequence_item my_sequence_item_insta;
my_sequencer my_sequencer_insta;
my_driver my_driver_insta;
my_monitor my_monitor_insta;
// declare analysis port for communication between monitor and subscriber & scoreboard
uvm_analysis_port #(my_sequence_item) put_port_agent;   

// the constractor
function new (string name = "my_agent", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequencer_insta = my_sequencer::type_id::create("my_sequencer_insta",this);
  my_driver_insta    = my_driver::type_id::create("my_driver_insta",this);
  my_monitor_insta   = my_monitor::type_id::create("my_monitor_insta",this);
  put_port_agent     = new("put_port_agent",this);
endfunction

function void connect_phase (uvm_phase phase);
  my_driver_insta.seq_item_port.connect(my_sequencer_insta.seq_item_export);
  my_monitor_insta.put_port_monitor.connect(put_port_agent);
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
endtask


endclass