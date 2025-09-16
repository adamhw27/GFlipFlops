// THis FSM is to test alu instruction beyond the fibonacci addition sequence

module FSM_test2 (
	input  clk,
	input  rst,
	output reg R0e, R1e, R2e, R3e, R4e, R5e, R6e, R7e, R16e,
	output reg FlagEn, RorI,
	output reg [7:0] opcode,
	output reg [2:0] Rsrc, Rdest
);

   reg [2:0] state;
    
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
	parameter S0 = 3'b000;
	parameter S1 = 3'b001;
	parameter S2 = 3'b010;
	parameter S3 = 3'b011;
	parameter S4 = 3'b100;
	parameter S5 = 3'b101;
	parameter S6 = 3'b110;
	parameter S7 = 3'b111;
 
	always @(posedge clk) begin
	  if (rst) 
			state <= S0;
	  else begin
			case (state)
				 S0: state <= S1;
				 S1: state <= S2;
				 S2: state <= S3;
				 S3: state <= S4;
				 S4: state <= S5;
				 S5: state <= S6;
				 S6: state <= S7;
				 S7: state <= S7;
				 default: state <= S0;
			endcase
	  end
	end

	always @(state) begin
	  {R0e,R1e,R2e,R3e,R4e,R5e,R6e,R7e,R16e} = {9{1'b0}}; 

	  case(state)
			S0: begin
				 {R0e,R1e,R2e,R3e,R4e,R5e,R6e,R7e,R16e} = {9{1'b0}};
				 opcode = 8'h00; 
				 FlagEn = 0;
				 Rsrc   = 3'b000; 
				 Rdest  = 3'b000; 
				 RorI   = 0;
			end
			S1: begin // R2 += 20
				 R2e    = 1;
				 opcode = MOV; 
				 FlagEn = 1;
				 Rsrc   = 3'b000; 
				 Rdest  = 3'b010; 
				 RorI   = 1;
			end
			S2: begin // Move R2 to R1
				 R1e    = 1;
				 opcode = MOV; 
				 FlagEn = 0;
				 Rsrc   = 3'b010; 
				 Rdest  = 3'b001; 
				 RorI   = 0;
			end
			S3: begin // R3 = R1 * R2
				 R3e    = 1;
				 opcode = MUL; 
				 FlagEn = 1;
				 Rsrc   = 3'b010; 
				 Rdest  = 3'b001; 
				 RorI   = 0;
			end
			S4: begin // R4 = R3 | R2
				 R4e    = 1;
				 opcode = OR; 
				 FlagEn = 0;
				 Rsrc   = 3'b010; 
				 Rdest  = 3'b011; 
				 RorI   = 0;
			end
			S5: begin // R5 = R4 & R2
				 R5e    = 1;
				 opcode = AND; 
				 FlagEn = 0;
				 Rsrc   = 3'b100; 
				 Rdest  = 3'b010; 
				 RorI   = 0;
			end
			S6: begin // R6 = R4 - R5
				 R6e    = 1;
				 opcode = SUB; 
				 FlagEn = 1;
				 Rsrc   = 3'b101; 
				 Rdest  = 3'b100; 
				 RorI   = 0;
			end
			S7: begin // R16 = R6 ^ R3
				 R16e   = 1;
				 opcode = XOR; 
				 FlagEn = 0;
				 Rsrc   = 3'b110; 
				 Rdest  = 3'b011; 
				 RorI   = 0;
			end
			default: begin
				{R0e,R1e,R2e,R3e,R4e,R5e,R6e,R7e,R16e} = {9{1'b0}};
				opcode = 8'h00; 
				FlagEn = 0;
				Rsrc   = 3'b000; 
				Rdest  = 3'b000; 
				RorI   = 0;
			end
			
	  endcase
	end

endmodule