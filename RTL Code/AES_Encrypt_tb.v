module AES_Encrypt_tb;

// Declare input signals
reg [127:0]  In;         // Input data (128-bit)
reg [127:0]  Key;        // AES key (128-bit)
reg          Enable;     // Enable signal to start encryption
reg          CLK;        // Clock signal
reg          RST;        // Reset signal

// Declare output signals
wire [127:0] Out;        // Encrypted output (128-bit)
wire         Valid;      // Valid signal indicating output is ready

// Clock generation: Toggle clock every 5 time units
always #5 CLK = ~CLK;

// Testbench initial block to provide stimulus
initial begin
    // Initialize signals
    CLK = 1'b0;           // Initial clock value
    RST = 1'b0;           // Reset is initially low (inactive)
    
    // Apply reset signal
    #5
    RST = 1'b1;           // Assert reset for 1 time unit
    
    // Monitor input and output signals during simulation
    $monitor("in= %h, key= %h ,out= %h ,valid=%h", In, Key, Out, Valid);
 
    // Set test vector 1: Plaintext and Key
    In = 128'h3243f6a8_885a308d_313198a2_e0370734;  // Sample input data
    Key = 128'h2b7e1516_28aed2a6_abf71588_09cf4f3c; // Sample key
    
    // Enable AES encryption
    Enable = 1'b1; 
    
    // Run for some time to let the encryption process happen
    #20
    Enable = 1'b0;  // Disable the Enable signal after 20 time units
    
    // Set test vector 2: Another set of plaintext and key for testing
    #820;
    In = 128'h01234567_89abcdef_01234567_89abcdef;   // New input data
    Key = 128'h1642268b_1b156c52_62c70b10_4ad7ef34;  // New key
    
    // Enable AES encryption again for the new test vector
    Enable = 1'b1;
    
    // Run the simulation for a longer time
    #850
    
    // End the simulation after running the test cases
    $finish;
end

// Instantiate the AES encryption module under test
AES_TOP u_AES_TOP (
    .Data_In(In),         // Connect input data to the DUT
    .Key(Key),            // Connect AES key to the DUT
    .Enable(Enable),      // Connect Enable signal to the DUT
    .CLK(CLK),            // Connect clock signal to the DUT
    .RST(RST),            // Connect reset signal to the DUT
    .Data_Out(Out),       // Connect encrypted output from the DUT
    .Data_Out_VLD(Valid)  // Connect the valid signal to the DUT
);

endmodule
