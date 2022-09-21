module lab3_top_tb;

	reg err;
	reg [3:0] KEY,SW;
	wire [6:0] HEX5,HEX4,HEX3,HEX2,HEX1,HEX0;
	lab3_top dut(KEY,SW,HEX5,HEX4,HEX3,HEX2,HEX1,HEX0);
	
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

	
	`define O 7'b1000000
	`define P 7'b0101100
	`define E 7'b0000110
	`define n 7'b0101011
	`define C 7'b1000110
	`define L 7'b1000111
	`define S 7'b0010010
	`define D 7'b0000110
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
	
	`define open 2'b00
	`define closed 2'b01
	`define legal 2'b11
	`define illegal 2'b10
	
	initial begin
		KEY[0]=1; #5;
		forever begin
			KEY[0]=0; #5;
			KEY[0]=1; #5;
		end
	end

	initial begin 
		KEY[2]=1'b1;
		KEY[1]=1'b1;
		err=1'b0;
		
		SW=4'b0011;
  
		KEY[3]=1'b0;
 
		#10;

		if(lab3_top_tb.dut.ps !== `S1) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S1);
			err=1'b1;
		end
	
		if(lab3_top_tb.dut.out !== `legal) begin
			$display("ERROR **  out is %b, expected %b", lab3_top_tb.dut.out, `legal);
			err=1'b1;
		end

		KEY[3]=1'b1;
		
		//checking error
		SW=4'b1111; 
		if(HEX0!==`r || HEX1!==`O || HEX2!==`r || HEX3!==`r || HEX4!==`E || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;

		//checking HEX,1-2
		SW=4'b0011; 
		if(HEX0!==`three || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,1-2
		
		if(lab3_top_tb.dut.ps !== `S2) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S2);
			err=1'b1;	
		end
		#10;

		//state2 to state 3,HEX
		SW=4'b0110; 
		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,2-3
		
		if(lab3_top_tb.dut.ps !== `S3) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S3);
			err=1'b1;	
		end
		#10;

		//state3 to state4,HEX
		SW=4'b1001; 
		if(HEX0!==`nine || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,3-4
		
		if(lab3_top_tb.dut.ps !== `S4) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S4);
			err=1'b1;	
		end
		#10;

		//state4 to state5,HEX
		SW=4'b0101; 
		if(HEX0!==`five || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,4-5
		
		if(lab3_top_tb.dut.ps !== `S5) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S5);
			err=1'b1;	
		end
		#10;

		//state5 to state6,HEX
		SW=4'b0110; 
		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,5-6
		
		if(lab3_top_tb.dut.ps !== `S6) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S6);
			err=1'b1;	
		end
		#10;

		//state6 to state7,HEX
		SW=4'b0001; 
		if(HEX0!==`one || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,6-7
		
		if(lab3_top_tb.dut.ps !== `S7) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S7);
			err=1'b1;	
		end
		#10;

		//state7 to state7,HEX 
		if(HEX0!==`n || HEX1!==`E || HEX2!==`P || HEX3!==`O || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;	
		end
		#10;
		//checking state,7-7
		
		if(lab3_top_tb.dut.ps !== `S7) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S7);
			err=1'b1;	
		end
		#10;
		
		//reset
		KEY[3]=0; #10;
		KEY[3]=1; 

		SW=4'b0110; 
		#10;

		//checking state,1-a
		if(lab3_top_tb.dut.ps !== `Sa) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sa);
			err=1'b1;	
		end

		if(lab3_top_tb.dut.out !== `legal) begin
			$display("ERROR **  out is %b, expected %b", lab3_top_tb.dut.out, `legal);
			err=1'b1;
		end


		SW=4'b0110; 
		#10;

		//checking state,a-b
		if(lab3_top_tb.dut.ps !== `Sb) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sb);
			err=1'b1;	
		end

		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR ");
			err=1'b1;
		end
		

		SW=4'b0110; 
		#10;

		//checking state,b-c
		if(lab3_top_tb.dut.ps !== `Sc) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sc);
			err=1'b1;	
		end

		//checking output,b-c
		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;
		end


		SW=4'b0110; 
		#10;

		//checking state,c-d
		if(lab3_top_tb.dut.ps !== `Sd) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sd);
			err=1'b1;	
		end

		//checking output,c-d
		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;
		end


		SW=4'b0110; 
		#10;

		//checking state,d-e
		if(lab3_top_tb.dut.ps !== `Se) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Se);
			err=1'b1;	
		end

		//checking output,d-e
		if(HEX0!==`six || HEX1!=={7{1'b1}} || HEX2!=={7{1'b1}} || HEX3!=={7{1'b1}} || HEX4!=={7{1'b1}} || HEX5!=={7{1'b1}}) begin
			$display("ERROR");
			err=1'b1;
		end

		
		SW=4'b0110; 
		#10;

		//checking state,e-f
		if(lab3_top_tb.dut.ps !== `Sf) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sf);
			err=1'b1;	
		end

		#10
		//checking output,f-close
		if(HEX0!==`D || HEX1!==`E || HEX2!==`S || HEX3!==`O || HEX4!==`L || HEX5!==`C) begin
			$display("ERROR");
			err=1'b1;
		end


		KEY[3]=0;#10;
		KEY[3]=1;
		SW=4'b0011; #10;
		SW=4'b0111; #10;
		//checking state,2-b
		if(lab3_top_tb.dut.ps !== `Sb) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `S2);
			err=1'b1;	
		end
		

		KEY[3]=0;#10;
		KEY[3]=1;
		SW=4'b0011; #10;
		SW=4'b0110; #10;
		SW=4'b0001; #10;
		//checking state,3-c
		if(lab3_top_tb.dut.ps !== `Sc) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sc);
			err=1'b1;	
		end

		KEY[3]=0;#10;
		KEY[3]=1;
		SW=4'b0011; #10;
		SW=4'b0110; #10;
		SW=4'b1001; #10;
		SW=4'b0001; #10
		//checking state,4-d
		if(lab3_top_tb.dut.ps !== `Sd) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sd);
			err=1'b1;	
		end

		KEY[3]=0;#10;
		KEY[3]=1;
		SW=4'b0011; #10;
		SW=4'b0110; #10;
		SW=4'b1001; #10;
		SW=4'b0101; #10;
		SW=4'b0001; #10;
		//checking state,5-e
		if(lab3_top_tb.dut.ps !== `Se) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Se);
			err=1'b1;	
		end

		KEY[3]=0;#10;
		KEY[3]=1;
		SW=4'b0011; #10;
		SW=4'b0110; #10;
		SW=4'b1001; #10;
		SW=4'b0101; #10;
		SW=4'b0110; #10;
		//checking state,6-f
		if(lab3_top_tb.dut.ps !== `Sf) begin
			$display("ERROR ** state is %b, expected %b", lab3_top_tb.dut.ps, `Sf);
			err=1'b1;	
		end



		if(err==1'b0) begin
			$display("Pass");
		end

		$stop;
	end
endmodule
