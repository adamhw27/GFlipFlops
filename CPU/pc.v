module pc (
	input wire PCen,
	input wire clk,
	input wire rst,
	output reg [15:0] outPC
);

	always @(posedge clk or negedge rst) begin
	  if (~rst)
			outPC <= 16'd0;
	  else if (PCen)
			outPC <= outPC + 1;
	end

endmodule