
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:24:24 09/13/2015 
// Design Name: 
// Module Name:    regbank 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Register(D_in, wEnable, rst, clk, r
    );
	 input [15:0] D_in;
	 input clk, wEnable, rst;
	 output reg [15:0] r;
	 
 always @( posedge clk )
	begin
	if (~rst) r <= 16'b0000;
	else
		begin			
			if (wEnable)
				begin
					r <= D_in;
				end
			else
				begin
					r <= r;
				end
		end
	end
endmodule


// Shown below is one way to implement the register file
// This is a bottom-up, structural instantiation
// Another module is described in another file...
// .... which shows two dimensional construct for regfile

// Structural Implementation of RegBank
/********/
module RegBank(din, audioCounter, r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, regEnable, clk, rst);
	input clk, rst;
	input [15:0] din;
	input [15:0] audioCounter;
	input [15:0] regEnable;
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;

	
Register Inst0(
	.D_in(din),
	.wEnable(regEnable[0]),
	.rst(rst), 
	.clk(clk),
	.r(r0));
Register Inst1(din, regEnable[1], rst, clk, r1);
Register Inst2(din, regEnable[2], rst, clk, r2);
Register Inst3(din, regEnable[3], rst, clk, r3);
Register Inst4(audioCounter, 1, rst, clk, r4);
Register Inst5(din, regEnable[5], rst, clk, r5);
Register Inst6(din, regEnable[6], rst, clk, r6);
Register Inst7(din, regEnable[7], rst, clk, r7);
Register Inst8(din, regEnable[8], rst, clk, r8);
Register Inst9(din, regEnable[9], rst, clk, r9);
Register Inst10(din, regEnable[10], rst, clk, r10);
Register Inst11(din, regEnable[11], rst, clk, r11);
Register Inst12(din, regEnable[12], rst, clk, r12);
Register Inst13(din, regEnable[13], rst, clk, r13);
Register Inst14(din, regEnable[14], rst, clk, r14);
Register Inst15(din, regEnable[15], rst, clk, r15); 

endmodule
/**************/

