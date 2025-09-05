`timescale 1ns / 1ps
module ALU_tb();

  // inputs to ALU
  reg [15:0] input1, input2;
  reg [7:0] opcode;

  // outputs from ALU
  wire [15:0] actualOutput;
  wire [4:0] flags;

  // alu instantiation
  alu k(.R1(input1), .R2(input2), .opcode(opcode), .aluOut(actualOutput), .flags(flags));

  initial begin
    // initialize
    input1 = 0;
    input2 = 0;
    opcode = 0;

    // nice aligned monitor
    $monitor("I1: %016b I2: %016b OP: %08b Out: %016b Flags: %05b",
             input1, input2, opcode, actualOutput, flags);

    // ADD
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00000101;
    #1  $strobe("   -> expected: %016b (ADD)", input1 + input2);

    // AND
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00000001;
    #1  $strobe("   -> expected: %016b (AND)", input1 & input2);

    // OR
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00000010;
    #1  $strobe("   -> expected: %016b (OR)", input1 | input2);

    // XOR
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00000011;
    #1  $strobe("   -> expected: %016b (XOR)", input1 ^ input2);

    // MOV
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00001101;
    #1  $strobe("   -> expected: %016b (MOV)", input1);

    // LSH
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00001000;
    #1  $strobe("   -> expected: %016b (LSH)", input2 << input1);

    // ASHU
    #10 input1 = $random % 8;
        input2 = $random % 8;
        opcode = 8'b00001111;
    #1  $strobe("   -> expected: %016b (ASHU)", input2 >>> input1);
	 
	 #10

    $finish;
  end
endmodule
