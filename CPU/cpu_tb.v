`timescale 1ns/1ps
module cpu_tb;

    // ---------------------------
    // Clock + Reset
    // ---------------------------
    reg clk;
    reg rst;

    // ---------------------------
    // Audio / I2C / Codec Signals
    // ---------------------------
    wire AUD_ADCLRCK;
    reg  AUD_ADCDAT;
    wire AUD_DACLRCK;
    wire AUD_DACDAT;
    wire AUD_XCK;
    wire AUD_BCLK;
    wire AUD_I2C_SCLK;
    wire AUD_I2C_SDAT;

    // ---------------------------
    // Instantiate the CPU
    // ---------------------------
    cpu DUT (
        .cin(1'b0),
        .clk(clk),
        .rst(rst),

        .AUD_ADCLRCK(AUD_ADCLRCK),
        .AUD_ADCDAT(AUD_ADCDAT),
        .AUD_DACLRCK(AUD_DACLRCK),
        .AUD_DACDAT(AUD_DACDAT),
        .AUD_XCK(AUD_XCK),
        .AUD_BCLK(AUD_BCLK),
        .AUD_I2C_SCLK(AUD_I2C_SCLK),
        .AUD_I2C_SDAT(AUD_I2C_SDAT)
    );

    // ---------------------------
    // Clock generation
    // ---------------------------
    initial clk = 0;
    always #5 clk = ~clk;    // 100 MHz simulation clock

    // ---------------------------
    // Reset pulse
    // ---------------------------
    initial begin
        rst = 1;
        #50;
        rst = 0;
        #50;
        rst = 1;
    end

    // ---------------------------
    // Audio Codec Stub Generator
    // (generates dummy clocks so I2C + audio blocks don't stay X)
    // ---------------------------

    // Fake LR clock
    reg aud_lrck = 0;
    assign AUD_ADCLRCK = aud_lrck;
    assign AUD_DACLRCK = aud_lrck;

    // Fake bitclock
    reg aud_bclk = 0;
    assign AUD_BCLK = aud_bclk;

    always #20 aud_lrck = ~aud_lrck;   // slow frame clock
    always #2  aud_bclk = ~aud_bclk;   // fast serial clock

    // Fake audio input data
    initial AUD_ADCDAT = 0;
    always @(posedge aud_bclk)
        AUD_ADCDAT <= ~AUD_ADCDAT;

    // ---------------------------
    // Allow simulation to run
    // ---------------------------
    initial begin
        $display("Starting CPU test...");
        #50000;        // run long enough to watch PC increment
        $display("Simulation finished.");
        $stop;
    end

endmodule
