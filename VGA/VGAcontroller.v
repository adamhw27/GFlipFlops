module VGAcontroller(
	input wire clk, rst,
	
	output wire hs, vs, 
	output reg bright, new_clk,
	output reg [9:0] hCount, vCount
);

localparam H_SYNC_PULSE_TIME = 10'd800;
localparam H_DISPLAY_TIME = 10'd640;
localparam H_PULSE_WIDTH = 10'd96;
localparam H_FRONT_PORCH = 10'd16;
localparam H_BACK_PORCH = 10'd48;

localparam V_SYNC_PULSE_TIME = 10'd525;
localparam V_DISPLAY_TIME = 10'd480;
localparam V_PULSE_WIDTH = 10'd2;
localparam V_FRONT_PORCH = 10'd10;
localparam V_BACK_PORCH = 10'd33;

assign hs = ~((hCount >= H_FRONT_PORCH ) & (hCount < H_FRONT_PORCH + H_PULSE_WIDTH));
assign vs = ~((vCount >= V_DISPLAY_TIME + V_FRONT_PORCH) & (vCount < V_DISPLAY_TIME + V_FRONT_PORCH + V_PULSE_WIDTH));

//clk_div divider(.clk(clk), .rst(rst), .oclk(new_clk));

always @(posedge clk)
begin
	if(~rst)
	begin
		hCount <= 10'd0;
		vCount <= 10'd0;
		new_clk <= 10'd0;
	end
	else
	begin
		if(new_clk)
		begin
			hCount <= hCount + 1'b1;
			if(hCount == H_SYNC_PULSE_TIME)
			begin
				vCount <= vCount + 10'd1;
				hCount <= 10'd0;
				
				if(vCount == V_SYNC_PULSE_TIME)
				begin
					vCount <= 10'd0;
				end
			end
		end
	new_clk <= ~new_clk;
	end
end

always @(hCount, vCount) 
begin
	if((hCount >= H_PULSE_WIDTH + H_BACK_PORCH + H_FRONT_PORCH) &&
			(hCount < H_SYNC_PULSE_TIME - H_FRONT_PORCH) &&
			(vCount < V_DISPLAY_TIME))
	begin
		bright <= 1'b1;
	end
	else begin
		bright <= 1'b0;
	end
end
endmodule