module VGABitGen(
	input bright,
	input [7:0] pixelData,
	input [9:0] hCount, vCount,
	input [2:0] pixColor,
	output wire [23:0] rgb
);
reg r, g, b;

assign rgb = {{pixColor[0], 7'd0}, {pixColor[1], 7'd0}, {pixColor[2], 7'd0}};

endmodule