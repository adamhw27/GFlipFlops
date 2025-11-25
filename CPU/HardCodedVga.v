module HardCodedVga(
	input clk, rst,
	output vga_clk, vga_blank_n, vga_vs, vga_hs,
	output [23:0] rgb
);
	
	wire[9:0] hCount, vCount;
	
	VGAcontroller vga_control(.clk(clk), .rst(rst), .hs(vga_hs), .vs(vga_vs), .bright(vga_blank_n), .hCount(hCount), .vCount(vCount));
	VGABitGen vga_bitgen(.bright(vga_blank_n), .hCount(hCount), .vCount(vCount), .rgb(rgb));
	
endmodule