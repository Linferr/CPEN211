module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output reg[15:0] sout;

always@(*)begin
    case(shift)
    2'b00: sout = in;
    2'b01: sout = in << 1; //2'b01: sout = in << 1;//
    2'b10: sout = in >> 1; //2'b10: sout = in >> 1;//
    2'b11: sout = {in[15],in[15:1]}; // 2'b11: sout = {in[15],in >> 1};//
    default: sout = {16{1'b0}};
    endcase
end

endmodule