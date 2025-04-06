module shift_rows (
	input           [0:127] in,
    input                   enable,
    input                   CLK,
    input                   RST,
	output reg      [0:127] shifted,
    output reg              done_flag     // done signal flag
);

	
reg      [0:127]     shifted_c;
always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            shifted   <= 0     ; 
            done_flag  <= 1'b0 ;
        end
        else if (enable) begin
            shifted    <= shifted_c   ; 
            done_flag  <= 1'b1 ;
        end
        else begin
            done_flag  <= 1'b0 ;
        end
    end

always @(*) begin
    // First row (r = 0) is not shifted
    shifted_c[0+:8] = in[0+:8];
    shifted_c[32+:8] = in[32+:8];
    shifted_c[64+:8] = in[64+:8];
    shifted_c[96+:8] = in[96+:8];
    
    // Second row (r = 1) is cyclically left shifted by 1 offset
    shifted_c[8+:8] = in[40+:8];
    shifted_c[40+:8] = in[72+:8];
    shifted_c[72+:8] = in[104+:8];
    shifted_c[104+:8] = in[8+:8];
    
    // Third row (r = 2) is cyclically left shifted by 2 offsets
    shifted_c[16+:8] = in[80+:8];
    shifted_c[48+:8] = in[112+:8];
    shifted_c[80+:8] = in[16+:8];
    shifted_c[112+:8] = in[48+:8];
    
    // Fourth row (r = 3) is cyclically left shifted by 3 offsets
    shifted_c[24+:8] = in[120+:8];
    shifted_c[56+:8] = in[24+:8];
    shifted_c[88+:8] = in[56+:8];
    shifted_c[120+:8] = in[88+:8]; 
end


endmodule