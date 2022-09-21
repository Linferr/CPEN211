module control(clk, reset, opcode, op, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc);
  
  input clk, reset;
  input [2:0] opcode;
  input [1:0] op;
    
  output [1:0] vsel;
  output write;    //input to the REGFILE
  output loada;    //vdffe a
  output loadb;    //vdffe b
  output asel;   //Select to mux before ALU
  output bsel;
  output loadc;    //vdffe c
  output loads;    //status register
  output load_pc;
  output load_ir;
  output addr_sel;
  output load_addr;
  output reset_pc;
  output [1:0] mem_cmd;
  output [2:0] nsel;    

 
// encoding for controller_fsm, 11 states
  `define SW          5
  `define RST         5'b00000
  `define IF1         5'b01001
  `define IF2         5'b01010
  `define updatePC    5'b01011
  `define Decode      5'b00001
  `define GetB        5'b00010 //loading Rm to B is the same for all instructions
  `define GetA        5'b00011 //loading Rn to A is the same for alu
  `define ADD_AND     5'b00100
  `define MVN_MOV     5'b00101 
  `define CMP         5'b00110 //CMP needs status
  `define Write_Back  5'b00111 //Saving result to Rd
  `define Mov_Rn      5'b01000 //Moving sximm8 to Rn

  `define LDR1         5'b10000
  `define LDR2         5'b10001
  `define LDR3         5'b10010
  `define LDR4         5'b10011
  `define LDR5         5'b10100

  `define STR1         5'b10101
  `define STR2         5'b10110
  `define STR3         5'b10111
  `define STR4         5'b11000
  `define STR5         5'b11001
  `define STR6         5'b11010

  `define MNONE       2'b00
  `define MWRITE      2'b01
  `define MREAD       2'b10



  wire [`SW-1:0] present_state, next_state_reset, next_state;
  reg [(`SW+19)-1:0] next; // next = {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}


  // vdff for controller_fsm
  vDFF #(`SW) STATE(clk,next_state_reset,present_state);
  assign next_state_reset = reset ? `RST : next_state; //reset check


  always @(*) 
      casex( {present_state, opcode, op})

      // next = {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}

      {`RST, 3'bxxx, 2'bxx}: next = {  `IF1,          {12{1'b0}},    3'b100,                `MNONE,   1'b0,      1'b1}; // state RST -> state IF1
                                    // next_state, previous_states, load_pc+load_ir+addrsel, mem_cmd, load_addr, reset_pc

      {`IF1, 3'bxxx, 2'bxx}: next = {`IF2, {12{1'b0}}, 3'b001, `MREAD, 1'b0, 1'b0}; // state IF1 -> state IF2
      {`IF2, 3'bxxx, 2'bxx}: next = {`updatePC, {12{1'b0}}, 3'b011, `MREAD, 1'b0, 1'b0}; // state IF2 -> state updatePC
      {`updatePC, 3'bxxx, 2'bxx}: next = {`Decode, {12{1'b0}}, 3'b100, `MNONE, 1'b0, 1'b0}; // state updatePC -> state Decode
//-----------------------------------------------------------------------------------------------------------------/

      //decode state
      {`Decode, 3'b110, 2'b10}: next = {`Mov_Rn, {19{1'b0}}}; // Decode->Mov_To_Rn; MOV Rn,#<im8>
      {`Decode, 3'b110, 2'b00}: next = {`GetB, {19{1'b0}}}; // Decode->GetB; MOV Rd Rm
      {`Decode, 3'b101, 2'bxx}: next = {`GetB, {19{1'b0}}}; // ALU instruction all go to GetB
      {`Decode, 3'b011, 2'b00}: next = {`LDR1, {19{1'b0}}}; // to LDR
      {`Decode, 3'b100, 2'b00}: next = {`STR1, {19{1'b0}}}; // to GET_RN for STR
      {`Decode, 3'b111, 2'bxx}: next = {`Decode, {18{1'b0}}, 1'b1}; // Halt State

//-----------------------------------------------------------------------------------------------------------------/

      //GetB state
      //MOV Rd, Rm
      {`GetB, 3'b110, 2'b00}: 
      next = {`MVN_MOV,    2'b00, 1'b0, 1'b0,  1'b1,  1'b0, 1'b0, 1'b0,  1'b0, 3'b100, 5'd0, 1'b0, 1'b0}; 
            //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7} 

      //MVN Rd, Rm
      {`GetB, 3'b101, 2'b11}: 
      next = {`MVN_MOV,    2'b00, 1'b0,  1'b0,  1'b1,  1'b0, 1'b0, 1'b0,  1'b0, 3'b100, 5'd0, 1'b0, 1'b0}; 
            //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7} 
                                                

      //ADD Rd,Rn Rm and  AND Rd,Rn Rm
      {`GetB, 3'b101,2'bx0}: 
      next = {`GetA,      2'b00, 1'b0, 1'b0,  1'b1,  1'b0, 1'b0,  1'b0, 1'b0, 3'b100, 5'd0, 1'b0, 1'b0}; 
           //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7}                                                 

      //CMP Rn, Rm
      {`GetB, 3'b101,2'b01}: 
      next = {`GetA,     2'b00, 1'b0, 1'b0,  1'b1,  1'b0, 1'b0, 1'b0,  1'b0,  3'b100, 5'd0, 1'b0, 1'b0};
          //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7} 
                                                

//-----------------------------------------------------------------------------------------------------------------/

      //GetA
      //ADD Rd,Rn Rm and  AND Rd,Rn Rm
      {`GetA, 3'b101, 2'bx0}: 
      next = {`ADD_AND,  2'b00, 1'b0, 1'b1,  1'b0,  1'b0, 1'b0, 1'b0,  1'b0, 3 'b001, 5'd0, 1'b0, 1'b0};
         //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7} 


      //CMP Rn, Rm
      {`GetA, 3'b101,2'b01}: 
      next = {`CMP,       2'b00, 1'b0,  1'b1, 1'b0,  1'b0,  1'b0, 1'b0, 1'b0,  3'b001, 5'd0, 1'b0, 1'b0};
           //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7} 
                                             
//-----------------------------------------------------------------------------------------------------------------/

      //MVN State
      //MVN Rd, Rm
      {`MVN_MOV, 3'bxxx, 2'bxx}: 
      next = {`Write_Back,   2'b00, 1'b0,  1'b0,  1'b0,  1'b1, 1'b0, 1'b1,  1'b0,  3'b000, 5'd0, 1'b0, 1'b0};    
             //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads,   nsel,    signals for lab 7} 

//-----------------------------------------------------------------------------------------------------------------/

      //ADD State
      //ADD Rd,Rn Rm   
      {`ADD_AND, 3'bxxx, 2'bxx}: 
      next = {`Write_Back,  2'b00,  1'b0,  1'b0,  1'b0,  1'b0, 1'b0,  1'b1, 1'b0, 3'b000, 5'd0, 1'b0, 1'b0};    
             //{next_state, vsel, write, loada, loadb, asel, bsel, loadc,  loads,  nsel,  signals for lab 7} 

//-----------------------------------------------------------------------------------------------------------------/

      //Get_Status
      //CMP Rn, Rm
      {`CMP, 3'b101, 2'b01}: 
      next = {`IF1,      2'b00, 1'b0,  1'b0,  1'b0,  1'b0, 1'b0, 1'b0,  1'b1,  3'b000, 5'd0, 1'b0, 1'b0};
            //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7}                                             


//-----------------------------------------------------------------------------------------------------------------/

      //Result_To_Rd
      //
      {`Write_Back, 3'bxxx, 2'bxx}: 
      next = {`IF1,       2'b00, 1'b1,  1'b0,  1'b0,  1'b0, 1'b0, 1'b0,  1'b0,  3'b010, 5'd0, 1'b0, 1'b0};   
            //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7}    
                                              
//-----------------------------------------------------------------------------------------------------------------/
      //Mov_Rn state 
      //to wait state
      {`Mov_Rn, 3'bxxx, 2'bxx}: 
      next = {`IF1,      2'b10, 1'b1,  1'b0,  1'b0,  1'b0, 1'b0, 1'b0, 1'b0, 3'b001, 3'd0, `MNONE, 1'b0, 1'b0};      
            //{next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel,  signals for lab 7}

//-----------------------------------------------------------------------------------------------------------------/
      //LDR & STR 
      //Get the value in Rn
      {`LDR1, 3'bxxx, 2'bxx}:
      next = {`LDR2,    2'b00, 1'b0,   1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0,   3'b001, 1'b0,   1'b0,    1'b0,   `MNONE,    1'b0,     1'b0}; 
      //    {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`LDR2, 3'bxxx, 2'bxx}:
      next = {`LDR3,    2'b00, 1'b0,   1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0,   3'b000, 1'b0,   1'b0,    1'b0,   `MNONE,    1'b0,     1'b0}; 
      //    {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`LDR3, 3'bxxx, 2'bxx}:
      next = {`LDR4,      2'b00, 1'b0, 1'b0,  1'b0,  1'b0, 1'b0,  1'b0,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,    `MNONE, 1'b1,       1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`LDR4, 3'bxxx, 2'bxx}:
      next = {`LDR5,      2'b00, 1'b0, 1'b0,  1'b0,  1'b0, 1'b0,  1'b0,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,    `MREAD, 1'b0,       1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`LDR5, 3'bxxx, 2'bxx}:
      next = {`IF1,      2'b11, 1'b1, 1'b0,  1'b0,  1'b0, 1'b0,  1'b0,  1'b0, 3'b010, 1'b0,    1'b0,    1'b0,    `MREAD, 1'b0,       1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}


      {`STR1, 3'bxxx, 2'bxx}:
      next = {`STR2,     2'b00, 1'b0, 1'b1,  1'b0, 1'b0,  1'b0, 1'b0, 1'b0, 3'b001, 1'b0,    1'b0,    1'b0,    `MNONE,   1'b0,      1'b0}; 
      //    {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}   
      {`STR2, 3'bxxx, 2'bxx}:
      next = {`STR3,      2'b00, 1'b0, 1'b0,  1'b0,  1'b0, 1'b1,  1'b1,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,   `MNONE,  1'b0,      1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`STR3, 3'bxxx, 2'bxx}:
      next = {`STR4,      2'b00, 1'b0, 1'b0,  1'b0,  1'b0, 1'b0,  1'b0,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,   `MNONE,  1'b1,      1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`STR4, 3'bxxx, 2'bxx}:
      next = {`STR5,      2'b00, 1'b0, 1'b0,  1'b1,  1'b1, 1'b0,  1'b0,  1'b0, 3'b010, 1'b0,    1'b0,    1'b0,   `MNONE,  1'b0,      1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}
      {`STR5, 3'bxxx, 2'bxx}:
      next = {`STR6,      2'b00, 1'b0, 1'b0,  1'b0,  1'b1, 1'b0,  1'b1,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,   `MNONE,  1'b0,      1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}  
      {`STR6, 3'bxxx, 2'bxx}:
      next = {`IF1,      2'b00, 1'b0, 1'b0,  1'b0,  1'b0, 1'b0,  1'b0,  1'b0, 3'b000, 1'b0,    1'b0,    1'b0,   `MWRITE,  1'b0,      1'b0};
      //     {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc}  

      default: next = {`IF1, {19{1'b0}}};
      endcase

      // copy to module outputs  
      assign {next_state, vsel, write, loada, loadb, asel, bsel, loadc, loads, nsel, load_pc, load_ir, addr_sel, mem_cmd, load_addr, reset_pc} = next;

endmodule

module vDFF(clk,next_state_reset,present_state);
  parameter n = 2;

  input clk;
  input [n-1:0] next_state_reset;
  output [n-1:0] present_state;

  reg [n-1:0] present_state;

  always @(posedge clk) begin
    present_state = next_state_reset;
  end
endmodule
