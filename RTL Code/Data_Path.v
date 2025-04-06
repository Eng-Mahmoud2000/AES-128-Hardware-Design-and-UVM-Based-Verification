module Data_Path(
    input  [0:127] Data_In,
    input  [0:127] Key,
    input          CLK,
    input          RST,
    input  [3:0]   round_count,
    input          key_expan_en,
    input          add_roundkey_en,
    input          sub_bytes_en,
    input          shift_rows_en,
    input          mix_columns_en,
    input          data_sel_init,
    input          data_sel_final,
    input          data_out_en,
    output         key_expan_done,
    output         add_key_done,
    output         sub_bytes_done,
    output         shift_rows_done,
    output         mix_columns_done,
    output [0:127] Data_Out
);
    
// Internal Signals
wire [0:1407] round_keys;
wire [0:127] add_key_out, sub_bytes_out, shift_rows_out, mix_columns_out;
wire [0:127] data_round;  // Data to be processed in each round

// Key Expansion Module
key_expansion u_key_expansion (
    .key(Key),
    .enable(key_expan_en),
    .CLK(CLK),
    .RST(RST),
    .round_keys(round_keys),
    .done_flag(key_expan_done)

);

// Add Round Key Module
add_round_key u_add_round_key (
    .data_in(data_round),
    .round_key(round_keys[(128 * round_count) +: 128]), // Select correct round key
    .enable(add_roundkey_en),
    .CLK(CLK),
    .RST(RST),
    .data_out(add_key_out),
    .done_flag(add_key_done)
);

// Sub Bytes Module
sub_bytes u_sub_bytes (
    .bytes(add_key_out),
    .enable(sub_bytes_en),
    .CLK(CLK),
    .RST(RST),
    .sub_bytes(sub_bytes_out),
    .done_flag(sub_bytes_done)
);

// Shift Rows Module
shift_rows u_shift_rows (
    .in(sub_bytes_out),
    .enable(shift_rows_en),
    .CLK(CLK),
    .RST(RST),
    .shifted(shift_rows_out),
    .done_flag(shift_rows_done)
);

// Mix Columns Module
mix_columns u_mix_columns (
    .in(shift_rows_out),
    .enable(mix_columns_en),
    .CLK(CLK),
    .RST(RST),
    .mixed(mix_columns_out),
    .done_flag(mix_columns_done)
);

// Selecting the correct input for Add Round Key
assign data_round = (data_sel_init)  ? Data_In : 
                    (data_sel_final) ? shift_rows_out : mix_columns_out;

// Final AES Encrypted Output
assign Data_Out = (data_out_en) ? add_key_out : 128'b0;




endmodule