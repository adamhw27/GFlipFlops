`timescale 1ns/1ps	// 1 nanosecond steps, 1 picosecond precision

module ps2_interface_mod_tb();

// 1. Declaration of FPGA clock signal (50 MHz)
reg clk;
initial clk = 0;
always #10 clk = ~clk;

// 2. Declaration of PS/2 clock signal (10 kHz)
reg ps2_clk = 0;
initial ps2_clk = 0;

// 3. Declare & initialize signals
reg rst = 0;
reg ps2_dat = 1;
wire [3:0] key_enc;

// 4. Instantiate PS/2 interface
ps2_interface_mod ps2_mod(
	.clk(clk), .rst(rst),
	.ps2_clk(ps2_clk), .ps2_dat(ps2_dat),
	.key_enc(key_enc),
);

// 5. Driver task to simulate sending one PS/2 data byte to FPGA
// Generated via ChatGPT
task pulse_clk();
	begin
		#20000 ps2_clk = ~ps2_clk;
	end
endtask

task send_ps2_byte(input [7:0] data);
	integer i;
	reg parity;
	begin
		// Generate parity check bit
		parity = ~(^data);
		
		// Start bit (ps2_dat[0])
		ps2_dat = 0;
		pulse_clk();
		
		// Generate 8 data bits, LSB first
		for (i = 0; i < 8; i = i + 1) begin
			ps2_dat = data[i];
			pulse_clk();
		end
		
		// Parity bit
		ps2_dat = parity;
		pulse_clk();
		
		// Stop bit
		ps2_dat = 1;
		pulse_clk();
	end
endtask

// 6. Test key encoding works with the correct encoding
task send_key(input [15:0] keycode);
	begin
		// Sending make codes
		if (keycode[15:8] == 8'hE0) begin // Extended case
			send_ps2_byte(8'hE0);
		end
		send_ps2_byte(keycode[7:0]);
		
		// Sending break codes
		if (keycode[15:8] == 8'hE0) begin // Extended case
			send_ps2_byte(8'hE0);
		end
		send_ps2_byte(8'hF0);
		send_ps2_byte(keycode[7:0]);
	end
endtask

// 7. Initialize testing block
initial begin
	#100000 rst = 1;
	
	send_key(16'h001D); // W
	send_key(16'h001C); // A
	send_key(16'h001B); // S
	send_key(16'h0023); // D
	send_key(16'h005A); // Enter
	send_key(16'h0029); // Space
	send_key(16'hE075); // Up
	send_key(16'hE072); // Down
	
	#200000;
	$finish;
end

// 8. Printing block - Check correct encoding
always @(posedge clk) begin
	if (key_enc[3]) begin
		case (key_enc[2:0])
			3'b000 : $display("%t: 'W' pressed", $time);
			3'b001 : $display("%t: 'A' pressed", $time);
			3'b010 : $display("%t: 'S' pressed", $time);
			3'b011 : $display("%t: 'D' pressed", $time);
			3'b100 : $display("%t: 'Enter' pressed", $time);
			3'b101 : $display("%t: 'Space' pressed", $time);
			3'b110 : $display("%t: 'Up Arr' pressed", $time);
			3'b111 : $display("%t: 'Dwn Arr' pressed", $time);
		endcase
	end else begin
		case (key_enc[2:0])
			3'b000 : $display("%t: 'W' released", $time);
			3'b001 : $display("%t: 'A' released", $time);
			3'b010 : $display("%t: 'S' released", $time);
			3'b011 : $display("%t: 'D' released", $time);
			3'b100 : $display("%t: 'Enter' released", $time);
			3'b101 : $display("%t: 'Space' released", $time);
			3'b110 : $display("%t: 'Up Arr' released", $time);
			3'b111 : $display("%t: 'Dwn Arr' released", $time);
		endcase
	end
end

endmodule