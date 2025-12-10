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
	
	assign cursorLoc =  sys_data[15:0]; // cursor value updates the beat array at the value passed in, which is 0-64, and updates corresponding beat
	
	// beat array would have taken in 64 bit system data info of data from memory the same place audio looks at to determine which 
	// whether the glyphs need to reflect the beat is on or off (0 indicates beat is off, 1 indicates on)
	assign beatArray = sys_data[63:32];
	assign currentBeat = sys_data[31:16]; // indicator above beat array displaying which beat we are on
	
	// modules for vga
	// control signal generation, bit generation, and glyph generation
	VGAcontroller vga_control(.clk(clk), .rst(rst), .hs(vga_hs), .vs(vga_vs), .bright(vga_blank_n), .new_clk(vga_clk), .hCount(hCount), .vCount(vCount));
	VGABitGen vga_bitgen(.bright(vga_blank_n), .hCount(hCount), .vCount(vCount), .pixColor(pixColor), .rgb({r,g,b}));
	GlyphGen ggen(.clk(clk), .rst(rst), .hCount(hCount), .vCount(vCount), .tempo(tempo), .cursorLoc(cursorLoc), .currentBeat(currentBeat), .beatArray(beatArray), .pixColor(pixColor));
	
endmodule