module keyExpansion_tb;
reg                 CLK;
reg                 RST;
reg     [0:127]     k1;
reg                 enable;
wire    [1407:0]    out1;
wire                done;

key_expansion ks(k1,enable,CLK,RST,out1,done);

initial begin
CLK = 1'b0;
RST = 1'b0;
#10;
RST = 1'b1;
$monitor("key= %h , out= %h",k1,out1);
enable = 1'b1;
k1=128'h2b7e1516_28aed2a6_abf71588_09cf4f3c;
#100;
$finish;

end
always #5 CLK = ~CLK;

endmodule