// Beginning alu for lab 1 ece3710

module alu(R1, R2, opcode, aluOut, flags, cin);

// R1 (Source) & R2 (Destination)
input wire [15:0] R1, R2;
input wire [3:0] opcode;
input wire cin;

output reg [15:0] aluOut;

output reg [4:0] flags;
// [Carry, Low, Flag, Negative, Z]

parameter ADD = 8'b0000_0101;
parameter ADDI = 8'b0101_xxxx;
parameter ADDU = 8'b0000_0110; 
parameter ADDUI = 8'b0110_xxxx; 
parameter ADDC = 8'b0000_0111;
parameter ADDCI = 8'b0111_xxxx;

parameter MUL = 8'b0000_1110;
parameter MUL = 8'b1110_xxxx;

parameter SUB = 8'b0000_1001;
parameter SUBI = 8'b1001_xxxx;
parameter SUBC = 8'b0000_1010;
parameter SUBCI = 8'b1010_xxxx;

parameter CMP = 8'b0000_1011;
parameter CMPI = 8'b1011_xxxx;

parameter AND = 8'b0000_0001;
parameter ANDI = 8'b0001_xxxx;
parameter OR = 8'b0000_0010;
parameter ORI = 8'b0010_xxxx;
parameter XOR = 8'b0000_0011;
parameter XORI = 8'b0011_xxxx;
parameter MOV = 8'b0000_1101;
parameter MOVI = 8'b1101_xxxx;

parameter LSH = 8'b1000_1000;
parameter LSHI = 8'b1000_000x;
parameter ASHU = 8'b1000_1111;
parameter ASHUI = 8'b1000_001x;


always @(R1, R2, opcode)
 begin
	
	flags[4:0] = 5'b00000;
	
	casex (opcode)
	
  
	ADD : 
		begin 
		
			aluOut = (R1 + R2);
		
			// Set overflow flag
			if ( (~R1[15] & ~R2[15] & aluOut[15]) | (R1[15] & R2[15] & ~aluOut[15])) flags[2] = 1'b1;
			else flags[2] = 1'b0;
			
		end
		
	ADDU :
		begin
		
			// Set carry bit and dst reg
			{flags[0], aluOut} = (R1 + R2);
			
			// Overflow is ignored
	
		end
		
	ADDC : 
		begin 
			
			// Set carry flag and dst reg
			{flags[0], aluOut} = (R1 + R2 + cin);
			
			// Set overflow flag
			if ( (~R1[15] & ~R2[15] & aluOut[15]) | (R1[15] & R2[15] & ~aluOut[15])) flags[2] = 1'b1;
			else flags[2] = 1'b0;
	
		end
	
	MUL : 
		begin
			
			aluOut = (R1 * R2);

		end
		
	SUB :
		begin
		
			// Set carry flag and dst reg
			
			aluOut = (R2 - R1);

			// Set overflow flag
			if ( (~R1[15] & ~R2[15] & ~aluOut[15]) | (R1[15] & R2[15] & aluOut[15])) flags[2] = 1'b1;
			else flags[2] = 1'b0;

		end
		
	SUBC :
		begin
		
			// Set carry and aluout
			
			{flags[0], aluOut} = (R2 - (R1 + cin));
			
			// Set overflow flag
			if ( (~R1[15] & ~R2[15] & aluOut[15]) | (R1[15] & R2[15] & ~aluOut[15])) flags[2] = 1'b1;
			else flags[2] = 1'b0;
			
	
		end
	
	CMP :
		begin

			// Equals
			if (R1 == R2) aluOut = 16'h0000;
			else aluOut = 16'hffff;
			
			// Compare signed
			if ($signed(R1) > $signed(R2)) flags[3] = 1'b1;
			else flags[3] = 1'b0;
			
			// Compare unsigned
			if (R1 > R2) flags[1] = 1'b1;
			else flags[1] = 1'b0;
							
		end
		
	AND :
		begin
			
			aluOut = R1 & R2;
					
		end
		
	OR :
		begin
			
			aluOut = R1 | R2;
						
		end
		
	XOR :
		begin
			
			aluOut = R1 ^ R2;

		end
		
	MOV :
		begin
		
			aluOut = R1;
			
		end
		
	LSH :
		begin
		
			if ($signed(R1) < 0) aluOut = R2 >> (~R1 + 1);
				
			else aluOut = R2 << R1;
						
		end
		
	ASHU :
		begin
	
			aluOut = R2 >>> R1;
					
		end
	
	default : 
	
		aluOut = 16'h0000;
		
  endcase
  
		// Set zero flag
		if (aluOut == 16'h0000) flags[4] = 1'b1;
		else flags[4] = 1'b0;
 end
 
endmodule
