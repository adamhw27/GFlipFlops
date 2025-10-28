module pc (
input PCen,
input clk, rst,
input [9:0] currentPC,

output reg [9:0] outPC
);


	always @(posedge clk) begin
		if (PCen)
			outPC = currentPC + 1;
			
	end

endmodule