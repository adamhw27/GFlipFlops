module ps2_top_test (
	input wire clk, rst,				// FPGA Clock & Reset signals
	input wire ps2_clk, ps2_dat,	// PS/2 Clock & Data inputs
	output reg [4:0] led				// Output LED (led[4] = Break code was pushed)
);

wire [3:0] ps2_out;

ps2_interface_mod ps2_mod(
	.clk(clk), .rst(rst),
	.ps2_clk(ps2_clk), .ps2_dat(ps2_dat),
	.key_enc(ps2_out)
);

always @(posedge clk or negedge rst) begin
	if (!rst)
		led <= 4'b0;
	else
		led <= {~ps2_out[3], ps2_out};
end

endmodule