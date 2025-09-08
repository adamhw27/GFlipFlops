module cpu (
input [7:0] opcode,
input cin,

output [27:0] segOut
);

wire [15:0] R1;
wire [15:0] R2;

assign R2 = 8'h8FFF;
assign R1 = 8'h0001;


wire [15:0] aluOut;

alu k(.R1(R1N), .R2(R2N), .opcode(opcode), .aluOut(aluOut), .flags(flags), .cin(cin));

seven_seg_hex a(aluOut[3:0], segOut[6:0]);
seven_seg_hex b(aluOut[7:4], segOut[13:7]);
seven_seg_hex c(aluOut[11:8], segOut[20:14]);
seven_seg_hex d(aluOut[15:12], segOut[27:21]);

endmodule