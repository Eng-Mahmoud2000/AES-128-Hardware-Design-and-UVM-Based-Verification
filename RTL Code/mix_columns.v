module mix_columns (
	input           [0:127]     in,
    input                       enable,
    input                       CLK,
    input                       RST,
	output reg      [0:127]     mixed,
    output reg                  done_flag     // done signal flag
);
 
    // Function to multiply by 2 in GF(2^8)
    function [7:0] multiply_by_two;
        input [7:0] byte;

        begin
            if (byte[7] == 1'b1) begin
                multiply_by_two = (byte << 1) ^ 8'h1b;
            end
            else begin
                multiply_by_two = (byte << 1);
            end
        end

    endfunction

    // Function to multiply by 3 in GF(2^8)
    function [7:0] multiply_by_three;
        input [7:0] byte;
        
        begin
            multiply_by_three = multiply_by_two(byte) ^ byte;
        end

    endfunction

wire      [0:127]     mixed_c;

always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            mixed      <= 0    ; 
            done_flag  <= 1'b0 ;
        end
        else if (enable) begin
            mixed      <= mixed_c     ; 
            done_flag  <= 1'b1 ;
        end
        else begin
            done_flag  <= 1'b0 ;
        end
    end 

genvar col;

generate

    for (col = 0; col < 4; col = col + 1) begin
    assign mixed_c[(col*32)   +: 8] = multiply_by_two(in[(col*32)   +: 8]) ^ multiply_by_three(in[(col*32+8)  +: 8]) ^ in[(col*32+16)  +: 8] ^ in[(col*32+24)  +: 8];
    assign mixed_c[(col*32+8) +: 8] = in[(col*32)   +: 8] ^ multiply_by_two(in[(col*32+8)  +: 8]) ^ multiply_by_three(in[(col*32+16) +: 8]) ^ in[(col*32+24)  +: 8];
    assign mixed_c[(col*32+16)+: 8] = in[(col*32)   +: 8] ^ in[(col*32+8)  +: 8] ^ multiply_by_two(in[(col*32+16) +: 8]) ^ multiply_by_three(in[(col*32+24) +: 8]);
    assign mixed_c[(col*32+24)+: 8] = multiply_by_three(in[(col*32)   +: 8]) ^ in[(col*32+8)  +: 8] ^ in[(col*32+16) +: 8] ^ multiply_by_two(in[(col*32+24) +: 8]);
    end 

endgenerate

endmodule