module cpu (
input [2:0] R1, R2,
input [7:0] opcode,

output [27:0] segOut
);

wire [15:0] R1N;
wire [15:0] R2N;

assign R1N = {{13{R1[2]}}, R1};
assign R2N = {{13{R2[2]}}, R2};


wire [15:0] aluOut;

alu k(.R1(R1N), .R2(R2N), .opcode(opcode), .aluOut(aluOut), .flags(flags));

seven_seg_hex a(aluOut[3:0], segOut[6:0]);
seven_seg_hex b(aluOut[7:4], segOut[13:7]);
seven_seg_hex c(aluOut[11:8], segOut[20:14]);
seven_seg_hex d(aluOut[15:12], segOut[27:21]);

endmodule