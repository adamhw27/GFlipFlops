module VGAcontroller(
	input wire clk, rst,
	
	output wire vga_clk, hs, vs, bright,
	output wire [9:0] x, y
);


wire new_clk;
wire [15:0] count;

clk_div divider(.clk(clk), .rst(rst), .oclk(new_clk));

always @(posedge new_clk, negedge rst) begin
	if( ~rst)begin
		x <= 10'b0;
		y <= 10'b0;
		count <= 16'b0;
	end
	count <= count + 1;
end


// need to count the number of count signals 

wire [9:0] hlencount;
wire [9:0] vlencount;

wire hbright;
wire vbright;
vlencount = 10'b0;
hlencount = 10'b0;

always @(count, hlencount) begin

	if (count == 0)
		hlencount = 0;
		
	
	if (hlencount < 96)begin
		hs = 0;
		hbright = 0;
	end
	else begin
		hs = 1;
		if (hlencount < 144)
			hbright = 0;
		else begin
			if (hlencount < 784)
				hbright = 1;
			else
				hbright = 0;
			end
		end
	end
	
	hlencount <= hlencount + 1;
	
	if (hlencount > 800)begin
		hlencount = 0;
	end
end


always @(count) begin

	if (vlencount < 1600)begin
		vs = 0;
		vbright = 0;
	end
	else begin
		hs = 1;
		if (vlencount < 24800)
			vbright = 0;
		else begin
			if (vlencount < 408800)
				vbright = 1;
			else
				vbright = 0;
			end
		end
	end
	
	vlencount <= vlencount + 1;
	
	if (vlencount > 416800)begin
		vlencount <= 0;
	end
end


bright = vbright & hbright;



endmodule