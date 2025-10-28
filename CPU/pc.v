module pc (
	input wire PCen,
	input wire clk,
	input wire rst,
	input wire [9:0] initialPCvalue,
	output reg [9:0] outPC
);

	always @(posedge clk or posedge rst) begin
	  if (rst)
			outPC <= initialPCvalue;
	  else if (PCen)
			outPC <= outPC + 1;
	end

endmodule