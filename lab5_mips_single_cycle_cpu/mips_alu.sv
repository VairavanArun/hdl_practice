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

module mux4to1(input logic [31:0] D0, D1, D2, D3,
               input logic [1:0] S,
               output logic [31:0] Y);

    always_comb
        begin : ALU_output_block
            case (S)
                2'b00: Y = D0; 
                2'b01: Y = D1;
                2'b10: Y = D2;
                2'b11: Y = D3;
            endcase
        end

endmodule

module mips_alu(input logic [31:0]  A, B,
                input logic [2:0]   F,
                output logic [31:0] Y,
                output logic        Zero,OF);

    logic [31:0] D0, D1, D2, D3;
    logic [31:0] negated_B;
    logic [31:0] pattern_match_out;
    logic Cout;
    logic SLT;
    assign negated_B = F[2] ? (~B):B;

    assign D3 = F[2] ? {31'b0, SLT} : pattern_match_out; 

    //instantitate pattern match module
    pattern_match pattern_match_circ(A, B, pattern_match_out);
    //instantiate and module
    and_32bit and_circ(A, negated_B, D0);
    //instantiate or module
    or_32bit or_circ(A, negated_B, D1);
    //instantiate adder
    ppa_32bit adder(A, negated_B, F[2], D2, Cout);

    //get the output of the ALU
    mux4to1 multiplexer(D0, D1, D2, D3, F[1:0], Y);
    overflow of(A[31],B[31],F,D2[31],OF,SLT);
    assign Zero = (Y == 32'b0) ? 1'b1 : 1'b0;
    
endmodule 
