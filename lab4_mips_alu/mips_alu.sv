/*
 * This file contains the ALU implementation for MIPS architecture
 * ALU can perform ADD, SUB, AND, OR, SLT
 */

module and_32bit(input logic [31:0] A,B,
                 output logic [31:0] Y);
    assign Y = A & B;
endmodule

module or_32bit(input logic [31:0] A,B,
                 output logic [31:0] Y);
    assign Y = A | B;
endmodule

module mips_alu(input logic [31:0]  A, B,
                input logic [2:0]   F,
                output logic [31:0] Y,
                output logic        Zero);

    logic [31:0] D0, D1, D2, D3;
    logic [31:0] negated_B;
    logic Cout;

    assign negated_B = F[2] ? (~B):B;

    //instantiate and module
    and_32bit and_circ(A, B, D0);
    //instantiate or module
    or_32bit or_circ(A, B, D1);
    //instantiate adder
    ppa_32bit adder(A, B, F[2], D2, Cout);

    assign Zero = (Y == 32'b0) ? 1'b1 : 1'b0;

    //get the output of the ALU
    always_comb
        begin : ALU_output_block
            case (F[1:0])
                2'b00: Y = D0; 
                2'b01: Y = D1;
                2'b10: Y = D2;
                2'b11: Y = D3;
            endcase
        end


endmodule 