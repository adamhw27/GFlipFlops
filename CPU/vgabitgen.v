module VGABitGen(
	input bright,
	input [7:0] pixelData,
	input [9:0] hCount, vCount,
	output reg [7:0] rgb
);
parameter WHITE = 8'b111_111_11;
parameter RED = 8'b111_000_00;
parameter BLACK = 8'b000_000_00;


always @(*)
begin
	if (~bright)
		rgb = BLACK;
	else
		rgb = WHITE;
	end


endmodule