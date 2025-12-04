module KeyReg(
input clk, rst, rst_handle,	// rst_handle - Reset the most significant bit, key was already handled
input [3:0] key_enc,				// PS/2 encoding
output reg [3:0] key_info		// For software purposes: MSB remains high -> flag that it needs to be handled
);
	
	reg [3:0] prev_press;		// Last key press
	reg handle_press;				// Sets flag (MSB of key_info): Signifies needs to be handled
	wire newpress_en;				// Enable bit: New key has been received -> Need to handle it
	
	assign newpress_en = (prev_press[2:0] == key_enc[2:0]) && (prev_press[3] == 1'b1) && (key_enc[3] == 1'b0);
	
	always @(posedge clk, negedge rst, posedge newpress_en, posedge rst_handle) begin
		if (~rst) begin
			key_info <= 4'd0;
		end	
		else if(newpress_en) begin
			handle_press = 1'b1;
			key_info <= {handle_press, key_enc[2:0]};
		end
		else if (rst_handle)begin
			handle_press = 1'b0;
			key_info <= {handle_press, key_enc[2:0]};
		end
		prev_press = key_enc;
	end


endmodule
