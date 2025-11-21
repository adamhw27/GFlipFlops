module clk_div(
	input wire clk, rst,
	output wire oclk
);
	
	
always @(posedge clk) begin

	if (~rst) begin
		oclk <= 1'b0;
	end
	else begin
		oclk <= ~oclk;
	end
end
	
endmodule