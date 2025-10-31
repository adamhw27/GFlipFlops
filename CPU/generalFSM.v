module generalFSM (
	input clk,
	input rst,
	input [15:0] inst,
	
	output reg [15:0] Ren,
	
	output reg PCen, RorI,
	
	output reg [7:0] opcode,
	output reg [3:0] Rsrc,
	output reg [3:0] Rdest,
	output reg [15:0] imm

);
	
	reg [3:0] state;

	// states
	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;

	always @(posedge clk) begin
	  if (~rst) state <= S0;
	  else begin
			case (state)
				 S0: state <= S1;
				 S1: state <= S2;
				 S2: state <= S0;
				 default: state <= S0;
			endcase
	  end
	end
	
	
	always @(state)  begin
	
		case(state)
		
		
		
			S0: begin
				PCen = 0;
				Rdest = 4'bxxxx;
				Rsrc = 4'bxxxx;
				opcode = 8'bxxxxxxxx;
				imm = 16'bx;
				RorI = 1'bx;
				Ren = 16'bx;
			
			end
			
			S1: begin
				
				PCen = 0;
				Rdest = inst[11:8];
				Rsrc = inst[3:0];
				Ren = 16'b0;
				if (inst[15:12] == 0) begin // true if not i-type instruction
					RorI = 0; // indicates to choose Rsrc
					
					opcode = {inst[15:12], inst[7:4]}; // from lecture slides:
					// if opcode = R-type or I-type, then Next State = S2 
					// unsure how to implement
					imm = 0;
				end else begin// not sure if this handles unsigned operations correctly
					RorI = 1; // indicates to choose immediate
					opcode = inst[15:12];
					imm = {8*inst[7],inst[7:0]};	 // sign extend immediate
				end
			end
			
			S2: begin 
				PCen = 1;
				Rdest = inst[11:8];
				Rsrc = inst[3:0];
				Ren= 16'b1 << Rdest; // wb to rdest register
				
				if (inst[15:12] == 0) begin// true if not i-type instruction
					RorI = 0; // indicates to choose Rsrc
					
					opcode = {inst[15:12], inst[7:4]}; // from lecture slides:
					// if opcode = R-type or I-type, then Next State = S2 
					// unsure how to implement
					imm = 0;
				end else begin// not sure if this handles unsigned operations correctly
					RorI = 1; // indicates to choose immediate
					opcode = inst[15:12];
					imm = {8*inst[7],inst[7:0]};	 // sign extend immediate
				end
				
				
			end
		endcase
	end
	
endmodule