module ps2_interface(
	input wire clk, rst,				// FPGA Clock & Reset signals
	input wire ps2_clk, ps2_dat,	// PS/2 Clock & Data inputs
	output reg new_avail,			// Flag for available new data
	output reg [7:0] data,			// Scan code (make & break)
	output reg extra, break,		// Handles additional codes
	output reg parity_err			// Flag for parity error
);

// Synchronize PS/2 clock with FPGA clock thru DFFs
reg [2:0] ps2_clk_sync, ps_2_dat_sync;
always @(posedge clk) begin
	ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
	ps2_dat_sync <= {ps2_dat_sync[1:0], ps2_dat};
end

// Falling edge of clock -> sample data
wire ps2_clk_fall = (ps2_clk_sync[2:1] == 2'b10);

// Capture bits to be interpreted (11 bits total)
reg extra_flag;		// Flag for extra key
reg break_flag;	// Flag to release key
reg [10:0] shift_reg = 0;	// PS/2 data frame
reg [3:0] bit_count = 0;	// Counter for no. of bits

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		bit_count <= 4'b0;
		shift_reg <= 11'b0;
		new_avail <= 1'b0;
		data <= 8'b0;
		extra <= 1'b0;
		extra_flag <= 1'b0;
		break <= 1'b0;
		break_flag <= 1'b0;
		parity_err <= 1'b0;
	end else begin
		
		// Sample data into shift_reg, indexed by bit_count
		if (ps2_clk_fall) begin
			shift_reg[bit_count] = ps2_dat_sync[0];
			bit_count <= bit_count + 1;
		end else begin
			bit_count <= 4'b0;
		end
		
		// Process bits from shift_reg
		if (bit_count == 4'd11) begin
			wire start = shift_reg[0];
			wire data_b = shift_reg[8:1];
			wire parity = shift_reg[9];
			wire stop = shift_reg[10];
			wire parity_check = ((^data_b) ^ parity) == 1'b1;
			
			if ((start == 1'b0) && (stop == 1'b1) && parity_check) begin
				if (data_b == 8'hE0) begin	// Case 0xE0: Extended key prefix
					extra_flag <= 1'b1;
				end else if (data == 8'hF0) begin	// Case 0xF0: Break code prefix
					break_flag <= 1'b1;
				end else begin	// Normal case: Send code to FPGA & clear flags
					data <= data_b;
					new_avail <= 1'b1;
					extra <= extra_flag;
					break <= break_flag;
					extra_flag <= 1'b0;
					break_flag <= 1'b0;
				end
			end else begin
				parity_err <= ~parity_check;
			end
			
			// Reset values for next frame
			bit_count <= 1'b0;
			frame <= 11'b0;
		end
	end
end
endmodule