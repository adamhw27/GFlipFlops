module decoding (
	input [15:0] inst,
	
	output reg [7:0] opcode,
	output reg [3:0] Rdest,
	output reg [3:0] Rsrc,
	output reg [15:0] imm

);

	always @(inst)
		begin
			Rdest = inst[11:8];
			Rsrc = inst[3:0];
			if (inst[15:12] == 0)
				opcode = {inst[15:12], inst[7:4]};
				imm = 0;
			else // not sure if this handles unsigned operations correctly
				imm = {8inst[7],inst[7:0]}
			end
		end

endmodule