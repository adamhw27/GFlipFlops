module bitStreamControl (
    input  clk,
    input [15:0] enable16,
    output reg [3:0] enable_mask,
    output reg [15:0] address,
	 output reg [3:0] counter

);

    initial counter = 0;
	 
	 reg [25:0] clkdiv  = 0; 
    reg enableIncrement = 0;

    parameter BEGINENABLE = 0;
	 
	 always @(posedge clk) begin
	    if (clkdiv == 49_999_999) begin
			clkdiv  <= 0;
			enableIncrement <= 1;
	    end 
		 
		 else begin
			clkdiv  <= clkdiv + 1;
			enableIncrement <= 0;
	    end
    end

    always @(posedge clk) begin
		  if (enableIncrement) begin
			  address <= BEGINENABLE + counter;

			  enable_mask <= enable16[3:0];
		 
			  if (counter == 15)
					counter <= 0;
			  else
					counter <= counter + 1;
		  end

    end

endmodule
