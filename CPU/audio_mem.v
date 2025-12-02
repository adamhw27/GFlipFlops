module audio_mem (
    input  clk,
    input  sample_req,
    output [15:0] audio_output,
    input  [3:0]  control
);

parameter ROM_DEPTH = 65536;  // Set to your MIF DEPTH
reg [15:0] romdata [0:ROM_DEPTH-1];  // 16-bit PCM samples
reg [17:0] index = 0;               // Enough bits for ROM depth
reg [15:0] dat;

assign audio_output = dat;

parameter SINE     = 0;

//====================== Initialize ROM =======================
// This uses your MIF file in Quartus, e.g., "mem.mif"
initial begin
  $readmemh("hex_clean_big_endian.txt", romdata); // Reads MIF/HEX file into ROM -- HAS TO BE BIG ENDIAN
end

always @(posedge clk) begin
    if (sample_req) begin
        if (control[SINE]) begin
            dat <= romdata[index];
            if (index == ROM_DEPTH - 1)
                index <= 0;
            else
                index <= index + 1;
        end else
            dat <= 16'd0;
    end
end

endmodule