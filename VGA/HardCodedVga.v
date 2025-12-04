module HardCodedVga(
	input clk, rst, 
	input [95:0] sys_data,
	output vga_clk, vga_blank_n, vga_vs, vga_hs,
	output [7:0] r, g, b
);
	
	wire[9:0] hCount, vCount;
	wire[15:0] tempo, cursorLoc, currentBeat;
	wire[63:0] beatArray;
	wire[2:0] pixColor;
	
	assign cursorLoc =  sys_data[15:0];
	
	assign beatArray = {8'b10100001, 8'b11111111, 8'b11111111, 8'b01001010, 8'b10100001, 8'b11111111, 8'b00000000, 8'b01001010};
	assign currentBeat = 4'd2;
	
	
	
	VGAcontroller vga_control(.clk(clk), .rst(rst), .hs(vga_hs), .vs(vga_vs), .bright(vga_blank_n), .new_clk(vga_clk), .hCount(hCount), .vCount(vCount));
	VGABitGen vga_bitgen(.bright(vga_blank_n), .hCount(hCount), .vCount(vCount), .pixColor(pixColor), .rgb({r,g,b}));
	GlyphGen ggen(.clk(clk), .rst(rst), .hCount(hCount), .vCount(vCount), .tempo(tempo), .cursorLoc(cursorLoc), .currentBeat(currentBeat), .beatArray(beatArray), .pixColor(pixColor));
	
endmodule