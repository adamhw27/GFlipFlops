module GlyphGen(
	input clk, rst,
	input [9:0] hCount, vCount,
	input [15:0] tempo, cursorLoc, currentBeat,
	input [63:0] beatArray,
	output reg [2:0] pixColor
);
	localparam GLYPH_DATA_LENGTH = 18432;
	localparam GLYPH_NUM = 18; // DETERMINE NUM  OF GLYPHS
	
	localparam BG = 5'd17;
	localparam OFFBEAT = 5'd0;
	localparam ONBEAT = 5'd1;
	localparam S_OFFBEAT = 5'd2;
	localparam S_ONBEAT = 5'd3;
	localparam BEAT_IND = 5'd4;
	localparam TITLE_16 = 5'd5;
	localparam TITLE_BIT = 5'd6;
	localparam TITLE_BO = 5'd7;
	localparam TITLE_X = 5'd8;
	localparam CHAR_UL_S1 = 5'd9;
	localparam CHAR_UR_S1 = 5'd10;
	localparam CHAR_BL_S1 = 5'd11;
	localparam CHAR_BR_S1 = 5'd12;
	localparam CHAR_UL_S2 = 5'd13;
	localparam CHAR_UR_S2 = 5'd14;
	localparam CHAR_BL_S2 = 5'd15;
	localparam CHAR_BR_S2 = 5'd16;
	
	wire [9:0] x_y_glyph = {hCount[9:5], vCount[9:5]};
	reg [7:0] glyphs [0 : GLYPH_DATA_LENGTH - 1]; // FIGURE OUT 
	reg [4:0] current_glyph;
	
	initial
	begin
		$readmemh("glyphH.hex", glyphs, 0, GLYPH_DATA_LENGTH - 1);
	end
	
	always @(posedge clk)
	begin
		pixColor <= glyphs[{current_glyph, hCount[4:0], vCount[4:0]}][2:0];
	end
	
	reg [1:0] dance_state_indicator;
	reg dance_state;
	
	always @(*)
	begin
		dance_state_indicator = currentBeat % 4;
		if(dance_state_indicator == 0 || dance_state_indicator == 1)
			dance_state = 0;
		else
			dance_state = 1;
	end
	
	
	always @(*)
	begin
		case (x_y_glyph)
			{5'd1, 5'd0}: begin
				current_glyph = TITLE_16;
			end
			{5'd2, 5'd0}: begin
				current_glyph = TITLE_BIT;
			end		
			{5'd3, 5'd0}: begin
				current_glyph = TITLE_BO;
			end
			{5'd4, 5'd0}: begin
				current_glyph = TITLE_X;
			end
			
			{{1'b0, currentBeat[3:0]} + 5'd3, 5'd2}:begin
				current_glyph = BEAT_IND;
			end
			
			// character 1
			{5'd1, 5'd3}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UL_S1;
				end
				else begin
					current_glyph = CHAR_UL_S2;
				end
			end
			
			{5'd2, 5'd3}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UR_S1;
				end
				else begin
					current_glyph = CHAR_UR_S2;
				end
			end
			{5'd1, 5'd4}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BL_S1;
				end
				else begin
					current_glyph = CHAR_BL_S2;
				end
			end
			{5'd2, 5'd4}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BR_S1;
				end
				else begin
					current_glyph = CHAR_BR_S2;
				end
			end
			
			//character 2
			{5'd1, 5'd6}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UL_S1;
				end
				else begin
					current_glyph = CHAR_UL_S2;
				end
			end
			
			{5'd2, 5'd6}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UR_S1;
				end
				else begin
					current_glyph = CHAR_UR_S2;
				end
			end
			{5'd1, 5'd7}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BL_S1;
				end
				else begin
					current_glyph = CHAR_BL_S2;
				end
			end
			{5'd2, 5'd7}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BR_S1;
				end
				else begin
					current_glyph = CHAR_BR_S2;
				end
			end
			
			// character 3
			{5'd1, 5'd9}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UL_S1;
				end
				else begin
					current_glyph = CHAR_UL_S2;
				end
			end
			
			{5'd2, 5'd9}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UR_S1;
				end
				else begin
					current_glyph = CHAR_UR_S2;
				end
			end
			{5'd1, 5'd10}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BL_S1;
				end
				else begin
					current_glyph = CHAR_BL_S2;
				end
			end
			{5'd2, 5'd10}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BR_S1;
				end
				else begin
					current_glyph = CHAR_BR_S2;
				end
			end
			
			// character 4
			{5'd1, 5'd12}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UL_S1;
				end
				else begin
					current_glyph = CHAR_UL_S2;
				end
			end
			
			{5'd2, 5'd12}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_UR_S1;
				end
				else begin
					current_glyph = CHAR_UR_S2;
				end
			end
			{5'd1, 5'd13}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BL_S1;
				end
				else begin
					current_glyph = CHAR_BL_S2;
				end
			end
			{5'd2, 5'd13}: begin
				if(dance_state == 0) begin
					current_glyph = CHAR_BR_S1;
				end
				else begin
					current_glyph = CHAR_BR_S2;
				end
			end
			
			// beat array
			
			// BEAT 1
			{5'd3, 5'd3}: begin
				case ({6'd0 == cursorLoc, beatArray[6'd0]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd3, 5'd6}: begin
				case ({6'd16 == cursorLoc, beatArray[6'd16]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase			
			end
			{5'd3, 5'd9}: begin
				case ({6'd32 == cursorLoc, beatArray[6'd32]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd3, 5'd12}: begin
				case ({6'd48 == cursorLoc, beatArray[6'd48]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			
			// BEAT 2
			{5'd4, 5'd3}: begin
				case ({6'd1 == cursorLoc, beatArray[6'd1]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd4, 5'd6}: begin
				case ({6'd17 == cursorLoc, beatArray[6'd17]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd4, 5'd9}: begin
				case ({6'd33 == cursorLoc, beatArray[6'd33]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd4, 5'd12}: begin
				case ({6'd49 == cursorLoc, beatArray[6'd49]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 3
			{5'd5, 5'd3}: begin
				case ({6'd2 == cursorLoc, beatArray[6'd2]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd5, 5'd6}: begin
				case ({6'd18 == cursorLoc, beatArray[6'd18]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd5, 5'd9}: begin
				case ({6'd34 == cursorLoc, beatArray[6'd34]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd5, 5'd12}: begin
				case ({6'd50 == cursorLoc, beatArray[6'd50]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 4
			{5'd6, 5'd3}: begin
				case ({6'd3 == cursorLoc, beatArray[6'd3]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd6, 5'd6}: begin
				case ({6'd19 == cursorLoc, beatArray[6'd19]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd6, 5'd9}: begin
				case ({6'd35 == cursorLoc, beatArray[6'd35]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd6, 5'd12}: begin
				case ({6'd51 == cursorLoc, beatArray[6'd51]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 5
			{5'd7, 5'd3}: begin
				case ({6'd4 == cursorLoc, beatArray[6'd4]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd7, 5'd6}: begin
				case ({6'd20 == cursorLoc, beatArray[6'd20]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd7, 5'd9}: begin
				case ({6'd36 == cursorLoc, beatArray[6'd36]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd7, 5'd12}: begin
				case ({6'd52 == cursorLoc, beatArray[6'd52]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 6
			{5'd8, 5'd3}: begin
				case ({6'd5 == cursorLoc, beatArray[6'd5]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd8, 5'd6}: begin
				case ({6'd21 == cursorLoc, beatArray[6'd21]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd8, 5'd9}: begin
				case ({6'd37 == cursorLoc, beatArray[6'd37]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd8, 5'd12}: begin
				case ({6'd53 == cursorLoc, beatArray[6'd53]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 7
			{5'd9, 5'd3}: begin
				case ({6'd6 == cursorLoc, beatArray[6'd6]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd9, 5'd6}: begin
				case ({6'd22 == cursorLoc, beatArray[6'd22]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd9, 5'd9}: begin
				case ({6'd38 == cursorLoc, beatArray[6'd38]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd9, 5'd12}: begin
				case ({6'd54 == cursorLoc, beatArray[6'd54]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end// BEAT 8
			{5'd10, 5'd3}: begin
				case ({6'd7 == cursorLoc, beatArray[6'd7]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd10, 5'd6}: begin
				case ({6'd23 == cursorLoc, beatArray[6'd23]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd10, 5'd9}: begin
				case ({6'd39 == cursorLoc, beatArray[6'd39]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd10, 5'd12}: begin
				case ({6'd55 == cursorLoc, beatArray[6'd55]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end// BEAT 9
			{5'd11, 5'd3}: begin
				case ({6'd8 == cursorLoc, beatArray[6'd8]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd11, 5'd6}: begin
				case ({6'd24 == cursorLoc, beatArray[6'd24]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd11, 5'd9}: begin
				case ({6'd40 == cursorLoc, beatArray[6'd40]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd11, 5'd12}: begin
				case ({6'd56 == cursorLoc, beatArray[6'd56]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end// BEAT 10
			{5'd12, 5'd3}: begin
				case ({6'd9 == cursorLoc, beatArray[6'd9]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd12, 5'd6}: begin
				case ({6'd25 == cursorLoc, beatArray[6'd25]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd12, 5'd9}: begin
				case ({6'd41 == cursorLoc, beatArray[6'd41]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd12, 5'd12}: begin
				case ({6'd57 == cursorLoc, beatArray[6'd57]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 11
			{5'd13, 5'd3}: begin
				case ({6'd10 == cursorLoc, beatArray[6'd10]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd13, 5'd6}: begin
				case ({6'd26 == cursorLoc, beatArray[6'd26]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd13, 5'd9}: begin
				case ({6'd42 == cursorLoc, beatArray[6'd42]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd13, 5'd12}: begin
				case ({6'd58 == cursorLoc, beatArray[6'd58]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 12
			{5'd14, 5'd3}: begin
				case ({6'd11 == cursorLoc, beatArray[6'd11]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd14, 5'd6}: begin
				case ({6'd27 == cursorLoc, beatArray[6'd27]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd14, 5'd9}: begin
				case ({6'd43 == cursorLoc, beatArray[6'd43]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd14, 5'd12}: begin
				case ({6'd59 == cursorLoc, beatArray[6'd59]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 13
			{5'd15, 5'd3}: begin
				case ({6'd12 == cursorLoc, beatArray[6'd12]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd15, 5'd6}: begin
				case ({6'd28 == cursorLoc, beatArray[6'd28]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd15, 5'd9}: begin
				case ({6'd44 == cursorLoc, beatArray[6'd44]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd15, 5'd12}: begin
				case ({6'd60 == cursorLoc, beatArray[6'd60]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 14
			{5'd16, 5'd3}: begin
				case ({6'd13 == cursorLoc, beatArray[6'd13]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd16, 5'd6}: begin
				case ({6'd29 == cursorLoc, beatArray[6'd29]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd16, 5'd9}: begin
				case ({6'd45 == cursorLoc, beatArray[6'd45]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd16, 5'd12}: begin
				case ({6'd61 == cursorLoc, beatArray[6'd61]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 15
			{5'd17, 5'd3}: begin
				case ({6'd14 == cursorLoc, beatArray[6'd14]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd17, 5'd6}: begin
				case ({6'd30 == cursorLoc, beatArray[6'd30]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd17, 5'd9}: begin
				case ({6'd46 == cursorLoc, beatArray[6'd46]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd17, 5'd12}: begin
				case ({6'd62 == cursorLoc, beatArray[6'd62]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			// BEAT 16
			{5'd18, 5'd3}: begin
				case ({6'd15 == cursorLoc, beatArray[6'd15]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd18, 5'd6}: begin
				case ({6'd31 == cursorLoc, beatArray[6'd31]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd18, 5'd9}: begin
				case ({6'd47 == cursorLoc, beatArray[6'd47]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			{5'd18, 5'd12}: begin
				case ({6'd63 == cursorLoc, beatArray[6'd63]})
					2'b00: current_glyph = OFFBEAT;
					2'b01: current_glyph = ONBEAT;
					2'b10: current_glyph = S_OFFBEAT;
					2'b11: current_glyph = S_ONBEAT;
					default: current_glyph = OFFBEAT;
				endcase
			end
			
			default:
				current_glyph = BG;
		endcase
	
	
	end

endmodule