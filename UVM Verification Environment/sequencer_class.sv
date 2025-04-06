class my_sequencer extends uvm_sequencer #(my_sequence_item);

`uvm_component_utils(my_sequencer)
my_sequence_item my_sequence_item_insta;

function new (string name = "my_sequencer", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta",this);
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
endtask

  endclass