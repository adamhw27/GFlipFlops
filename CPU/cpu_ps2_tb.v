`timescale 1ns/1ps

module cpu_ps2_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] key_enc;

    // Instantiate your CPU (update ports if needed)
    cpu UUT (
        .cin(1'b0),
        .clk(clk),
        .rst(rst),
        .key_enc(key_enc),

        .vga_clk(),
        .vga_blank_n(),
        .vga_vs(),
        .vga_hs(),
        .r(),
        .g(),
        .b(),
		  .AUD_ADCLRCK(),
			.AUD_ADCDAT(),
			.AUD_DACLRCK(),
			.AUD_DACDAT(),
			.AUD_XCK(),
			.AUD_BCLK(),
			.AUD_I2C_SCLK(),
			.AUD_I2C_SDAT(),
        .segOut()
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 0;          // Apply reset
        #15;
        rst = 1;          // Release reset

        // Run simulation for a while
        #1000
        key_enc = 4'b0000;   // starting value

        #20;                 // wait 20 time units
        key_enc = 4'b1011;   // set to 1011

        #100;                 // wait another 20 time units
        key_enc = 4'b0011;   // set to 0011
		  
		  #10000

        $stop;
    end

endmodule