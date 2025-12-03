`timescale 1ns/1ps	// 1 nanosecond steps, 1 picosecond precision

module ps2_interface_tb();

// 1. Declaration of FPGA clock signal (50 MHz)
reg clk;
initial clk = 0;
forever #10 clk = ~clk;

// 2. Declaration of PS/2 clock signal (10 kHz)
reg ps2_clk = 0;
initial ps2_clk = 0;

// 3. Declare & initialize signals
reg rst = 0;
reg ps2_dat = 1;
wire new_avail, extra, break, parity_err;	// Output signals
wire [7:0] code;

// 4. Instantiate PS/2 interface
ps2_interface ps2(
	.clk(clk), .rst(rst),
	.ps2_clk(ps2_clk), .ps2_dat(ps2_dat),
	.new_avail(new_avail),
	.data(code),
	.extra(extra), .break(break),
	.parity_err(parity_err)
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
		force ps2_dat = 0;
		pulse_clk();
		
		// Generate 8 data bits, LSB first
		for (i = 0; i < 8; i = i + 1) begin
			force ps2_dat = data[i];
			pulse_clk();
		end
		
		// Parity bit
		force ps2_dat = parity;
		pulse_clk();
		
		// Stop bit
		force ps2_dat = 1;
		pulse_clk();
		
		release ps2_dat;
	end
endtask

// 6. Initialize testing block
initial begin
	#100000 rst = 1;
	
	// =============================
	// Testing W key (0x1D & 0xF01D)
	// =============================
	send_ps2_byte(8'h1D);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h1D);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// =============================
	// Testing A key (0x1C & 0xF01C)
	// =============================
	send_ps2_byte(8'h1C);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h1C);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// =============================
	// Testing S key (0x1B & 0xF01B)
	// =============================
	send_ps2_byte(8'h1B);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h1B);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// =============================
	// Testing D key (0x23 & 0xF023)
	// =============================
	send_ps2_byte(8'h23);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h23);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// ===================================
	// Testing Up arrow (0xE075 & 0xE0F075)
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'h75);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h75);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// Testing Down arrow (0xE072)
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'h72);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h72);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// Testing Left arrow (0xE06B)
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'h6B);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h6B);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// Testing Right arrow (0xE074)
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'h74);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h74);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	// Testing Enter key (0x5A)
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'h5A);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	send_ps2_byte(8'hE0);
	send_ps2_byte(8'hF0);
	send_ps2_byte(8'h5A);
	wait(valid == 1)
	#1 ack = 1; #20 ack = 0;
	
	#200000;
	$finish;
end

// 7. Printing block
always @(posedge clk) begin
	if (valid) begin
		$display("Time %t: code=%h extended=%b released=%b parity_err=%b",
					$time, code, extended, released, parity_error);
	end
end


endmodule
