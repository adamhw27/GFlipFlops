`timescale 1ns/1ps

module generalFSM_tb ();

reg clk;
reg rst;
reg cin;

wire [27:0] segOut;
wire [7:0] r, g, b;
wire vga_clk, vga_blank_n, vga_vs, vga_hs;

wire AUD_ADCLRCK;
reg  AUD_ADCDAT;
wire AUD_DACLRCK;
wire AUD_DACDAT;
wire AUD_XCK;
wire AUD_BCLK;
wire AUD_I2C_SCLK;
wire AUD_I2C_SDAT;

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
	 .AUD_ADCLRCK(AUD_ADCLRCK),
	 .AUD_ADCDAT(AUD_ADCDAT),
	 .AUD_DACLRCK(AUD_DACLRCK),
	 .AUD_DACDAT(AUD_DACDAT),
	 .AUD_XCK(AUD_XCK),
	 .AUD_BCLK(AUD_BCLK),
	 .AUD_I2C_SCLK(AUD_I2C_SCLK),
	 .AUD_I2C_SDAT(AUD_I2C_SDAT),
    .segOut(segOut)
);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        cin = 0;
        rst = 0;          // Apply reset
        #15;
        rst = 1;          // Release reset

        // Run simulation for a while
        #10000;
		  
		  

        $display(segOut);
        $stop;
    end

endmodule
