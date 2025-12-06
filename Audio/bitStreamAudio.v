module bitStreamAudio (
    input  wire        clk,
    input  wire        sample_req,
    input  wire [3:0]  enable_mask,
    output reg  [15:0] audio_output
);
	// for this to work, SAMPLE_COUNT must equal 32768; you can change it for tb

    parameter SAMPLE_COUNT = 100;

    reg signed [15:0] clip0 [0:SAMPLE_COUNT-1];
    reg signed [15:0] clip1 [0:SAMPLE_COUNT-1];
    reg signed [15:0] clip2 [0:SAMPLE_COUNT-1];
    reg signed [15:0] clip3 [0:SAMPLE_COUNT-1];

    initial begin
        $readmemh("RboomboomBigEndian.txt", clip0);
        $readmemh("RpowmpowmBigEndian.txt", clip1);
        $readmemh("RlalaBigEndian.txt", clip2);
        $readmemh("RpshhpshhBigEndian.txt", clip3);
    end

    reg [17:0] index = 0;
    reg signed [20:0] mix_accum;

    // Saturation to 16-bit
    function signed [15:0] clip16;
        input signed [20:0] x;
        begin
            if (x > 32767)
                clip16 = 32767;
            else if (x < -32768)
                clip16 = -32768;
            else
                clip16 = x[15:0];
        end
    endfunction

    always @(posedge clk) begin
        if (sample_req) begin

            mix_accum = 0;

            if (enable_mask[0]) mix_accum = mix_accum + clip0[index];
            if (enable_mask[1]) mix_accum = mix_accum + clip1[index];
            if (enable_mask[2]) mix_accum = mix_accum + clip2[index];
            if (enable_mask[3]) mix_accum = mix_accum + clip3[index];

            audio_output <= clip16(mix_accum);

            if (index == SAMPLE_COUNT - 1)
                index <= 0;
            else
                index <= index + 1;
        end
    end

endmodule