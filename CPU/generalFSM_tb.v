`timescale 1ns/1ps

module generalFSM_tb ();

	// Inputs
    reg cin;
    reg clk;
    reg rst;

    // Outputs
    wire [27:0] segOut;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .rst(rst),
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
