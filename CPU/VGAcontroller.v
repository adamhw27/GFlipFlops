module VGAcontroller(
	input wire clk, rst,
	
	output reg hs, vs, 
	output wire bright,
	output reg [9:0] hCount, vCount
);


wire new_clk;
reg [15:0] count;

clk_div divider(.clk(clk), .rst(rst), .oclk(new_clk));


// hreset and vreset are active high
wire [18:0] hlencount, vlencount;

// hreset is set high once per line, so it is the clock at which vlencount should increment
counter_19bit hcounter(.clk(count), .rst(hreset), .val(hlencount));
counter_19bit vcounter(.clk(hreset), .rst(vreset), .val(vlencount));

reg hbright, vbright, hreset, vreset;

always @(posedge new_clk) begin
	count <= count + 1'b1;
end


// need to count the number of count signals 



always @(hlencount, hCount) 
begin
	hreset <= 1'b0;
		
	if (hlencount < 96)
	begin
		hs <= 0;
		hbright <= 0;
		hCount <= 0;
	end
	else 
	begin
		hs <= 1;
		if (hlencount < 144)
		begin
			hbright <= 0;
			hCount <= 0;
		end
		else 
		begin
			if (hlencount < 784)
			begin
				hCount <= hCount + 1'b1;
				hbright <= 1;
			end
			else if (hlencount < 800)
			begin
				hCount <= 0;
				hbright <= 0;
			end
			else
			begin
				hbright <= 0;
				hCount <= 10'b0;
				hreset <= 1'b1;
			end
		end
	end
end


always @(vlencount, vCount) 
begin
	vreset <= 1'b0;

	if (vlencount < 2)
	begin
		vs <= 0;
		vbright <= 0;
		vCount <= 0;
	end
	else 
	begin
		vs <= 1;
		if (vlencount < 35)
		begin
			vCount <= 0;
			vbright <= 0;
		end
		else 
		begin
			if (vlencount < 515)
			begin
				vCount <= vCount + 1'b1;
				vbright <= 1;
			end
			else if (vlencount < 525)
			begin
				vCount <= 0;
				vbright <= 0;
			end
			else
			begin
				vbright <= 0;
				vCount <= 0;
				vreset <= 1'b1;
			end
		end
	end
end

assign bright = vbright & hbright;
endmodule