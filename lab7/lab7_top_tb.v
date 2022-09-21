
module lab7_check_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,10'd1,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 1; #5;
    KEY[0] = 0; #5;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
    // check if program from Figure 8 in Lab 7 handout can be found loaded in memory
    if (DUT.MEM.mem[0] !== 16'b1101000000001000) begin err = 1; $display("FAILED: mem[0] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[1] !== 16'b0110000000000000) begin err = 1; $display("FAILED: mem[1] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[2] !== 16'b0110000001000000) begin err = 1; $display("FAILED: mem[2] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[3] !== 16'b1100000001101010) begin err = 1; $display("FAILED: mem[3] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[4] !== 16'b1101000100001001) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[5] !== 16'b0110000100100000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[6] !== 16'b1000000101100000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[7] !== 16'b1110000000000000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[8] !== 16'b0000000101000000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end
    if (DUT.MEM.mem[9] !== 16'b0000000100000000) begin err = 1; $display("FAILED: mem[4] wrong; please set data.txt using Figure 8"); $stop; end

    #10; // wait until next falling edge of clock
    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4

    #10; // waiting for RST state to cause reset of PC

    // Test if reset or not
    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero. %d", DUT.CPU.PC); $stop; end
    $display("present state %d  next state %d", DUT.CPU.FSM.present_state, DUT.CPU.FSM.next_state);

    
    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 1."); $stop; end // test PC



    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 2."); $stop; end // test PC
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h8) begin err = 1; $display("FAILED: R0 should be 8. %d", DUT.CPU.DP.REGFILE.R0); $stop; end // test MOV R0, SW_BASE



    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 3. %d", DUT.CPU.PC); $stop; end // test PC
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h140) begin err = 1; $display("FAILED: R0 should be 16'h140. %d", DUT.CPU.DP.REGFILE.R0); $stop; end // test LDR R0, [R0] 



    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED: PC should be 4."); $stop; end // test PC 
    if (DUT.CPU.DP.REGFILE.R2 !== 16'h1) begin err = 1; $display("FAILED: R2 should be 6."); $stop; end  // test LDR R2, [R0] 



    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED: PC should be 5."); $stop; end // test PC
    if (DUT.CPU.DP.REGFILE.R3 !== 16'h2) begin err = 1; $display("FAILED: R3 should be 2."); $stop; end // test MOV R3, R2, LSL #1


    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
   
    if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 6."); $stop; end // test PC
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h9) begin err = 1; $display("FAILED: R1 should be 9. %d", DUT.CPU.DP.REGFILE.R1); $stop; end // test MOV R1, LEDR_BASE


    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes; autograder expects PC set to 5 *after* executing STR R1, [R2]
   
    if (DUT.CPU.PC !== 9'h7) begin err = 1; $display("FAILED: PC should be 7."); $stop; end // test PC
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h100) begin err = 1; $display("FAILED: R1 should be 16'h100. %d", DUT.CPU.DP.REGFILE.R1); $stop; end // test LDR R1, [R1]



    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
   
    if (DUT.CPU.PC !== 9'h8) begin err = 1; $display("FAILED: PC should be 8."); $stop; end // test PC
    if (DUT.LEDR[7:0] !== 8'h2) begin err = 1; $display("FAILED: LED should be 2. %d", DUT.LEDR); $stop; end // test STR R3, [R1]


    if (~err) $display("PASSED");
    $stop;
  end
endmodule
