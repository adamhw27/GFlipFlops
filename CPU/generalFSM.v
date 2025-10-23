module generalFSM (
	input clk,
	input rst,
	input [15:0] inst,
	
	output reg PCen, R/I,
	output reg [15:0] Ren,
	output reg [7:0] opcode,
	output reg [3:0] Rdest,
	output reg [3:0] Rsrc,
	output reg [15:0] imm

);
	
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
				 S2: state <= S2;
				 default: state <= S0;
			endcase
	  end
	end
	
	
	always @(state)  begin
	
		case(state)
		
			S0: begin
			
			end
			
			S1: begin
				
				PCen = 0;
				Rdest = inst[11:8];
				Rsrc = inst[3:0];
				if (inst[15:12] == 0)
					opcode = {inst[15:12], inst[7:4]};
					imm = 0;
				else // not sure if this handles unsigned operations correctly
					imm = {8inst[7],inst[7:0]}
					
			end
			
			end
			
			S2: begin 
			
			end
	
	end
	
endmodule