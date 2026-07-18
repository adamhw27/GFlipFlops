`timescale 1ns/1ps

module cpu_debug_tb;

reg clk;
reg rst;
reg cin;

wire [27:0] segOut;
wire [7:0] r, g, b;
wire vga_clk, vga_blank_n, vga_vs, vga_hs;

// Fake PS2
reg ps2_clk = 0;
reg ps2_dat = 0;

cpu dut (
   .cin(cin),
   .clk(clk),
   .rst(rst),
   .ps2_clk(ps2_clk),
   .ps2_dat(ps2_dat),
   .vga_clk(vga_clk),
   .vga_blank_n(vga_blank_n),
   .vga_vs(vga_vs),
   .vga_hs(vga_hs),
   .r(r), .g(g), .b(b),
   .segOut(segOut)
);

//
// Clock Generation
//

// system clock (50 MHz sim equivalent)
always #10 clk = ~clk;


//
// Sim timeline
//

initial begin
   // Initialize signals
   clk = 0;
   rst = 1;
   cin = 0;

   // Apply reset for 100 ns
   #50;
   rst = 0;
   #50;
	 rst = 1;

   // Run simulation for N instructions
   repeat(20) begin
       @(negedge clk);
   end

   $stop;
end

endmodule
