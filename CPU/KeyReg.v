module KeyReg(
input clk, rst, rst_handle,
input [3:0] key_enc,
output reg [4:0] key_info
);
	
	reg [3:0] prev_press;
	reg handle_press;
	wire newpress_en;
	
	assign newpress_en = (prev_press[2:0] == key_enc[2:0]) && (prev_press[3] == 1'b1) && (key_enc[3] == 1'b0);
	
	always @(posedge clk, negedge rst, posedge newpress_en, posedge rst_handle) begin
	
		if (~rst) begin
			key_info <= 11'd0;
		end
		else if(newpress_en) begin
			handle_press = 1'b1;
			key_info <= {handle_press, key_enc};
		end
		else if (rst_handle)begin
			handle_press = 1'b0;
			key_info <= {handle_press, key_enc[2:0]};
		end	
		
		prev_press = key_enc;
	end


endmodule
