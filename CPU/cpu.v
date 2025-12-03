module cpu (
input cin,
input clk, rst,

inout  AUD_ADCLRCK,
input  AUD_ADCDAT,
inout  AUD_DACLRCK,
output AUD_DACDAT,
output AUD_XCK,
inout  AUD_BCLK,
output AUD_I2C_SCLK,
inout  AUD_I2C_SDAT,

);

// 16 bit instruction pulled from mem
wire [15:0] instruction;


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
wire [15:0] ALUBus;

// To connect mux to FSM
wire [3:0] srcSel;
wire [3:0] dstSel;

// To connect Immediate/Reg to ALU
wire regImmSel;
wire [15:0] rSrcMuxToImmMux;

// opcode wire
wire [7:0] opcode;

// immediate connect wire
wire [15:0] immConnect;

//immediate sel wire
wire immSel;

// PC enable
wire PCen;
wire [15:0] PCvalue;

//immediate sel wire - right now it does nothing 
//wire flagEn;

// Temp wire to ignore flags
wire [4:0] flags;

// write enable for mem
wire LScntl;
wire we_a;
wire [15:0] address;

// alu bus mux
wire Alu_Mux_cntl;

wire [15:0] PCincr;
wire [7:0] displacement;
wire [15:0] jumpLocation;
wire dispSel;
wire jumpMux;
wire [15:0] inputToRB;
wire RetAddrSave;

// PC
pc pc(.PCen(PCen), .clk(clk), .rst(rst), .incr(PCincr), .outPC(PCvalue));

wire [15:0] nextpc = 16'b1 + PCvalue;

// mux to either increment PC by 1 (go to next instruction) or go to a different location
TwoInputMux pcincr(.i0(nextpc), .i1(jumpLocation), .sel(jumpMux), .out(PCincr));

// PC displacement calculator
PCDisplacementCalculator dispCalc(.inPC(PCvalue), .Rtarget(rSrcMuxToImmMux), .disp(displacement), .target_or_disp(dispSel), .incr(jumpLocation));

//instantiating flag wires
wire [4:0] currentFlags;
wire flagEn;

// audio wires
wire reset = !rst;
wire main_clk;
wire audio_clk;

wire [1:0] sample_end;
wire [1:0] sample_req;
wire [15:0] audio_output;
wire [15:0] audio_input;
wire [3:0] maskEn;
wire [3:0] cnter;


// call fsm2 test
generalFSM fsm(.clk(clk), .rst(rst), .flags(currentFlags), .inst(instruction), .Ren(regEnable), .PCen(PCen), .RorI(immSel), .LScntl(LScntl), .we_a(we_a), .Alu_Mux_cntl(Alu_Mux_cntl), .flagEn(flagEn), .RetAddrSave(RetAddrSave), .opcode(opcode), .Rsrc(srcSel), .Rdest(dstSel), .imm(immConnect), .displacement(displacement), .j_or_b_Sel(dispSel), .PCSel(jumpMux));


//instantiating the ALU
alu alu(.R1(R1), .R2(R2), .opcode(opcode), .aluOut(aluOut), .flags(flags), .cin(cin));

// flags reg
FlagReg flagReg(.clk(clk), .rst(rst), .iFlags(flags), .flagEn(flagEn), .oFlags(currentFlags));

// Connect Alu out to Reg Bank
RegBank rb(.din(inputToRB), .r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6),
					.r7(r7), .r8(r8), .r9(r9), .r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .regEnable(regEnable), .clk(clk), .rst(rst));
					

TwoInputMux returnAddress(.i0(ALUBus), .i1(nextpc), .sel(RetAddrSave), .out(inputToRB));
					
					
// Connect Rsrc to ALU via Mux

RegMux RSrcMux(.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), 
					.r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .sel(srcSel), .out(rSrcMuxToImmMux));
					
// Set up RDst mux. Connect output to ImmReg mux

RegMux RDstMux(.r0(r0), .r1(r1), .r2(r2), .r3(r3), .r4(r4), .r5(r5), .r6(r6), .r7(r7), .r8(r8), .r9(r9), 
					.r10(r10), .r11(r11), .r12(r12), .r13(r13), .r14(r14), .r15(r15), .sel(dstSel), .out(R2));
				
// Determine Imm or Reg for second ALU input	
TwoInputMux immMux(.i0(rSrcMuxToImmMux), .i1(immConnect), .sel(immSel), .out(R1));

// Determine whether we are using LS address passed from logic, or PCvalue address	
TwoInputMux LScntlMux(.i0(PCvalue), .i1(R2), .sel(LScntl), .out(address));

// Memory setup
true_dual_port_ram_single_clock memory(.data_a(R1), .data_b(data_b), .addr_a(address), .addr_b(addr_b), .we_a(we_a), .we_b(we_b), .clk(clk), .q_a(instruction), .q_b(q_b));

// Determine whether we are using aluout or data out	
TwoInputMux ALUmux(.i0(aluOut), .i1(instruction), .sel(Alu_Mux_cntl), .out(ALUBus));


pll pll (
    .refclk (OSC_50_B8A), // change this
    .rst (reset), 
    .outclk_0 (main_clk),
    .outclk_1 (audio_clk) 
);

i2c_config av_config (
    .clk (main_clk),
    .reset (reset),
    .i2c_sclk (AUD_I2C_SCLK),
    .i2c_sdat (AUD_I2C_SD AT),
    .status (LED) // get rid of LED
);

assign AUD_XCK = audio_clk;

audio_transfer af (
    .clk (audio_clk),
    .reset (reset),
    .sample_end (sample_end),
    .sample_req (sample_req),
    .audio_output (audio_output),
    .audio_input (audio_input),
    .channel_sel (2'b10),

    .AUD_ADCLRCK (AUD_ADCLRCK),
    .AUD_ADCDAT (AUD_ADCDAT),
    .AUD_DACLRCK (AUD_DACLRCK),
    .AUD_DACDAT (AUD_DACDAT),
    .AUD_BCLK (AUD_BCLK)
);

bitStreamControl (
	.clk(clk),
	.enable16(q_b),
	.enable_mask(maskEn),
	.address(addr_b),
	.counter(cnter)
);

bitStreamAudio ae (
    .clk (audio_clk),
    .sample_req (sample_req[1]),
	 .enable_mask (maskEn),
    .audio_output (audio_output)
);


// PS2 Stuff

ps2_top_test ps2(
	.clk(clk), .rst(rst),				
	.ps2_clk, ps2_dat,	
	led				
);









endmodule