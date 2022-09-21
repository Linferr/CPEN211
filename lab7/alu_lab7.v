
module ALU(Ain,Bin,ALUop,out,status);
input [15:0] Ain, Bin;
input [1:0] ALUop;
output reg[15:0] out;
output reg [2:0] status;

`define ADD 1'b0
`define SUB 1'b1

wire[15:0] add_result,sub_result;
wire ovf_add, ovf_sub;
//wire Z,N,V;

// assign z n v from status[2:0]
//assign Z = status[2];
//assign N = status[1];
//assign V = status[0];

//ALUop add and sub
AddSub #(16) add(Ain, Bin, `ADD, add_result, ovf_add);
AddSub #(16) sub(Ain, Bin, `SUB, sub_result, ovf_sub);

always@(*)begin
    case(ALUop)
    2'b00:begin 
        out = add_result;

        //check Z
        if(out == {16{1'b0}})
        status[2] = 1'b1;
        else
        status[2] = 1'b0;

        //check N
        if(out[15] == 1'b0)
        status[1] = 1'b0;
        else
        status[1] = 1'b1;

        //check V
        status[0] = ovf_add;
    end

    2'b01:begin 
        out = sub_result;

        //check Z
        if(out == {16{1'b0}})
        status[2] = 1'b1;
        else
        status[2] = 1'b0;

        //check N
        if(out[15] == 1'b0)
        status[1] = 1'b0;
        else
        status[1] = 1'b1;

        //check V
        status[0] = ovf_sub;
    end

    2'b10:begin
        out = Ain & Bin;

        //check Z
        if(out == {16{1'b0}})
        status[2] = 1'b1;
        else
        status[2] = 1'b0;

        //check N
        if(out[15] == 1'b0)
        status[1] = 1'b0;
        else
        status[1] = 1'b1;

        //check V
        status[0] = 1'b0;
    end

    2'b11:begin
        out = ~ Bin;

        //check Z
        if(out == {16{1'b0}})
        status[2] = 1'b1;
        else
        status[2] = 1'b0;

        //check N
        if(out[15] == 1'b0)
        status[1] = 1'b0;
        else
        status[1] = 1'b1;

        //check V
        status[0] = 1'b0;
    end

    default:{out,status} = {19{1'b0}};
    endcase

end
endmodule



//module for ovf
module AddSub(a,b,sub,s,ovf) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input sub ;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder1 #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]) ;
  // add sign bits
  Adder1 #(1)   as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]) ;
endmodule


//moudle adder
module Adder1(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin ;
endmodule 
