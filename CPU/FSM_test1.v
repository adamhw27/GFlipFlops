// This FSM is to test ALU instruction with the Fibonacci addition sequence

module FSM_test1 (
	input  clk,
	input  rst,
	output reg [15:0] regEnable,
	output reg flagEn, RorI,
	output reg [7:0] opcode,
	output reg [3:0] Rsrc, Rdest,
	output reg [15:0] imm
);
	
   reg [3:0] state;
   
	parameter ADD = 8'b0000_0101;
	parameter ADDI = 8'b0101_xxxx;
	parameter ADDU = 8'b0000_0110; 
	parameter ADDUI = 8'b0110_xxxx; 
	parameter ADDC = 8'b0000_0111;
	parameter ADDCI = 8'b0111_xxxx;

	parameter MUL = 8'b0000_1110;
	parameter MULI = 8'b1110_xxxx;

	parameter SUB = 8'b0000_1001;
	parameter SUBI = 8'b1001_xxxx;
	parameter SUBC = 8'b0000_1010;
	parameter SUBCI = 8'b1010_xxxx;

	parameter CMP = 8'b0000_1011;
	parameter CMPI = 8'b1011_xxxx;

	parameter AND = 8'b0000_0001;
	parameter ANDI = 8'b0001_xxxx;
	parameter OR = 8'b0000_0010;
	parameter ORI = 8'b0010_xxxx;
	parameter XOR = 8'b0000_0011;
	parameter XORI = 8'b0011_xxxx;
	parameter MOV = 8'b0000_1101;
	parameter MOVI = 8'b1101_xxxx;

	parameter LSH = 8'b1000_1000;
	parameter LSHI = 8'b1000_000x;
	parameter ASHU = 8'b1000_1111;
	parameter ASHUI = 8'b1000_001x;

	// states
	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;
	parameter S10 = 4'b1010;
	parameter S11 = 4'b1011;
	parameter S12 = 4'b1100;
	parameter S13 = 4'b1101;
	parameter S14 = 4'b1110;
	parameter S15 = 4'b1111;
 
	always @(posedge clk or negedge rst) begin
	  if (~rst) state <= S0;
	  else begin
			case (state)
				 S0: state <= S1;
				 S1: state <= S2;
				 S2: state <= S3;
				 S3: state <= S4;
				 S4: state <= S5;
				 S5: state <= S6;
				 S6: state <= S7;
				 S7: state <= S8;
				 S8: state <= S9;
				 S9: state <= S10;
				 S10: state <= S11;
				 S11: state <= S12;
				 S12: state <= S13;
				 S13: state <= S14;
				 S14: state <= S15;
				 S15: state <= S15;
				 default: state <= S0;
			endcase
	  end
	end

	always @(state) begin
	  regEnable = {15{1'b0}}; 

	  case(state)
			S0: begin							// Description of output regs:
				 regEnable = {15{1'b0}};	// - Enable which register the data should go into
				 opcode = 8'h00;				// - Opcode
				 flagEn = 0;					// - Enable flags
				 Rsrc   = 4'd0;				// - Source (2nd operand) register
				 Rdest  = 4'd0;				// - Destination (1st operand) register
				 imm    = 16'd0;				// - Immediate value
				 RorI   = 0;					// - Read from Register or Immediate
			end
			S1: begin // R2 = R1 (16'd1) + R0 (16'd0)
				 regEnable[2] = 1;
				 opcode = ADDI;
				 flagEn = 0;
				 Rsrc   = 4'd0;
				 Rdest  = 4'd1;
				 imm    = 16'd1;
				 RorI   = 1;
			end
			S2: begin // R3 = R2 + R1
				 regEnable[3] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd1;
				 Rdest  = 4'd2;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S3: begin // R4 = R3 + R2
				 regEnable[4] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd2;
				 Rdest  = 4'd3;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S4: begin // R5 = R4 + R3
				 regEnable[5] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd3;
				 Rdest  = 4'd4;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S5: begin // R6 = R5 + R4
				 regEnable[6] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd4;
				 Rdest  = 4'd5;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S6: begin // R7 = R6 + R5
				 regEnable[7] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd5;
				 Rdest  = 4'd6;
				 imm    = 16'd0; 
				 RorI   = 0;
			end
			S7: begin // R8 = R7 + R6
				 regEnable[8] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd6;
				 Rdest  = 4'd7;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S8: begin // R9 = R8 + R7
				 regEnable[9] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd7;
				 Rdest  = 4'd8;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S9: begin // R10 = R9 + R8
				 regEnable[10] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd8;
				 Rdest  = 4'd9;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S10: begin // R11 = R10 + R9
				 regEnable[11] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd9;
				 Rdest  = 4'd10;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S11: begin // R12 = R11 + R10
				 regEnable[12] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd10;
				 Rdest  = 4'd11;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S12: begin // R13 = R12 + R11
				 regEnable[13] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd11;
				 Rdest  = 4'd12;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S13: begin // R14 = R13 + R12
				 regEnable[14] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd12;
				 Rdest  = 4'd13;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S14: begin // R15 = R14 + R13
				 regEnable[15] = 1;
				 opcode = ADD; 
				 flagEn = 0;
				 Rsrc   = 4'd13;
				 Rdest  = 4'd14;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			S15: begin // Move R15 back into R15 for output to 7-seg
				 regEnable[15] = 1;
				 opcode = MOV; 
				 flagEn = 0;
				 Rsrc   = 4'd15;
				 Rdest  = 4'd0;
				 imm    = 16'd0;
				 RorI   = 0;
			end
			default: begin
				regEnable = {15{1'b0}};
				opcode = 8'h00;
				flagEn = 0;
				Rsrc   = 4'd0;
				Rdest  = 4'd0;
				imm    = 16'd0;
				RorI   = 0;
			end
	  endcase
	end

endmodule