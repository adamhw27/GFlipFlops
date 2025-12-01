module GlyphGen(
	input [9:0] hCount, vCount,
	output [2:0] pix
);


	always @(*)
	begin
		case (hCount[9:5])
			default :
				pix <= 3'b011;
			
			5'b
		
		endcase
	end

endmodule