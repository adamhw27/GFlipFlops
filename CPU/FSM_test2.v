module FSM_test2 (clk, rst, regEnable, opcode, Aenable, Benable);
	input clk, rst;
	output [15:0] regEnable;
	output [7:0] opcode;
	output Aenable, Benable;
	
	reg [3:1] state;
	
	parameter S0 = 3'b000;
	parameter S1 = 3'b001;
	parameter S2 = 3'b010;
	parameter S3 = 3'b011;
	parameter S4 = 3'b100;
	parameter S5 = 3'b101;
	parameter S6 = 3'b110;
	parameter S7 = 3'b111;
	
	always@(posedge clk)
	
		if (reset), y <= S0;
		else
		case (state)
			S0: y<=S1;
			S1: y<=S2;
			S2: y<=S3;
			S3: y<=S4;
			S4: y<=S5;
			S5: y<=S6;
			S6: y<=S7;
			S7: y<=S7;
		endcase
	
	end
	
	always@(state)
		
		case(state)
			S0: 
				begin
				
				end
			S1: 
				begin
				
				end
			S2: 
				begin
				
				end
			S3: 
				begin
				
				end
			S4: 
				begin
				
				end
			S5: 
				begin
				
				end
			S6: 
				begin
				
				end
			S7: 
				begin
				
				end
		
	end

end module