module AES_ENCRYPT_FSM 
(
    //Input and Output Ports 
    input                                  Enable,
    input                                  CLK,
    input                                  RST,
    input                                  key_expan_done,
    input                                  add_key_done,
    input                                  sub_bytes_done,
    input                                  shift_rows_done,
    input                                  mix_columns_done,
    output reg                             key_expan_en,
    output reg                             add_roundkey_en,
    output reg                             sub_bytes_en,
    output reg                             shift_rows_en,
    output reg                             mix_columns_en,
    output reg      [3:0]                  round_count,
    output reg                             data_sel_init,
    output reg                             data_sel_final,
    output reg                             data_out_en,
    output reg                             Data_Out_VLD
);

///////////////////////////////////////////////////////
// Define States
localparam IDLE          = 3'b000;
localparam KEY_EXPANSION = 3'b001;
localparam ADD_ROUND_KEY = 3'b010;
localparam SUB_BYTES     = 3'b011;
localparam SHIFT_ROWS    = 3'b100;
localparam MIX_COLUMNS   = 3'b101;

///////////////////////////////////////////////////////
// Internal Connections
reg  [0:2] current_state, next_state;

///////////////////////////////////////////////////////
// State Register Update
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        current_state   <= IDLE;
        round_count     <= 4'b0000;
    end
    else begin
        current_state   <= next_state;
        if (current_state == ADD_ROUND_KEY && add_key_done) begin
            round_count <= round_count + 1;
        end
        else if (current_state == IDLE) begin
            round_count <= 4'b0000;
        end
    end
end

///////////////////////////////////////////////////////
// Next State Logic
always @(*) begin
    // Default disable all enable signals
    next_state        = current_state;
    key_expan_en      = 1'b0;
    add_roundkey_en   = 1'b0;
    sub_bytes_en      = 1'b0;
    shift_rows_en     = 1'b0;
    mix_columns_en    = 1'b0;
    data_sel_init     = 1'b0;
    data_sel_final    = 1'b0;
    data_out_en       = 1'b0;
    Data_Out_VLD      = 1'b0;
    case (current_state)
        IDLE: begin
            if (Enable) begin
                next_state   = KEY_EXPANSION;
            end
        end

        KEY_EXPANSION: begin
            key_expan_en = 1'b1;
            if (key_expan_done) begin
                next_state = ADD_ROUND_KEY;
            end
        end

        ADD_ROUND_KEY: begin
            add_roundkey_en = 1'b1;
            // Select input for AddRoundKey
            if (round_count == 4'd0) begin
                data_sel_init = 1'b1;     // Use original Data_In
            end 
            else if (round_count == 4'd10) begin
                data_sel_final = 1'b1;    // Use ShiftRows output
            end
            if (add_key_done) begin
                if (round_count == 4'd10) begin  
                    Data_Out_VLD    = 1'b1;
                    data_out_en     = 1'b1;      // Output is now valid
                    next_state      = IDLE;
                end
                else begin
                    next_state = SUB_BYTES;
                end
            end 
      
        end

        SUB_BYTES: begin
            sub_bytes_en = 1'b1;
            if (sub_bytes_done) begin
                next_state = SHIFT_ROWS;
            end
        end

        SHIFT_ROWS: begin
            shift_rows_en = 1'b1; 
            if (shift_rows_done) begin
                if (round_count == 4'd10) begin
                    next_state = ADD_ROUND_KEY;
                end else begin
                    next_state = MIX_COLUMNS;
                end
            end
        end

        MIX_COLUMNS: begin
            mix_columns_en = 1'b1; 
            if (mix_columns_done) begin
                next_state = ADD_ROUND_KEY;
            end
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule