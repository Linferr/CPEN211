module regfile(data_in,writenum,write,readnum,clk,data_out);
input[15:0]data_in;
input[2:0]writenum;
input[2:0]readnum;
input write;
input clk;
output[15:0]data_out;

wire[7:0]out_1;
wire[7:0]out_2;
wire[15:0]R0,R1,R2,R3,R4,R5,R6,R7;
wire[15:0]data_out;

decoder1 b1(writenum,write,out_1);

vDFFE #(16) r0(clk,out_1[0],data_in,R0);
vDFFE #(16) r1(clk,out_1[1],data_in,R1);
vDFFE #(16) r2(clk,out_1[2],data_in,R2);
vDFFE #(16) r3(clk,out_1[3],data_in,R3);
vDFFE #(16) r4(clk,out_1[4],data_in,R4);
vDFFE #(16) r5(clk,out_1[5],data_in,R5);
vDFFE #(16) r6(clk,out_1[6],data_in,R6);
vDFFE #(16) r7(clk,out_1[7],data_in,R7);

decoder2 b2(readnum,out_2);
mux b3(R0,R1,R2,R3,R4,R5,R6,R7,out_2,data_out);

endmodule

module vDFFE(clk, en, in, out) ;
  parameter n = 1;  // width
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always @(posedge clk)
    out = next_out;  
endmodule

module decoder1(writenum,write,out);
input [2:0] writenum;
input write;
output [7:0] out;
reg [7:0] out;
 
always @( writenum or write)begin
if(write)begin
out=8'd0;
case (writenum)
3'b000: out[0]=1'b1;
3'b001: out[1]=1'b1;
3'b010: out[2]=1'b1;
3'b011: out[3]=1'b1;
3'b100: out[4]=1'b1;
3'b101: out[5]=1'b1;
3'b110: out[6]=1'b1;
3'b111: out[7]=1'b1;
default: out=8'd0;
endcase
end
else 
out=8'd0;
end
endmodule




module decoder2(readnum,out);
input [2:0] readnum;
output [7:0] out;
reg [7:0] out;
 
always @(*)begin
out=8'd0;
case (readnum)
3'b000: out[0]=1'b1;
3'b001: out[1]=1'b1;
3'b010: out[2]=1'b1;
3'b011: out[3]=1'b1;
3'b100: out[4]=1'b1;
3'b101: out[5]=1'b1;
3'b110: out[6]=1'b1;
3'b111: out[7]=1'b1;
default: out=8'd0;
endcase
end
endmodule

module mux(R0,R1,R2,R3,R4,R5,R6,R7,s,out);
input[15:0]R0,R1,R2,R3,R4,R5,R6,R7;
input[7:0]s;
output reg[15:0]out;

always@(*)begin
case(s)
8'b00000001: out = R0;
8'b00000010: out = R1;
8'b00000100: out = R2;
8'b00001000: out = R3;
8'b00010000: out = R4;
8'b00100000: out = R5;
8'b01000000: out = R6;
8'b10000000: out = R7;
default: out = {16{1'b0}};
endcase
end

endmodule
