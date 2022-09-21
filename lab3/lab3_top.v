module lab3_top(KEY,SW,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0);
	input [3:0] KEY;
	input [3:0] SW;
	output [6:0] HEX5,HEX4,HEX3,HEX2,HEX1,HEX0;
	wire [6:0]HEX5,HEX4,HEX3,HEX2,HEX1,HEX0;

	reg [1:0] out;
	wire clk,reset;
	wire [3:0] in;
	
	wire [3:0] ps, ns_reset;
	reg [3:0] ns;
	assign clk = ~KEY[0];
	assign reset = ~KEY[3];
	assign in = SW;
	
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
	
	vDFF #(4) STATE(clk, ns_reset, ps);
	assign ns_reset = reset ? 4'b0000:ns;
	
	always@(*) begin
		if(in > 4'd9)
			case(ps)
			`S1: begin
				ns = `Sa;
				out = `illegal;
			end
			`S2: begin
				ns = `Sb;
				out =`illegal;
			end
			`S3: begin
				ns = `Sc;
				out = `illegal;
			end
			`S4: begin
				ns = `Sd;
				out = `illegal;
			end
			`S5: begin
				ns = `Se;
				out = `illegal;
			end
			`S6: begin
				ns = `Sf;
				out = `illegal;
			end
			`S7: {ns,out} = {`S7,`open};
			
			`Sa: {ns,out} = {`Sb,`illegal};
			`Sb: {ns,out} = {`Sc,`illegal};
			`Sc: {ns,out} = {`Sd,`illegal};
			`Sd: {ns,out} = {`Se,`illegal};
			`Se: {ns,out} = {`Sf,`illegal};
			`Sf: {ns,out} = {`Sf,`closed};
			
			default {ns,out} = {6{1'b0}};
		endcase
			
		else begin
			case(ps)
			`S1: begin
				if( in == 4'b0011)
					ns = `S2;
				else
					ns = `Sa;
				out = `legal;
			end
			`S2: begin
				if( in == 4'b0110)
					ns = `S3;
				else
					ns = `Sb;
				out =`legal;
			end
			`S3: begin
				if( in == 4'b1001)
					ns = `S4;
				else
					ns = `Sc;
				out = `legal;
			end
			`S4: begin
				if( in == 4'b0101)
					ns = `S5;
				else
					ns = `Sd;
				out = `legal;
			end
			`S5: begin
				if( in == 4'b0110)
					ns = `S6;
				else
					ns = `Se;
				out = `legal;
			end
			`S6: begin
				if( in == 4'b0001)
					ns = `S7;
				else
					ns = `Sf;
				out = `legal;
			end
			`S7: {ns,out} = {`S7,`open};
			
			`Sa: {ns,out} = {`Sb,`legal};
			`Sb: {ns,out} = {`Sc,`legal};
			`Sc: {ns,out} = {`Sd,`legal};
			`Sd: {ns,out} = {`Se,`legal};
			`Se: {ns,out} = {`Sf,`legal};
			`Sf: {ns,out} = {`Sf,`closed};
			
			default {ns,out} = {6{1'b0}};
		endcase
	    end
	end
	LED_check u1(in,out,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0);
endmodule

module vDFF(clk,in,out);
		parameter n=1;
		input [n-1:0] in;
		input [n-1:0] clk;
		output [n-1:0] out;
		reg [n-1:0] out;
		
		always@(posedge clk)
			out = in;
endmodule


