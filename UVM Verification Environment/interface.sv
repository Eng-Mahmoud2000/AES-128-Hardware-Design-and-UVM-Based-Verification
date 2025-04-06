interface intf();
// input & output signals
logic       [127:0] Data_In;
logic       [127:0] Key;
logic       [127:0] Data_Out;
logic               Enable;
logic               CLK;
logic               RST;
logic               Data_Out_VLD;

  // Clocking block for the driver
  clocking drv_cb @(posedge CLK);
    default output #2;         // output skew
      output        Data_In;   // 128-bit data input
      output        Key;   
      output        Enable;
    endclocking

    // Clocking block for the monitor 
  clocking mon_cb @(posedge CLK);
    default input #0 ;           // input skew
      input         Data_Out;    
      input         Data_Out_VLD;
      input         Data_In;
      input         Key;     
      input         Enable;    
    endclocking


endinterface
