class my_scoreboard extends uvm_scoreboard;

`uvm_component_utils(my_scoreboard)
my_sequence_item my_sequence_item_insta;
uvm_analysis_imp #(my_sequence_item, my_scoreboard) get_port;   // declaring port for retriving the transaction from monitor
int i = 0;
int fd;

logic [127:0] expected_output;

// the constractor
function new (string name = "scoreboard", uvm_component parent = null);
  super.new(name,parent);
endfunction

function void build_phase (uvm_phase phase);
  super.build_phase(phase);
  get_port = new("get_port",this);
endfunction

function void connect_phase (uvm_phase phase);
  super.connect_phase(phase);
endfunction

task run_phase (uvm_phase phase);
  super.run_phase(phase);
endtask

virtual function void write (my_sequence_item t);   
  my_sequence_item_insta = t;
  i = i+1;

  // Open file "key.txt" for writing

  fd = $fopen("D:/AES_Design/Referance_Model/key.txt","w");

  if (fd == 0) begin
    $error("Error: Unable to open file 'key.txt' for writing.");
  end

  // Writing to file : First line writing the data , Second line writing the key
  $fdisplay(fd,"%h \n%h",t.Data_In , t.Key);

  // Close the "key.txt"

  $fclose(fd);

  // "$system" task to run the python code and interact with SCOREBOARD through I/O files

  $system("python D:/AES_Design/Referance_Model/AES_Enc.py");

  // Open file "output.txt" for reading

  fd = $fopen("D:/AES_Design/Referance_Model/output.txt","r");

  if (fd == 0) begin
    $error("Error: Unable to open file 'output.txt' for reading.");
  end

  // Reading the output of python code through "output.txt" file

  $fscanf(fd,"%h",expected_output);

  // Close the "output.txt"

  $fclose(fd);

  $display("Scoreboard: Received transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h, Data_out=%0h, Data_Out_VLD=%0h",
              i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key, my_sequence_item_insta.Enable, my_sequence_item_insta.Data_Out,my_sequence_item_insta.Data_Out_VLD); // for debugging
    // Compare AES output with expected data
  if (t.Enable) begin
  if (t.Data_Out == expected_output) begin
      $display("PASS: Actual Out =%0h matched the Expected Out =%0h", t.Data_Out, expected_output);
    end
    else begin
      $error("FAIL: Actual Out =%0h didn't match the Expected Out =%0h", t.Data_Out, expected_output);
    end
  end
  else begin
      if (t.Data_Out == 0) begin
      $display("PASS: Actual Out =%0h matched the Expected Out = 0", t.Data_Out);
    end
    else begin
      $error("FAIL: Actual Out =%0h didn't match the Expected Out = 0", t.Data_Out);
    end
  end
endfunction

endclass