module ps2_interface_mod(
	input wire clk, rst,				// FPGA Clock & Reset signals
	input wire ps2_clk, ps2_dat,	// PS/2 Clock & Data inputs
	output reg [3:0] key_enc		// Encoded version of the make/break codes
);

// Synchronize PS/2 clock with FPGA clock thru DFFs
reg [2:0] ps2_clk_sync, ps2_dat_sync;
always @(posedge clk) begin
	ps2_clk_sync <= {ps2_clk_sync[1:0], ps2_clk};
	ps2_dat_sync <= {ps2_dat_sync[1:0], ps2_dat};
end

// Falling edge of clock -> sample data
wire ps2_clk_fall = (ps2_clk_sync[2:1] == 2'b10);

// Flags to facilitate proper checking of make/break codes
reg break_flag;		// Break code (0xF0)
reg break_pending;	// Break pending flag
reg extend_flag;		// Extended code (0xE0)
reg parity_err;		// Flag for parity error
reg new_avail;			// Flag for available new data

// Evaluation of PS/2 data bits
wire start;
wire [7:0] data_b;
wire parity;
wire stop;
wire parity_check;

assign start = shift_reg[0];
assign data_b = shift_reg[8:1];
assign parity = shift_reg[9];
assign stop = shift_reg[10];
assign parity_check = ((^data_b) ^ parity) == 1'b1;

// Capture bits to be interpreted (11 bits total)
reg [15:0] key_data;		// Main data bits, including E0 if applicable
reg [10:0] shift_reg;	// PS/2 data frame
reg [3:0] bit_count;		// Counter for no. of bits

// Decoding bits from PS/2 keyboard
always @(posedge clk or negedge rst) begin
	// Case for reset signal
	if (!rst) begin		
		// Flag reset
		extend_flag <= 1'b0;
		break_flag <= 1'b0;
		break_pending <= 1'b0;
		parity_err <= 1'b0;
		new_avail <= 1'b0;
		
		// Capture reset
		key_data <= 16'b0;
		shift_reg <= 11'b0;
		bit_count <= 4'b0;
	end else begin
		new_avail <= 1'b0;
		
		// Sample data into shift_reg, indexed by bit_count
		if (ps2_clk_fall) begin
			shift_reg[bit_count] <= ps2_dat_sync[0];
			bit_count <= bit_count + 1;
		end
		
		// Process bits from shift_reg
		if (bit_count == 4'd11) begin
			if ((start == 1'b0) && (stop == 1'b1) && parity_check) begin			
				if (data_b == 8'hE0) begin	// Case 0xE0: Extended key prefix detected
					extend_flag <= 1'b1;
				end else if (data_b == 8'hF0) begin	// Case 0xF0: Break code prefix detected
					break_flag <= 1'b1;
				end else begin	// Normal case: Send code to FPGA & clear flags
					key_data <= extend_flag ? {8'hE0, data_b} : {8'h00, data_b};
					new_avail <= 1'b1;
					break_pending <= break_flag;
					extend_flag <= 1'b0;
					break_flag <= 1'b0;
				end
			end else begin
				parity_err <= ~parity_check;
			end
			
			// Reset values for next frame
			bit_count <= 4'b0;
			shift_reg <= 11'b0;
		end
	end
end

// Encoding targeted PS/2 bits for output
// - key_enc[3]: 1 if pressing key, 0 if break code detected
// - key_enc[2:0]: 3-bit encoding of necessary key
always @(posedge clk or negedge rst) begin
	if (!rst) begin
		key_enc <= 4'b0;
	end else if (new_avail) begin
		key_enc[3] <= ~break_pending;
		case(key_data)
			16'h001D : key_enc[2:0] <= 3'b000;	// W -> X000
			16'h001C : key_enc[2:0] <= 3'b001;	// A -> X001
			16'h001B : key_enc[2:0] <= 3'b010;	// S -> X010
			16'h0023 : key_enc[2:0] <= 3'b011;	// D -> X011
			16'h005A : key_enc[2:0] <= 3'b100;	// Enter -> X100
			16'h0029 : key_enc[2:0] <= 3'b101;	// Space -> X101
			16'hE075 : key_enc[2:0] <= 3'b110;	// Up arrow -> X110
			16'hE072 : key_enc[2:0] <= 3'b111;	// Down arrow -> X111
			default	: key_enc		<= 4'b0;
		endcase
	end
end
endmodule