module VGABitGen(
	input bright,
	input [7:0] pixelData,
	input [9:0] hCount, vCount,
	input [2:0] pixColor,
	output wire [23:0] rgb
);
reg r, g, b;
assign rgb = {{pixColor[0], 7'd0}, {pixColor[1], 7'd0}, {pixColor[2], 7'd0}};

reg [9:0] titleOffset, vTitleOffset;
always @(*)
begin
	titleOffset = 10'd5;
	vTitleOffset = 10'd5;
	
	if (~bright) begin
		r <= 1'd0;
		g <= 1'd0;
		b <= 1'd0;
	end
	else begin
	
		// 1 in 16-BitBox (title
		if((hCount >= 10'd161 + titleOffset && hCount < 10'd169+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// Drawing 6
		else if ((hCount >= 10'd172+ titleOffset && hCount < 10'd180+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// still drawing 6
		else if((hCount >= 10'd180+ titleOffset && hCount < 10'd196+ titleOffset) &&
				(vCount >= 10'd9+ titleOffset && vCount < 10'd14+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// still drawing 6
		else if((hCount >= 10'd180+ titleOffset && hCount < 10'd196+ titleOffset) &&
				(vCount >= 10'd20+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// still drawing 6
		else if((hCount >= 10'd188+ titleOffset && hCount < 10'd196+ titleOffset) &&
				(vCount >= 10'd9+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd204+ titleOffset && hCount < 10'd212+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd212+ titleOffset && hCount < 10'd220+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd6+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd212+ titleOffset && hCount < 10'd220+ titleOffset) &&
				(vCount >= 10'd11+ titleOffset && vCount < 10'd15+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd212+ titleOffset && hCount < 10'd220+ titleOffset) &&
				(vCount >= 10'd20+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		
		// drawing B
		else if((hCount >= 10'd220+ titleOffset && hCount < 10'd228+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd11+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd220+ titleOffset && hCount < 10'd228+ titleOffset) &&
				(vCount >= 10'd15+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing i
		else if ((hCount >= 10'd231+ titleOffset && hCount < 10'd239+ titleOffset) &&
					(vCount >= 10'd6+ titleOffset && vCount < 10'd11+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing i
		else if ((hCount >= 10'd231+ titleOffset && hCount < 10'd239+ titleOffset) &&
					(vCount >= 10'd15+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing t
		else if ((hCount >= 10'd242+ titleOffset && hCount < 10'd246+ titleOffset) &&
					(vCount >= 10'd6+ titleOffset && vCount < 10'd11+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing t
		else if ((hCount >= 10'd246+ titleOffset && hCount < 10'd254+ titleOffset) &&
					(vCount >= 10'd1+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing t
		else if ((hCount >= 10'd254+ titleOffset && hCount < 10'd258+ titleOffset) &&
					(vCount >= 10'd6+ titleOffset && vCount < 10'd11+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		
		// drawing B
		else if((hCount >= 10'd262+ titleOffset && hCount < 10'd270+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd270+ titleOffset && hCount < 10'd278+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd6+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd270+ titleOffset && hCount < 10'd278+ titleOffset) &&
				(vCount >= 10'd11+ titleOffset && vCount < 10'd15+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd270+ titleOffset && hCount < 10'd278+ titleOffset) &&
				(vCount >= 10'd20+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		
		// drawing B
		else if((hCount >= 10'd278+ titleOffset && hCount < 10'd286+ titleOffset) &&
				(vCount >= 10'd1+ titleOffset && vCount < 10'd11+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing B
		else if((hCount >= 10'd278+ titleOffset && hCount < 10'd286+ titleOffset) &&
				(vCount >= 10'd15+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing o
		else if((hCount >= 10'd290+ titleOffset && hCount < 10'd298+ titleOffset) &&
				(vCount >= 10'd7+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing o
		else if((hCount >= 10'd298+ titleOffset && hCount < 10'd306+ titleOffset) &&
				(vCount >= 10'd7+ titleOffset && vCount < 10'd13+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing o
		else if((hCount >= 10'd298+ titleOffset && hCount < 10'd306+ titleOffset) &&
				(vCount >= 10'd19+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing o
		else if((hCount >= 10'd306+ titleOffset && hCount < 10'd314+ titleOffset) &&
				(vCount >= 10'd7+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing x
		else if((hCount >= 10'd318+ titleOffset && hCount < 10'd326+ titleOffset) &&
				(vCount >= 10'd7+ titleOffset && vCount < 10'd13+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing x
		else if((hCount >= 10'd318+ titleOffset && hCount < 10'd326+ titleOffset) &&
				(vCount >= 10'd19+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing x
		else if((hCount >= 10'd326+ titleOffset && hCount < 10'd334+ titleOffset) &&
				(vCount >= 10'd13+ titleOffset && vCount < 10'd19+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing x
		else if((hCount >= 10'd334+ titleOffset && hCount < 10'd342+ titleOffset) &&
				(vCount >= 10'd7+ titleOffset && vCount < 10'd13+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		// drawing x
		else if((hCount >= 10'd334+ titleOffset && hCount < 10'd342+ titleOffset) &&
				(vCount >= 10'd19+ titleOffset && vCount < 10'd25+ titleOffset))
		begin
			r <= 1'd0;
			g <= 1'd0;
			b <= 1'd0;
		end
		
		else if((hCount > 10'd200 && hCount < 10'd400) &&
				(vCount > 10'd150 && vCount < 10'd350))
		begin
			r <= 1'd1;
			g <= 1'd0;
			b <= 1'd1;
		end
		else
		begin
			r <= 1'd0;
			g <= 1'd1;
			b <= 1'd1;
		end
	end
end

endmodule