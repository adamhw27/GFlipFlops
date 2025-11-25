module VGABitGen(
	input bright,
	input [7:0] pixelData,
	input [9:0] hCount, vCount,
	output wire [23:0] rgb
);
reg [1:0] r, g, b;
assign rgb = {r, g, b};

always @(*)
begin
	if (~bright) begin
		r <= 8'd0;
		g <= 8'd0;
		b <= 8'd0;
	end
	else begin
		r <= {2'd3, 6'b0};
		g <= {2'd3, 6'b0};
		b <= {2'd3, 6'b0};
	end
end

endmodule