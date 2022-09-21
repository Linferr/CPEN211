module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
  input [3:0] KEY;
  input [9:0] SW;
  output [9:0] LEDR;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  wire enable, write, msel, N, V, Z;
  wire [1:0] mem_cmd;
  wire [8:0] mem_addr;
  wire [15:0] read_data, write_data, din, dout;

  reg read_cmp, write_cmp, circuit1_out, circuit2_out;

  `define MREAD    2'b10
  `define MWRITE   2'b01

  assign read_data = enable ? dout : {16{1'bz}}; // tri_state driver
  assign din = write_data;
  assign write = write_cmp & msel; 
  assign msel = mem_addr[8:8] ? 1'b0 : 1'b1; // the second equality comparison
  assign enable = msel & read_cmp;


  // Memory mapped I/O
  assign LEDR[9:8] = 2'd0;

  // circuit design 1 for read
  always @(*) begin
    case({mem_cmd, mem_addr}) 
      {`MREAD, 9'h140} : circuit1_out = 1'b1;
      default: circuit1_out = 1'b0;
    endcase
  end 

  assign read_data[15:8] = circuit1_out ? 8'h00 : {8{1'bz}};
  assign read_data[7:0] = circuit1_out ? SW[7:0] : {8{1'bz}};

  // circuit design 2 for write
  always @(*) begin
    case({mem_cmd, mem_addr}) 
      {`MWRITE, 9'h100} : circuit2_out = 1'b1;
      default: circuit2_out = 1'b0;
    endcase
  end 
  
  vDFFE #(8) vDFF_LEDR(~KEY[0], circuit2_out, write_data[7:0], LEDR[7:0]);

  // read equality comparison
  always @(*) begin
    case (mem_cmd)
      `MREAD : read_cmp = 1'b1;
      default : read_cmp = 1'b0;
    endcase
  end

  // write equality comparison
  always @(*) begin
    case (mem_cmd)
      `MWRITE : write_cmp = 1'b1;
      default : write_cmp = 1'b0;
    endcase
  end

  mem #(16, 8, "data.txt") MEM(~KEY[0], mem_addr[7:0], mem_addr[7:0], write, din, dout);
  cpu CPU(~KEY[0], ~KEY[1], read_data, write_data, mem_addr, mem_cmd, N, V, Z);
endmodule

module mem(clk,read_address,write_address,write,din,dout);  parameter data_width = 32;   parameter addr_width = 4;  parameter filename = "data.txt";  input clk;  input [addr_width-1:0] read_address, write_address;  input write;  input [data_width-1:0] din;
  output [data_width-1:0] dout;
  reg [data_width-1:0] dout;  reg [data_width-1:0] mem [2**addr_width-1:0];  initial $readmemb(filename, mem);  always @ (posedge clk) begin    if (write)      mem[write_address] <= din;    dout <= mem[read_address];   end endmodule
