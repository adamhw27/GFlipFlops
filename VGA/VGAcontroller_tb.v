`timescale 1ns/1ps
module VGAcontroller_tb;

reg clk;
reg rst;
wire [5:0] rgb;
wire hSync, vSync, bright, vga_clk;

HardCodedVga vga(.clk(clk), .rst(rst), .vga_clk(vga_clk), .vga_blank_n(bright), .vga_hs(hSync), .vga_vs(vSync),  .rgb(rgb));

	 
 // Test stimulus
 initial begin
	  clk = 0;
	  rst= 1; #2;
	  rst = 0; #10;
	  rst = 1; #10;
 end
 
 always #5 clk = ~clk;

endmodule