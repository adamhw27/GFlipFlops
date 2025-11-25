module counter_19bit(
	input wire clk, rst,
	output reg [18:0] val
);

always @(posedge clk, posedge rst)
begin
	if (rst) 
	begin
		val <= 19'b0;
	end
	else begin
		val <= val + 1'b1;
	end
end
endmodule