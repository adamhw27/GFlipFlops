module generalFSM (
input clk,
input rst,
input [4:0] flags,
input [15:0] inst,

output reg [15:0] Ren,

output reg PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, keySel, rst_handle,

output reg [7:0] opcode,
output reg [3:0] Rsrc,
output reg [3:0] Rdest,
output reg [15:0] imm,
output reg [7:0] displacement,
output reg j_or_b_Sel,
output reg PCSel
);

// output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel
// check opcodes for LOAD and STORE are okay
// do these need to be reg? do we even need these if we have the IR reg?
reg [3:0] savedRdest;
reg savedAlu_Mux_ctrl;
reg [3:0] savedRsrc;

reg [3:0] state;

// states
parameter S0_Fetch = 4'b0000;
parameter S1_Decode = 4'b0001;
parameter S2_Rtype = 4'b0010;
parameter S3_Store = 4'b0011;
parameter S4_Load = 4'b0100;
parameter S5_dataToReg = 4'b0101;
parameter S6_Jump = 4'b0110;
parameter S7_Branch = 4'b0111;
parameter S8_Keypress = 4'b1000;
parameter S9_Rstkey = 4'b1001;

always @(posedge clk) begin
 if (~rst) state <= S0_Fetch;
 else begin
case (state)
S0_Fetch: state <= S1_Decode;
S1_Decode: begin
 
if (opcode == 8'b0100_0100) begin
state <= S3_Store;
end
else if (opcode == 8'b0100_0000) begin
state <= S4_Load;
end
else if (opcode == 8'b0100_1100) begin
state <= S6_Jump;
end
else if (opcode == 8'b1111_1111) begin
state <= S8_Keypress;
end
else if (opcode == 8'b1111_1110) begin
state <= S9_Rstkey;
end
else if (opcode[7:4] == 4'b1100) begin
state <= S7_Branch;
end
else begin
state <= S2_Rtype;
end

end

S2_Rtype: state <= S0_Fetch;
S3_Store: state <= S0_Fetch;
S4_Load: state <= S5_dataToReg;
S5_dataToReg: state <= S0_Fetch;

default: state <= S0_Fetch;
endcase
 end
end


always @(state)  begin


case(state)



S0_Fetch: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel

PCen = 0;
LScntl = 0;
PCSel = 1;
flagEn = 0;
we_a = 0;
Alu_Mux_cntl = 0;
Rdest = 4'bxxxx;
Rsrc = 4'bxxxx;
opcode = 8'bxxxxxxxx;
imm = 16'bx;
RorI = 1'bx;
Ren = 16'bx;
j_or_b_Sel = 1'bx;
RetAddrSave = 0;
displacement = 16'bx;
rst_handle = 1'b0;



end

S1_Decode: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel


PCen = 0;
PCSel = 0;
LScntl = 0;
we_a = 0;
flagEn = 0;
Alu_Mux_cntl = 0;
j_or_b_Sel = 1'bx;
Rdest = inst[11:8];
Rsrc = inst[3:0];
Ren = 16'b0;
RetAddrSave = 0;
keySel = 0;

if (inst[15:12] == 0) begin // NON I TYPE INSTRUCTIONS
RorI = 0; // indicates to choose Rsrc

opcode = {inst[15:12], inst[7:4]};
imm = 0;

end else if (inst[15:12] == 4'b0100 || inst[15:12] == 4'b1100) begin // indicates load, store, jump branch inst
opcode = {inst[15:12], inst[7:4]};
RorI = 0;
imm = 0;
end else if (inst[15:12] == 4'b1111) begin //indicates key[ress
opcode = {inst[15:12], inst[7:4]};
RorI = 0;
imm = 0;


end else begin// not sure if this handles unsigned operations correctly
RorI = 1; // indicates to choose immediate
opcode = inst[15:12];
if (inst[7])
imm = {8'hff, inst[7:0]};
else
imm = {8'h00, inst[7:0]};
end
// displacement = imm;
savedRdest = Rdest;
savedRsrc = Rsrc;
savedAlu_Mux_ctrl = Alu_Mux_cntl;


end

S2_Rtype: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel


PCSel = 1'b0;
//RorI = 0;
//RetAddrSave = 0;
//opcode = opcode;

if (inst[15:12] == 4'b1011 || inst[7:4] == 4'b1011) begin//cmp dont write
Ren = 16'b0;
end
else begin
Ren= 16'b1 << Rdest; // wb to rdest register
end


PCen = 1;
LScntl = 0;
flagEn = 1;
we_a = 0;
Alu_Mux_cntl = 0;
j_or_b_Sel = 1'bx;

end

S3_Store: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel


Alu_Mux_cntl = 0;
RorI = 0;

j_or_b_Sel = 1'bx;
Rdest = savedRsrc;
Rsrc = savedRdest;

PCen = 1;
LScntl = 1;
flagEn = 0;
we_a = 1;

Alu_Mux_cntl = 0;
Ren = 16'bx;
PCSel = 1'b0;
//RetAddrSave = 0;
//opcode = opcode;
//imm = imm;
//displacement = displacement;



end

S4_Load: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel


Rdest = savedRdest;
Alu_Mux_cntl = savedAlu_Mux_ctrl;
Rsrc = savedRsrc;
RorI = 0;
j_or_b_Sel = 1'bx;

PCen = 0;
LScntl = 1;
flagEn = 0;
we_a = 0;
Alu_Mux_cntl = 0;
Ren = 16'bx;
PCSel = 1'b0;

//RetAddrSave = 0;
//opcode = 8'bx;
//imm = 16'bx;
//displacement = 16'bx;


end

S5_dataToReg: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel

Rdest = savedRdest;
Alu_Mux_cntl = savedAlu_Mux_ctrl;
Rsrc = savedRsrc;
RorI = 0;
flagEn = 0;
j_or_b_Sel = 1'bx;
LScntl = 1;
we_a = 0;
Alu_Mux_cntl = 1;
Ren= 16'b1 << Rsrc; // wb to rdest register
PCSel = 1'b0;

PCen = 1;
//RetAddrSave = 0;
//opcode = 8'bx;
//imm = 16'bx;
//displacement = 16'bx;
end

S6_Jump: begin // output list: Ren, PCen, RorI, LScntl, we_a, Alu_Mux_cntl, flagEn, RetAddrSave, opcode, Rsrc, Rdest, imm, displacement, j_or_b_Sel, PCSel

// LSB =========================MSB
// [Carry, Low, Flag, Negative, Z]
flagEn = 0;
j_or_b_Sel = 1'b0;
RorI = 1'bx;
LScntl = 1'bx;
we_a = 0;
Alu_Mux_cntl = 1'bx;
opcode = 8'bx;
Rsrc = savedRsrc;
Rdest = savedRdest;
displacement = displacement;
imm = 16'bx;


// checking for which jump condition


case(inst[11:8])

4'b0000: // jeq (jump if equal)
begin
Ren= 16'b0;
RetAddrSave = 0;
if( flags[4] == 1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b0001: begin // not equal
Ren= 16'b0;
RetAddrSave = 0;
if( flags[4] == 0) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1110: // unconditional jump IMPORTANT: sets r15 (return address register) with current PC + 1
begin
Ren= 16'b1 << 15;
RetAddrSave = 1;
PCSel = 1'b1;
PCen = 1'b1;
end

4'b1100: // less than

begin
Ren= 16'b0;
RetAddrSave = 0;
if( flags[3] == 0 && flags[4] == 0)begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1010: // lower than

begin
Ren= 16'b0;
RetAddrSave = 0;
if(flags[1] == 0 && flags[4] == 0) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1101: // greater than or equal

begin
Ren= 16'b0;
RetAddrSave = 0;
if(flags[4] == 1 || flags[3] ==1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1011: //higher than or same as
begin
Ren= 16'b0;
RetAddrSave = 0;
if(flags[4] == 1 || flags[1] ==1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

endcase
end

S7_Branch: begin
// LSB =========================MSB
// [Carry, Low, Flag, Negative, Z]

displacement = inst[7:0];
j_or_b_Sel = 1'b1;
Ren= 16'bx;
RetAddrSave = 0;

flagEn = 0;
RorI = 1'bx;
LScntl = 1'bx;
we_a = 0;
Alu_Mux_cntl = 1'bx;
opcode = 8'bx;
Rsrc = savedRsrc;
Rdest = savedRdest;
imm = 16'bx;

// Check branch condition
case(inst[11:8])

4'b0000: // beq (branch if equal)
begin
if( flags[4] == 1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b0001: begin // not equal
if( flags[4] == 0) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1110: // unconditional branch
begin
PCSel = 1'b1;
PCen = 1'b1;
end

4'b1100: // less than
begin
if( flags[3] == 0 && flags[4] == 0)begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1010: // lower than
begin
if(flags[1] == 0 && flags[4] == 0) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1101: // greater than or equal
begin
if(flags[4] == 1 || flags[3] ==1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

4'b1011: //higher than or same as
begin
if(flags[4] == 1 || flags[1] ==1) begin
PCSel = 1'b1;
PCen = 1'b1;
end
else begin
PCSel = 1'b0;
PCen = 1'b1;
end
end

endcase
end

S8_Keypress: begin
PCSel = 1'b0;
PCen = 1'b1;
Ren = 16'd1 << 16'd6;
keySel = 1'b1;
rst_handle = 1'b0;

end

S9_Rstkey: begin
PCSel = 1'b0;
PCen = 1'b1;
rst_handle = 1'b1;
end



endcase
end

endmodule