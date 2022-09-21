module cpu(clk,reset,read_data,write_data,mem_addr,mem_cmd,N,V,Z);
input clk;

input reset; 
input [15:0] read_data;

output [15:0] write_data;
output [8:0] mem_addr;
output [1:0] mem_cmd;
output N, V, Z;

wire[15:0] IR_out;
wire [2:0] nsel;
wire [2:0] opcode;
wire [1:0] op;

wire [1:0] ALUop;
wire [15:0] sximm5;
wire [15:0] sximm8;
wire [1:0] shift;
wire [2:0] readnum;
wire [2:0] writenum;

wire [1:0] vsel;    
wire write, loada, loadb, asel, bsel, loadc, loads, load_addr, load_pc, reset_pc, load_ir, addr_sel;
wire [8:0] next_pc, PC, data_addr_out, add_out;

assign mem_addr = addr_sel ? PC : data_addr_out;
assign add_out = PC + 9'd1;
assign next_pc = reset_pc ? 9'd0 : add_out;

// program counter
vDFFE #(9) Program_Counter(clk, load_pc, next_pc, PC);
// instruction register
vDFFE #(16) Instruction_Register(clk, load_ir, read_data, IR_out);
// data address
vDFFE #(9) Data_Address(clk, load_addr, write_data[8:0], data_addr_out);

//instruction decoder
instuction_decoder Insruction_Decoder(IR_out, nsel, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum);

//control FSM
control FSM(clk, reset, opcode, op, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc);

//datapath
datapath DP(read_data, sximm8, 16'd0, vsel, writenum, write, readnum, clk, loada, loadb, shift, sximm5,asel, bsel,ALUop, loadc, loads, {Z,N,V}, write_data);

endmodule


