module AES_TOP (
    input  [0:127] Data_In,
    input  [0:127] Key,
    input          Enable,
    input          CLK,
    input          RST,
    output [0:127] Data_Out,
    output         Data_Out_VLD
);

// Internal Signals
wire key_expan_done, add_key_done, sub_bytes_done, shift_rows_done, mix_columns_done;
wire key_expan_en, add_roundkey_en, sub_bytes_en, shift_rows_en, mix_columns_en, data_sel_init, data_sel_final, data_out_en;
wire  [3:0]   round_count;
// FSM Module
AES_ENCRYPT_FSM u_FSM (
    .Enable(Enable),
    .CLK(CLK),
    .RST(RST),
    .round_count(round_count),
    .key_expan_done(key_expan_done),
    .add_key_done(add_key_done),
    .sub_bytes_done(sub_bytes_done),
    .shift_rows_done(shift_rows_done),
    .mix_columns_done(mix_columns_done),
    .key_expan_en(key_expan_en),
    .add_roundkey_en(add_roundkey_en),
    .sub_bytes_en(sub_bytes_en),
    .shift_rows_en(shift_rows_en),
    .mix_columns_en(mix_columns_en),
    .data_sel_init(data_sel_init),
    .data_sel_final(data_sel_final),
    .data_out_en(data_out_en),         
    .Data_Out_VLD(Data_Out_VLD)
);
// Data Path Module
Data_Path u_Data_Path (
    .Data_In(Data_In),
    .Key(Key),
    .CLK(CLK),
    .RST(RST),
    .round_count(round_count),
    .key_expan_en(key_expan_en),
    .add_roundkey_en(add_roundkey_en),
    .sub_bytes_en(sub_bytes_en),
    .shift_rows_en(shift_rows_en),
    .mix_columns_en(mix_columns_en),
    .data_sel_init(data_sel_init),
    .data_sel_final(data_sel_final),
    .data_out_en(data_out_en),
    .key_expan_done(key_expan_done),
    .add_key_done(add_key_done),
    .sub_bytes_done(sub_bytes_done),
    .shift_rows_done(shift_rows_done),
    .mix_columns_done(mix_columns_done),
    .Data_Out(Data_Out)
);




endmodule
