module FlagReg(
	input clk, rst,
	input [4:0] iFlags,
	input flagEn,
	output reg [4:0] oFlags
	);
	always @(posedge clk or negedge rst)
	begin
		if (~rst)
			oFlags <= 5'd0;
	  else if (flagEn)
			oFlags <= iFlags;
	end
endmodule