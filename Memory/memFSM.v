module memFSM 
#(parameter DATA_WIDTH=16, parameter ADDR_WIDTH=10)
(
	input rst, clk,
	output reg [(DATA_WIDTH-1):0] data_a, data_b,
	output reg [(ADDR_WIDTH-1):0] addr_a, addr_b,
	output reg we_a, we_b
);

	reg [3:0] state;
	
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
	
 
	always @(posedge clk) begin
	  if (~rst) 
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
				 S7: state <= S8;
				 S8: state <= S8;
				 default: state <= S0;
			endcase
	  end
	end
	
	always @(state) begin 

	  case(state)
			S0: begin
				 data_a = 0;
				 data_b = 0;
				 addr_a = 0;
				 addr_b = 1;
				 we_a = 0;
				 we_b = 0;
			end
			S1: begin 
				data_a = 2;
				data_b = 0;
				addr_a = 0;
				addr_b = 1;
				we_a = 1;
				we_b = 0;
			end
			S2: begin // Aout should be 2, Bout should be 3
				data_a = 0;
				data_b = 3;
				addr_a = 1;
				addr_b = 2;
				we_a = 0;
				we_b = 1; 
			end
			S3: begin
				data_a = 80;
				data_b = 0;
				addr_a = 510;
				addr_b = 2;
				we_a = 1;
				we_b = 0; 
			end
			S4: begin
				data_a = 99;
				data_b = 0;
				addr_a = 513;
				addr_b = 510;
				we_a = 1;
				we_b = 0; 
			end
			S5: begin
				data_a = 0;
				data_b = 100;
				addr_a = 513;
				addr_b = 512;
				we_a = 0;
				we_b = 1;
			end
			S6: begin
				data_a = 0;
				data_b = 199;
				addr_a = 512;
				addr_b = 1022;
				we_a = 0;
				we_b = 1;
			end
			S7: begin
				data_a = 0;
				data_b = 200;
				addr_a = 1022;
				addr_b = 1023;
				we_a = 0;
				we_b = 1;
			end
			S8: begin
				data_a = 0;
				data_b = 0;
				addr_a = 1022;
				addr_b = 1023;
				we_a = 0;
				we_b = 0;
			end
			default: begin
				data_a = 0;
				data_b = 0;
				addr_a = 0;
				addr_b = 0;
				we_a = 0;
				we_b = 0;
			end
			
	  endcase
	end


endmodule