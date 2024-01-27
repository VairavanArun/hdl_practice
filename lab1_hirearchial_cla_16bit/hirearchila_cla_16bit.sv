// This file contains the implementation of a 16 bit hirearchical CLA in structural modelling

module gpbit(input logic ai, bi,
             output logic gi, pi);
    // This module generates generate and propogate for the given bit
    assign gi = ai & bi;
    assign pi = ai | bi;
endmodule 

module gpblk(input logic gik, pik, gk_1j, pk_1j,
             output logic gij, pij);
    // This module generates block level generate and propogate bits
    assign pij = pik & pk_1j;
    assign gij = gik | (pik & gk_1j);
endmodule

module carry_generate(input logic gij, pij, cj_1,
                      output logic cout);
    assign cout = gij | (pij & cj_1);
endmodule 

module gpblk_with_1carry(input logic gik, pik, gk_1j, pk_1j, c0, 
                         output logic gij, pij, c1);
    // This module generates the carry out of the k-1th bit and 
    // block level generate and propogate

    // Step-1: Get block level generate and propogate
    gpblk blk0(.gik(gik), .pik(pik), .gk_1j(gk_1j), .pk_1j(pk_1j), .gij(gij), .pij(pij));

    // Step-2: Generate carry out of the k-1th bit
    carry_generate carry(.gij(gk_1j), .pij(pk_1j), .cj_1(c0), .cout(c1));
endmodule 

module gpblk_with_2carry(input logic gik, pik, gk_1j, pk_1j, c0, 
                         output logic gij, pij, c1, c2);
    // This module generates the carry out of k-1th bit and ith bit
    // and block level generate and propogate

    // Step-1: Get block level generate and propogate and carry out of
    // k-1th bit
    gpblk_with_1carry blk0(.gik(gik), .pik(pik), .gk_1j(gk_1j), .pk_1j(pk_1j), .c0(c0),
                           .gij(gij), .pij(pij), .c1(c1));

    // Get carry out of ith bit
    carry_generate carry(.gij(gij), .pij(pij), .cj_1(c0), .cout(c2));
endmodule 


module hcla_2bit_2carry(input logic [1:0]A,B,
                 input logic c0,
                 output logic g1_0, p1_0, c2, c1);
    // This module generates the block level generate and propogate for 2 bits
    // and also generates the carry out from the two bits
    
    //Create intermediate logics for bit level generate and propogate
    logic g00, p00, g11, p11;

    // Get bit level generate and propogate
    gpbit gpbit0(.ai(A[0]), .bi(B[0]), .gi(g00), .pi(p00));
    gpbit gpbit1(.ai(A[1]), .bi(B[1]), .gi(g11), .pi(p11));

    // Get block level generate and propogate with 2 carry outs
    gpblk_with_2carry gpblk(.gik(g11), .pik(p11), .gk_1j(g00), .pk_1j(p00), .c0(c0),
                            .gij(g1_0), .pij(p1_0), .c1(c1), .c2(c2));

endmodule

module xor2(input logic A, B,
           output logic Y);
    assign Y = A ^ B;
endmodule

module xnor2(input logic A, B,
            output logic Y);
    assign Y = ~(A ^ B);
endmodule

module hcla_2bit_1carry(input logic [1:0]A,B,
                 input logic c0,
                 output logic g1_0, p1_0, c1);
    // This module generates the block level generate and propogate for 2 bits
    // and also generates the carry out from the LSB 
    
    //Create intermediate logics for bit level generate and propogate
    logic g00, p00, g11, p11;

    // Get bit level generate and propogate
    gpbit gpbit0(.ai(A[0]), .bi(B[0]), .gi(g00), .pi(p00));
    gpbit gpbit1(.ai(A[1]), .bi(B[1]), .gi(g11), .pi(p11));

    // Get block level generate and propogate with 2 carry outs
    gpblk_with_1carry gpblk_10(.gik(g11), .pik(p11), .gk_1j(g00), .pk_1j(p00), .c0(c0),
                            .gij(g1_0), .pij(p1_0), .c1(c1));

endmodule

module hcla_4bit(input logic [3:0]A, B,
                 input logic c0,
                 output logic g3_0, p3_0,
                 output logic [2:0]cout);
    // This module generates the generate and propogate of a 4 bit block and 
    // the carry in for 1st,2nd and 3rd bit

    logic g10, p10, g32, p32;

    // Generate g10, p10, c1, c2
    hcla_2bit_2carry hcla_2bit_10(A[1:0], B[1:0], c0, g1_0, p1_0, cout[1], cout[0]); 
    // Generate g32, p32, c3
    hcla_2bit_1carry hcla_2_bit_32(A[3:2], B[3:2], cout[1], g3_2, p3_2, cout[2]);

    // Generate g3_0 and p3_0
    gpblk gpblk_30(g3_2, p3_2, g1_0, p1_0, g3_0, p3_0);
endmodule 

module hcla_8bit(input logic [7:0]A, B,
                 input logic c0,
                 output logic g7_0, p7_0,
                 output logic [6:0]cout);
    // This module generates the generate and propogate of 8 bit block and
    // the carry in for bits 1 through 7

    logic g3_0, p3_0, g7_4, p7_4;

    hcla_4bit hcla_4bit_3_0(A[3:0], B[3:0], c0, g3_0, p3_0, cout[2:0]);
    hcla_4bit hcla_4bit_7_4(A[7:4], B[7:4], cout[3], g7_4, p7_4, cout[6:4]);

    // Generate C4: cout[3]
    carry_generate carry(.gij(g3_0), .pij(p3_0), .cj_1(c0), .cout(cout[3]));

    // Genreate g7_0 and p7_0
    gpblk gpblk_7_0(g7_4, p7_4, g3_0, p3_0, g7_0, p7_0);

endmodule 


module hcla_16bit(input logic [15:0]A, B,
                  input logic c0,
                  output logic [15:0]cout);
    // This module generates the carry in for bits 1 through 15 using HCLA logic

    // Create wires for intermediate generate and propogate
    logic g7_0, p7_0, g15_8, p15_8;
    logic g15_0, p15_0;

    hcla_8bit hcla_8bit_7_0(A[7:0], B[7:0], c0, g7_0, p7_0, cout[6:0]);
    hcla_8bit hcla_8bit_15_8(A[15:8], B[15:8], cout[7], g15_8, p15_8, cout[14:8]);

    // Generate C8: cout[7]
    carry_generate carry7(.gij(g7_0), .pij(p7_0), .cj_1(c0), .cout(cout[7]));

    // Genreate g15_0 and p15_0
    gpblk gpblk_15_0(g15_8, p15_8, g7_0, p7_0, g15_0, p15_0);

    // Generate Carry out of the 16 bit addition
    carry_generate carry15(.gij(g15_0), .pij(p15_0), .cj_1(c0), .cout(cout[15]));
endmodule

module sum(input logic A,B,Cin,
           output logic Sum);
    assign Sum = A ^ B ^ Cin;
endmodule

module overflow_sum(input logic a_sign, b_sign, sum_sign,
                    output logic OF_S);
    // This module generates the overflow for sum based on signs of
    // a, b and sum
    logic a_xnor_b, a_xor_sum;
    xnor2 xnor1(a_sign, b_sign, a_xnor_b);
    xor2 xor1(a_sign, sum_sign, a_xor_sum);

    assign OF_S = a_xnor_b & a_xor_sum;

endmodule

module overflow_diff(input logic a_sign, b_sign, diff_sign,
                    output logic OF_D);
    // This module generates the overflow for difference based on signs of
    // a, b and diff
    logic a_xor_b, a_xor_sum;
    xor2 xor1(a_sign, b_sign, a_xor_b);
    xor2 xor2(b_sign, diff_sign, a_xor_sum);

    assign OF_D = a_xor_b & a_xor_sum;
endmodule


module hcla_add_16bit(input logic [15:0] A,B,
                      output logic [15:0] sum,
                      output logic OF_S);
    
    logic [15:0]carry;

    hcla_16bit carry_generation(A, B, 1'b0, carry);

    sum s0(A[0], B[0], 1'b0, sum[0]);
    sum s1(A[1], B[1], carry[0], sum[1]);
    sum s2(A[2], B[2], carry[1], sum[2]);
    sum s3(A[3], B[3], carry[2], sum[3]);
    sum s4(A[4], B[4], carry[3], sum[4]);
    sum s5(A[5], B[5], carry[4], sum[5]);
    sum s6(A[6], B[6], carry[5], sum[6]);
    sum s7(A[7], B[7], carry[6], sum[7]);
    sum s8(A[8], B[8], carry[7], sum[8]);
    sum s9(A[9], B[9], carry[8], sum[9]);
    sum s10(A[10], B[10], carry[9], sum[10]);
    sum s11(A[11], B[11], carry[10], sum[11]);
    sum s12(A[12], B[12], carry[11], sum[12]);
    sum s13(A[13], B[13], carry[12], sum[13]);
    sum s14(A[14], B[14], carry[13], sum[14]);
    sum s15(A[15], B[15], carry[14], sum[15]);

    overflow_sum of_s(A[15], B[15], sum[15], OF_S);
endmodule

module hcla_sub_16bit(input logic [15:0] A,B,
                      output logic [15:0] diff,
                      output logic OF_D);
    
    logic [15:0]carry;
    logic [15:0]not_B; //This has the negated value of B_in

    assign not_B = ~B;

    hcla_16bit carry_generation(A, not_B, 1'b1, carry);

    sum s0(A[0], not_B[0], 1'b1, diff[0]);
    sum s1(A[1], not_B[1], carry[0], diff[1]);
    sum s2(A[2], not_B[2], carry[1], diff[2]);
    sum s3(A[3], not_B[3], carry[2], diff[3]);
    sum s4(A[4], not_B[4], carry[3], diff[4]);
    sum s5(A[5], not_B[5], carry[4], diff[5]);
    sum s6(A[6], not_B[6], carry[5], diff[6]);
    sum s7(A[7], not_B[7], carry[6], diff[7]);
    sum s8(A[8], not_B[8], carry[7], diff[8]);
    sum s9(A[9], not_B[9], carry[8], diff[9]);
    sum s10(A[10], not_B[10], carry[9], diff[10]);
    sum s11(A[11], not_B[11], carry[10], diff[11]);
    sum s12(A[12], not_B[12], carry[11], diff[12]);
    sum s13(A[13], not_B[13], carry[12], diff[13]);
    sum s14(A[14], not_B[14], carry[13], diff[14]);
    sum s15(A[15], not_B[15], carry[14], diff[15]);

    overflow_diff of_d(A[15], B[15], diff[15], OF_D);
endmodule

module less_than_check(input logic diff_sign, of_d,
                 output logic less_than);
    // THis module checks if A is less than B using difference and
    // overflow of the subtractor
    // A < B when difference is negative(diff_sign = 1) and there is no overflow(of_d = 0)
    // and when difference is positive(diff_sign = 0) and there is overflow(of_d = 1)
    xor2 xor_lessthan(diff_sign, of_d, less_than);
endmodule 

module arithmetic_unit(input logic  [15:0] A, B,
                       output logic [15:0] Sum, Diff,
                       output logic        OF_S, OF_D, LessThan);
    // This module generates the sum, difference, overflow flags for addition and subtraction
    // Instantiate the adder module
    hcla_add_16bit adder(A, B, Sum, OF_S);
    // Instatiate the subtractor module
    hcla_sub_16bit subtractor(A, B, Diff, OF_D);
    // Instantiate the LessThan circuit
    less_than_check less_than(Diff[15], OF_D, LessThan);

endmodule











