class my_sequence extends uvm_sequence #(my_sequence_item);

`uvm_object_utils(my_sequence)
int i = 0 ;                       // transaction index
int transaction_num = 10'd1000;     // number of transactions
my_sequence_item my_sequence_item_insta;

function new (string name = "my_sequence");
  super.new(name);
endfunction

virtual task body ();
    repeat (transaction_num) begin   
        my_sequence_item_insta = my_sequence_item::type_id::create("my_sequence_item_insta");
        start_item(my_sequence_item_insta);
        // randomize the transaction
        void'(my_sequence_item_insta.randomize());
        i = i +1 ;
        $display("Sequence: Sending transaction No.[%0d]: Data_in=%0h, key=%0h, Enable=%0h",
                i ,my_sequence_item_insta.Data_In, my_sequence_item_insta.Key,my_sequence_item_insta.Enable); // for debugging
        finish_item(my_sequence_item_insta);
    end
endtask
endclass