module PCDisplacementCalculator(
	input wire [15:0] inPC,
	input wire [15:0] Rtarget,
	input wire [7:0] disp,
	input wire target_or_disp,
	output reg [15:0] incr
);
	always @* begin
		case(target_or_disp)
			1'b0:
				begin
				incr <= Rtarget;
				end
			1'b1:
				begin
					if(disp[7])
						incr <= inPC + {8'hff, disp[7:0]};
					else
						incr <= inPC + {8'h00, disp[7:0]};
				end
			default:
				begin
				incr <= inPC + 1;
				end
		endcase
	end
endmodule