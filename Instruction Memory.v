module IMEM (
    input  wire [5:0]  addr,
    output wire [15:0] instr
);

    reg [15:0] mem [0:63];

    assign instr = mem[addr];

    initial begin
        // addr : instruction                      : description & verification check
        mem[0]  = 16'b0100_0000_0101_0000; // LOADI R0, 5                -> R0 = 5
        mem[1]  = 16'b0101_0000_0011_0000; // LOADI R1, 3                -> R1 = 3
        mem[2]  = 16'b0000_0010_0001_0000; // ADD   R2, R0, R1           -> R2 = 8
        mem[3]  = 16'b0000_0111_0001_0000; // SUB   R3, R0, R1           -> R3 = 2
        mem[4]  = 16'b1001_1011_0000_1110; // BEQ   R2, R3, done (tgt=14)-> NOT TAKEN (8 != 2) -> advances to 5
        mem[5]  = 16'b0011_1011_0001_0000; // XOR   R3, R0, R1           -> R3 = 5 ^ 3 = 6 (Logic)
        mem[6]  = 16'b1010_0001_0000_1000; // BNE   R0, R1, skip1 (tgt=8)-> IS TAKEN (5 != 3) -> jumps to 8
        mem[7]  = 16'b0100_0110_0011_0000; // LOADI R0, 99               -> SKIPPED
        mem[8]  = 16'b1010_0101_0000_1110; // skip1: BNE R1, R1, done   -> BNE NOT TAKEN (3 != 3 is false) -> advances to 9
        mem[9]  = 16'b1001_0000_0000_1011; // BEQ   R0, R0, skip2 (tgt=11)-> BEQ TAKEN (5 == 5 is true) -> jumps to 11
        mem[10] = 16'b0101_0110_0011_0000; // LOADI R1, 99               -> SKIPPED
        mem[11] = 16'b0000_1100_0110_0000; // skip2: MUL R0, R1, R2     -> R0 = 3 * 8 = 24
        mem[12] = 16'b1000_0000_0000_1110; // JMP   done (tgt=14)        -> JMP to 14
        mem[13] = 16'b0110_0110_0011_0000; // LOADI R2, 99               -> SKIPPED (Trap)
        mem[14] = 16'b1100_0000_0000_0000; // done: HALT                 -> Freezes PC at 14
    end
//we expect at the end R0=24, R1=3, R2=8, R3=6

endmodule
