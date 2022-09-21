module datapath (mdata,sximm8,PC,vsel, writenum,write,readnum,clk,loada,  
                loadb,shift,sximm5, asel, bsel,ALUop, loadc, loads, state_out,  
                datapath_out); 


    input[15:0] mdata;  
    input[15:0] sximm8, sximm5; //sximm8 is the actual input to look at
    input [7:0] PC;

    input write,clk,loada,loadb,loadc,loads,asel,bsel;
    input [2:0] writenum,readnum;
    input [1:0] vsel;
    input [1:0] shift,ALUop;
    output [15:0] datapath_out;
    output [2:0] state_out;

    reg [15:0] data_in;
    wire [15:0] data_out, loada_out, loadb_out, sout, Ain, Bin, out, PC;
    wire [2:0] status_in;

    //changed mux of data_in
    always @(*) begin
        case(vsel)
            2'b00: data_in = datapath_out;         //0
	        2'b01: data_in = {{8{1'b0}}, PC};      //1
	        2'b10: data_in = sximm8;               //2
	        2'b11: data_in = mdata;                //3
            default: data_in = {16{1'b0}};              
        endcase
    end

    //register file
    regfile REGFILE (data_in,writenum,write,readnum,clk,data_out);
    
    vDFFE #(16) LA(clk, loada, data_out, loada_out);
    vDFFE #(16) LB(clk, loadb, data_out, loadb_out);

    shifter SHF(loadb_out, shift, sout);

    assign Ain = asel ? 16'b0 : loada_out;
    
    //changed mux B
    assign Bin = bsel ? sximm5 : sout;

    //changed alu
    ALU U2(Ain, Bin, ALUop, out, status_in);
    //vdffe C
    vDFFE #(16) LC(clk, loadc, out, datapath_out);
    //changed vdffe status 
    vDFFE #(3) status(clk, loads, status_in, state_out);
    
endmodule

