module mem
(
	input clk, rst,
	output [27:0] segOut
);

wire [15:0] q_a, q_b;
wire [9:0] data_a, data_b, addr_a, addr_b;
wire we_a, we_b;

memFSM fsm(.rst(rst), .clk(clk), .data_a(data_a), .data_b(data_b), .addr_a(addr_a), .addr_b(addr_b), .we_a(we_a), .we_b(we_b));


true_dual_port_ram_single_clock f(.data_a(data_a), .data_b(data_b), .addr_a(addr_a), .addr_b(addr_b), .we_a(we_a), .we_b(we_b), .clk(clk), .q_a(q_a), .q_b(q_b));

// Connect SegOut
seven_seg_hex a(q_a[3:0], segOut[6:0]);
seven_seg_hex b(q_a[7:4], segOut[13:7]);
seven_seg_hex c(q_b[3:0], segOut[20:14]);
seven_seg_hex d(q_b[7:4], segOut[27:21]);
	
endmodule