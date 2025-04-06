module add_round_key(
    input           [127:0]     data_in,
    input           [127:0]     round_key,
    input                       enable,
    input                       CLK,
    input                       RST,
    output reg      [127:0]     data_out,
    output reg                  done_flag        // done signal flag
);
    
reg      [127:0]     data_out_c;
always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            data_out   <= 0    ; 
            done_flag  <= 1'b0 ;
        end
        else if (enable) begin
            data_out   <= data_out_c  ; 
            done_flag  <= 1'b1 ;
        end
        else begin
            done_flag  <= 1'b0 ;
        end
    end

always @(*) begin
    data_out_c  = data_in ^ round_key;
end

endmodule