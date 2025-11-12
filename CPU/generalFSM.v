module generalFSM (
	input clk,
	input rst,
	input [15:0] inst,
	
	output reg [15:0] Ren,
	
	output reg PCen, RorI, LScntl, we_a, IRenable, Alu_Mux_cntl,
	
	output reg [7:0] opcode,
	output reg [3:0] Rsrc,
	output reg [3:0] Rdest,
	output reg [15:0] imm

);


	// check opcodes for LOAD and STORE are okay
	// do these need to be reg? do we even need these if we have the IR reg?
	reg [3:0] savedRdest;
	reg savedAlu_Mux_ctrl;
	reg [3:0] savedRsrc;
	
	reg [3:0] state;

	// states
	parameter S0_Fetch = 4'b0000;
	parameter S1_Decode = 4'b0001;
	parameter S2_Rtype = 4'b0010;
	parameter S3_Store = 4'b0011;
	parameter S4_Load = 4'b0100;
	parameter S5_dataToReg = 4'b0101;

	always @(posedge clk) begin
	  if (~rst) state <= S0_Fetch;
	  else begin
			case (state)
				 S0_Fetch: state <= S1_Decode;				 
				 S1_Decode: begin
				   
					if (opcode == 8'b0100_0100) begin
						state <= S3_Store;
					end
					else if (opcode == 8'b0100_0000) begin
						state <= S4_Load;
					end
					else begin
						state <= S2_Rtype;
					end
					
				 end
				 
				 S2_Rtype: state <= S0_Fetch;
				 S3_Store: state <= S0_Fetch;
				 S4_Load: state <= S5_dataToReg;
				 S5_dataToReg: state <= S0_Fetch;
				 
				 default: state <= S0_Fetch;
			endcase
	  end
	end
	
	
	always @(state)  begin
	
	
		case(state)
		
		
		
			S0_Fetch: begin
				PCen = 0;
				LScntl = 0;
				we_a = 0;
				IRenable = 1;
				Alu_Mux_cntl = 0;
				Rdest = 4'bxxxx;
				Rsrc = 4'bxxxx;
				opcode = 8'bxxxxxxxx;
				imm = 16'bx;
				RorI = 1'bx;
				Ren = 16'bx;
			
			end
			
			S1_Decode: begin
				
				PCen = 0;
				LScntl = 0;
				we_a = 0;
				IRenable = 0;
				Alu_Mux_cntl = 0;
				Rdest = inst[11:8];
				Rsrc = inst[3:0];
				Ren = 16'b0;
				if (inst[15:12] == 0) begin // true if not i-type instruction
					RorI = 0; // indicates to choose Rsrc
					
					
					opcode = {inst[15:12], inst[7:4]}; // from lecture slides:
					// if opcode = R-type or I-type, then Next State = S2 
					// unsure how to implement
					imm = 0;
				end else if (inst[15:12] == 4'b0100) begin
					opcode = {inst[15:12], inst[7:4]};
					RorI = 0;
					imm = 0;
		
				end else begin// not sure if this handles unsigned operations correctly
					RorI = 1; // indicates to choose immediate
					opcode = inst[15:12];
					imm = {8*inst[7],inst[7:0]};	 // sign extend immediate
				end
				
				savedRdest = Rdest;
				savedRsrc = Rsrc;
				savedAlu_Mux_ctrl = Alu_Mux_cntl;
				
			end
			
			S2_Rtype: begin 
				
				
				
				PCen = 1;
				LScntl = 0;
				we_a = 0;
				IRenable = 0;
				Alu_Mux_cntl = 0;
				Ren= 16'b1 << Rdest; // wb to rdest register
				
			end
			
			S3_Store: begin

				IRenable = 0;
				Alu_Mux_cntl = 0;
				RorI = 0;
				
				
				Rdest = savedRsrc;
				Rsrc = savedRdest;
			
				PCen = 1;
				LScntl = 1;
				we_a = 1;
				
				IRenable = 0;
				Alu_Mux_cntl = 0;
				Ren = 16'bx;
				
			end
			
			S4_Load: begin
				
				Rdest = savedRdest;
				Alu_Mux_cntl = savedAlu_Mux_ctrl;
				Rsrc = savedRsrc;
				
				PCen = 0;
				LScntl = 1;
				we_a = 0;
				IRenable = 0;
				Alu_Mux_cntl = 0;
				Ren = 16'bx;
			
			end
			
			S5_dataToReg: begin
				
				Rdest = savedRdest; // to fix, get RSRC to hok up with memory
				Alu_Mux_cntl = savedAlu_Mux_ctrl;
				Rsrc = savedRsrc;
				
				LScntl = 1;
				we_a = 0;
				IRenable = 0;
				Alu_Mux_cntl = 1;
				Ren= 16'b1 << Rsrc; // wb to rdest register
				
				PCen = 1;
				
			
			end
			
			
		endcase
	end
	
endmodule