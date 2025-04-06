class my_env extends uvm_env;

`uvm_component_utils(my_env)

my_agent my_agent_insta;
my_scoreboard my_scoreboard_insta;
my_subscriber my_subscriber_insta;

function new (string name = "my_env", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  my_agent_insta      = my_agent::type_id::create("my_agent_insta",this);
  my_scoreboard_insta = my_scoreboard::type_id::create("my_scoreboard_insta",this);
  my_subscriber_insta = my_subscriber::type_id::create("my_subscriber_insta",this);
endfunction

function void connect_phase (uvm_phase phase);
  my_agent_insta.put_port_agent.connect(my_scoreboard_insta.get_port);        // connect monitor port to scoreboard through agent
  my_agent_insta.put_port_agent.connect(my_subscriber_insta.analysis_export); // connect monitor port to subscriber through agent
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
endtask


endclass