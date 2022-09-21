module LED_check(in,out,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0);
	input [1:0] out;
	input [3:0] in;
	output reg[6:0] HEX5, HEX4,HEX3,HEX2,HEX1,HEX0;
	`define S1 4'b0000
	`define S2 4'b0001
	`define S3 4'b0010
	`define S4 4'b0011
	`define S5 4'b0100
	`define S6 4'b0101
	`define S7 4'b0110
	`define Sa 4'b0111
	`define Sb 4'b1000
	`define Sc 4'b1001
	`define Sd 4'b1010
	`define Se 4'b1011
	`define Sf 4'b1100

	`define open 2'b00
	`define closed 2'b01
	`define legal 2'b11
	`define illegal 2'b10
	
	`define O 7'b1000000
	`define P 7'b0001100
	`define E 7'b0000110
	`define n 7'b0101011
	`define C 7'b1000110
	`define L 7'b1000111
	`define S 7'b0010010
	`define D 7'b1000000
	`define r 7'b0101111
	
	`define one 7'b1111001
	`define two 7'b0100100
	`define three 7'b0110000
	`define four 7'b0011001
	`define five 7'b0010010
	`define six 7'b0000010
	`define seven 7'b1111000
	`define eight 7'b0000000
	`define nine 7'b0010000
	`define zero 7'b1000000
		
	always@(*) begin
		case(out)
		`illegal:begin
			HEX5 = {7{1'b1}};
			HEX4 = `E;
			HEX3 = `r;
			HEX2 = `r;
			HEX1 = `O;
			HEX0 = `r;
		 end
				
		`legal: begin
		 case(in)
			4'd1:HEX0 = `one;
			4'd2:HEX0 = `two;
			4'd3:HEX0 = `three;
			4'd4:HEX0 = `four;
			4'd5:HEX0 = `five;
			4'd6:HEX0 = `six;
			4'd7:HEX0 = `seven;
			4'd8:HEX0 = `eight;
			4'd9:HEX0 = `nine;
			4'd0:HEX0 = `zero;
		        default: HEX0 = {7{1'b1}};
		 endcase
	                 HEX5 = {7{1'b1}};
			 HEX4 = {7{1'b1}};
			 HEX3 = {7{1'b1}};
			 HEX2 = {7{1'b1}};
			 HEX1 = {7{1'b1}};
		 end
				
		`open:  begin
			HEX5 = {7{1'b1}};
			HEX4 = {7{1'b1}};
			HEX3 = `O;
			HEX2 = `P;
			HEX1 = `E;
			HEX0 = `n;
		 end			
		`closed:begin
			HEX5 = `C;
			HEX4 = `L;
			HEX3 = `O;
			HEX2 = `S;
			HEX1 = `E;
			HEX0 = `D;
		 end				
		default: begin
			HEX5 = {7{1'b1}};
			HEX4 = {7{1'b1}};
			HEX3 = {7{1'b1}};
			HEX2 = {7{1'b1}};
			HEX1 = {7{1'b1}};
			HEX0 = {7{1'b1}};
		end
	   endcase
	end
endmodule

