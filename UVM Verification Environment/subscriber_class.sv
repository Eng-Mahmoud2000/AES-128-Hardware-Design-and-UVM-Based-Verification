class my_subscriber extends uvm_subscriber #(my_sequence_item);

  `uvm_component_utils(my_subscriber)
  my_sequence_item my_sequence_item_insta;
  int i = 0 ;     // transaction index


  // covergroup for inputs
  covergroup cov_inputs;
 // Coverpoint for data patterns
      ALL_DATA_PATTERNS: coverpoint my_sequence_item_insta.Data_In {
        bins all_zero     = {128'h00000000000000000000000000000000}; 
        bins all_ones     = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}; 
        bins alternating1 = {128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA}; 
        bins alternating2 = {128'h55555555555555555555555555555555}; 
        bins msb_set      = {128'h80000000000000000000000000000000}; 
        bins lsb_set      = {128'h00000000000000000000000000000001}; 
        bins inc_pattern  = {128'h0123456789ABCDEF0123456789ABCDEF}; 
        bins dec_pattern  = {128'hFEDCBA9876543210FEDCBA9876543210}; 
        bins random_data  = default;  // Any other random values
    }

    // Coverpoint for key values (same structure as data)
    ALL_KEY_PATTERNS: coverpoint my_sequence_item_insta.Key {
        bins all_zero     = {128'h00000000000000000000000000000000}; 
        bins all_ones     = {128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}; 
        bins alternating1 = {128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA}; 
        bins alternating2 = {128'h55555555555555555555555555555555}; 
        bins msb_set      = {128'h80000000000000000000000000000000}; 
        bins lsb_set      = {128'h00000000000000000000000000000001}; 
        bins inc_pattern  = {128'h0123456789ABCDEF0123456789ABCDEF}; 
        bins dec_pattern  = {128'hFEDCBA9876543210FEDCBA9876543210}; 
        bins random_key   = default;  // Any other random values
    }


    // Coverpoint for Hamming weight (number of 1s in data)
    hamming_weight_data: coverpoint $countones(my_sequence_item_insta.Data_In) {
        bins low  = {[0:32]};   // Low Hamming weight (0 to 32 bits set)
        bins mid  = {[33:95]};  // Medium Hamming weight (33 to 95 bits set)
        bins high = {[96:128]}; // High Hamming weight (96 to 128 bits set)
    }

    // Coverpoint for Hamming weight (number of 1s in key)
    hamming_weight_key: coverpoint $countones(my_sequence_item_insta.Key) {
        bins low  = {[0:32]};
        bins mid  = {[33:95]};
        bins high = {[96:128]};
    }

    Enable_Coverage: coverpoint my_sequence_item_insta.Enable; 

endgroup

  // covergroup for outputs
  covergroup cov_outputs;
    Data_out_coverage     : coverpoint my_sequence_item_insta.Data_Out ;
    Data_Out_VLD_coverage : coverpoint my_sequence_item_insta.Data_Out_VLD ;
  endgroup


  function new (string name = "my_subscriber", uvm_component parent = null);
    super.new(name,parent);
    cov_inputs = new;
    cov_outputs = new;
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  task run_phase (uvm_phase phase);
    super.run_phase(phase);
  endtask

  virtual function void write (my_sequence_item t);     // to match write function in uvm_subscriber
    my_sequence_item_insta = t;
    cov_inputs.sample();
    cov_outputs.sample();
    i = i+1;
    $display("Subscriber: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h, Data_out=%0h, Data_Out_VLD=%0h",
              i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key, my_sequence_item_insta.Enable, my_sequence_item_insta.Data_Out,my_sequence_item_insta.Data_Out_VLD); // for debugging
  endfunction

endclass