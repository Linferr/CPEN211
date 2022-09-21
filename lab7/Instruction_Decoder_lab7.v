module instuction_decoder(IR_out, nsel, opcode, op, ALUop, sximm5, sximm8,
                          shift,readnum, writenum);
  
  
  
  input [15:0] IR_out;//Inputs to the Decoder
  input [2:0] nsel; //NOTE: Use the 1-HOT select for Rn | Rd | Rm

  output [2:0] opcode;//To FSM
  output [1:0] op;

  output [1:0] ALUop;//To datapath
  output [15:0] sximm5, sximm8;

  output [1:0] shift;
  output [2:0] readnum, writenum;
 

  //wire [4:0] imm5;
  // wire [7:0] imm8;
  //reg [2:0] wr_num;
  wire [2:0] Rn, Rd, Rm;
  wire [2:0] nsel_out;

  // wire assignments
  assign opcode = IR_out [15:13];
  assign op = IR_out [12:11];
  assign ALUop = IR_out [12:11];
  assign Rn = IR_out [10:8];
  assign Rd = IR_out [7:5];
  assign shift = IR_out [4:3];
  assign Rm = IR_out [2:0];


  // sign extend
  //Sign extends bit 4
  assign sximm5 = (IR_out[4])? {{11{1'b1}},IR_out[4:0]} : {{11{1'b0}},IR_out[4:0]};
  //Sign extends bit 7;
  assign sximm8 = (IR_out[7])? {{8{1'b1}},IR_out[7:0]} : {{8{1'b0}},IR_out[7:0]};

  //nsel mux out to readnum and writenum
  Mux31 #(3) n_mux(Rm, Rd, Rn, nsel, nsel_out);
  
  //outputs of the MUX
  assign writenum = nsel_out;
  assign readnum = nsel_out;

endmodule



//------------------------------------------------------------------------------------------------------------------/
//3-Input-1-HOT-Select-MUX
module Mux31(a2, a1, a0, sel, b);

  parameter k = 8;
  input [k-1:0] a2, a1, a0; 
  input [2:0] sel; 
  output [k-1:0] b;
  reg [k-1:0] b;

  always @ ( * ) begin
    case (sel)
      3'b001: b = a0;
      3'b010: b = a1;
      3'b100: b = a2;
      default: b = 8'b0; 
    endcase
  end

endmodule
