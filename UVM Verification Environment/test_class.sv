class my_test extends uvm_test;

  `uvm_component_utils(my_test)
  my_env my_env_insta;
  my_sequence my_sequence_insta;

  // the constractor
  function new (string name = "my_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    my_env_insta = my_env::type_id::create("my_env_insta",this);
    my_sequence_insta = my_sequence::type_id::create("my_sequence_insta",this);
  endfunction

  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    my_sequence_insta.start(my_env_insta.my_agent_insta.my_sequencer_insta);  // start sending sequences
    phase.drop_objection(this);
  endtask

endclass