module cpu (
input [7:0] opcode,
input cin,
input clck, reset,

output [27:0] segOut,
output [4:0] flags
);

// Make registers
wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8 ,r9, r10, r11, r12, r13, r14, r15;

// Connect R1 and R2 alu
wire [15:0] R1;
wire [15:0] R2;

// Connect regEnable to RegFile
wire [15:0] regEnable;

//assign R2 = 16'h7FFF;
//assign R1 = 16'h0001;

// To connect to Bus
wire [15:0] aluOut;

// To connect mux to FSM
wire [3:0] srcSel;
wire [3:0] dstSel;

// To connect Immediate/Reg to ALU
wire regImmSel;
wire [15:0] rDstMuxToImmMux;

//Instantiating the ALU
alu alu(.R1(R1), .R2(R2), .opcode(opcode), .aluOut(aluOut), .flags(flags), .cin(cin));

// Connect Alu out to Reg Bank
RegBank rb(.ALUBus(aluOut), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6),
					.r7(r7), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .regEnable(regEnable), .clk(clk), .reset(reset));
					
					
// Connect Rsrc to ALU via Mux

RegMux RSrcMux(.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r9(r9), 
					.r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .sel(srcSel), .out(R1));
					
// Set up RDst mux. Connect output to ImmReg mux

RegMux RDstMux(.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r9(r9), 
					.r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .sel(dstSel), .out(rDstMuxToImmMux));
				
// Determine Imm or Reg for second ALU input	
	
TwoInputMux immMux(.i0(rDstMuxToImmMux), .i1(imm), .sel(regImmSel), .out(R2));

// Connect SegOut
seven_seg_hex a(aluOut[3:0], segOut[6:0]);
seven_seg_hex b(aluOut[7:4], segOut[13:7]);
seven_seg_hex c(aluOut[11:8], segOut[20:14]);
seven_seg_hex d(aluOut[15:12], segOut[27:21]);

endmodule