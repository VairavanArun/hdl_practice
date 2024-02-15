/*
 * This file contains the ALU implementation for MIPS architecture
 * ALU can perform ADD, SUB, AND, OR, SLT
 */

module mips_alu(input logic [31:0]  A, B,
                input logic [2:0]   F,
                output logic [31:0] Y,
                output logic        Zero);

    logic [31:0] D0, D1, D2, D3;
    logic [31:0] negated_B;
    logic Cout;

    assign negated_B = F[2] ? (~B):B;

    //instantiate adder
    ppa_32bit adder(A, B, F[2], D2, Cout);

    assign D0 = A & negated_B;
    assign D1 = A | negated_B;
    assign D3 = {31'b0, D2[31]};

    //get the output of the ALU
    assign Y = F[1] ? (F[0] ? D3 : D2) : (F[0] ? D1 : D0);


endmodule 