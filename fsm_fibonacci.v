module fsm_fibonacci(
	input wire clk, rs,
	output reg [15:0] enableRegs, resRegs,
	output reg [7:0] opCode,
	output reg [4:0] enableFlags,
	output reg [3:0] muxRsrc, muxRdest,
	output reg muxRI
	);
	
	// Notes:
	// muxRsrc & muxRdest - Determines which register to pull from
	// muxRI - Determines whether to pick from Rdest (0) or Immediate (1)
	
	// TODO: Add enable signals for flags
	
	// FSM for CPU control
	reg [4:0] state;
	always @(posedge clk or negedge rs) begin
		if (~rs) state <= 4'b0;
		else if (state != 4'b1110) count <= count + 4'b1;
	end
	
	always @(*) begin
		case (state)
			// S1: R2 = R1 + R0; initialize R0 & R1
			4'b0001 : begin
				enableRegs[2:0] = 3'b100;
				muxRsrc = 4'b0001;
				muxRdest = 4'b0;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S2: R3 = R2 + R1
			4'b0010 : begin
				enableRegs[3:1] = 3'b100;
				muxRsrc = 4'b0010;
				muxRdest = 4'b0001;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S3: R4 = R3 + R2
			4'b0011 : begin
				enableRegs[4:2] = 3'b100;
				muxRsrc = 4'b0011;
				muxRdest = 4'b0010;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S4: R5 = R4 + R3
			4'b0100 : begin
				enableRegs[5:3] = 3'b100;
				muxRsrc = 4'b0100;
				muxRdest = 4'b0011;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S5: R6 = R5 + R4
			4'b0101 : begin
				enableRegs[6:4] = 3'b100;
				muxRsrc = 4'b0101;
				muxRdest = 4'b0100;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S6: R7 = R6 + R5
			4'b0110 : begin
				enableRegs[7:5] = 3'b100;
				muxRsrc = 4'b0110;
				muxRdest = 4'b0101;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S7: R8 = R7 + R6
			4'b0111 : begin
				enableRegs[8:6] = 3'b100;
				muxRsrc = 4'b0111;
				muxRdest = 4'b0110;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S8: R9 = R8 + R7
			4'b1000 : begin
				enableRegs[9:7] = 3'b100;
				muxRsrc = 4'b1000;
				muxRdest = 4'b0111;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S9: R10 = R9 + R8
			4'b1001 : begin
				enableRegs[10:8] = 3'b100;
				muxRsrc = 4'b1001;
				muxRdest = 4'b1000;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S10: R11 = R10 + R9
			4'b1010 : begin
				enableRegs[11:9] = 3'b100;
				muxRsrc = 4'b1010;
				muxRdest = 4'b1001;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S11: R12 = R11 + R10
			4'b1011 : begin
				enableRegs[12:10] = 3'b100;
				muxRsrc = 4'b1011;
				muxRdest = 4'b1010;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S12: R13 = R12 + R11
			4'b1100 : begin
				enableRegs[13:11] = 3'b100;
				muxRsrc = 4'b1100;
				muxRdest = 4'b1011;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S13: R14 = R13 + R12
			4'b1101 : begin
				enableRegs[14:12] = 3'b100;
				muxRsrc = 4'b1101;
				muxRdest = 4'b1100;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S14: R15 = R14 + R13
			4'b1110 : begin
				enableRegs[15:13] = 3'b100;
				muxRsrc = 4'b1110;
				muxRdest = 4'b1101;
				muxRI = 1'b0;
				opCode = 8'b0000_0101;
			end
			
			// S0/Default: Reset all registers
			default : begin
				enableRegs = 16'b0;
				resRegs = 16'b1111111111111111;
				muxRsrc = 4'0;
				muxRdest = 4'b0;
				muxRI = 1'b0;
				opCode = 8'b0000_0000;
			end
		endcase
	end
	
endmodule