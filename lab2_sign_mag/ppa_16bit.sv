// This file contains the implementation of 16 bit Parallel Prefix adder
// Parallel Prefix adder implemented is Skanlsky adder
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
    // This module generates the carry out of a block based on 
    // block propogate and generate
    assign cout = gij | (pij & cj_1);
endmodule 

module sum(input logic A,B,Cin,
           output logic Sum);
    // This module generates the sum output of a full adder
    assign Sum = A ^ B ^ Cin;
endmodule

module sum_16bits(input logic [15:0] A, B, Cin,
                  output logic [15:0] Sum);
    // This module generates the 16 bit sum output of a 16 bit adder
    sum sum0(.A(A[0]), .B(B[0]), .Cin(Cin[0]), .Sum(Sum[0]));
    sum sum1(.A(A[1]), .B(B[1]), .Cin(Cin[1]), .Sum(Sum[1]));
    sum sum2(.A(A[2]), .B(B[2]), .Cin(Cin[2]), .Sum(Sum[2]));
    sum sum3(.A(A[3]), .B(B[3]), .Cin(Cin[3]), .Sum(Sum[3]));
    sum sum4(.A(A[4]), .B(B[4]), .Cin(Cin[4]), .Sum(Sum[4]));
    sum sum5(.A(A[5]), .B(B[5]), .Cin(Cin[5]), .Sum(Sum[5]));
    sum sum6(.A(A[6]), .B(B[6]), .Cin(Cin[6]), .Sum(Sum[6]));
    sum sum7(.A(A[7]), .B(B[7]), .Cin(Cin[7]), .Sum(Sum[7]));
    sum sum8(.A(A[8]), .B(B[8]), .Cin(Cin[8]), .Sum(Sum[8]));
    sum sum9(.A(A[9]), .B(B[9]), .Cin(Cin[9]), .Sum(Sum[9]));
    sum sum10(.A(A[10]), .B(B[10]), .Cin(Cin[10]), .Sum(Sum[10]));
    sum sum11(.A(A[11]), .B(B[11]), .Cin(Cin[11]), .Sum(Sum[11]));
    sum sum12(.A(A[12]), .B(B[12]), .Cin(Cin[12]), .Sum(Sum[12]));
    sum sum13(.A(A[13]), .B(B[13]), .Cin(Cin[13]), .Sum(Sum[13]));
    sum sum14(.A(A[14]), .B(B[14]), .Cin(Cin[14]), .Sum(Sum[14]));
    sum sum15(.A(A[15]), .B(B[15]), .Cin(Cin[15]), .Sum(Sum[15]));
endmodule 

module ppa_16_bit_carry_generate(input logic [15:0] A,B,
                                 input logic Cin,
                                 output logic [16:0] Cout);
    // This module generates the carry in 16 bit adder
    // based Parallel prefix adder architecture

    // Level 0: Calculate GP bit for all the 16 bits
    logic [15:0] bit_g, bit_p;
    gpbit gpbit0(.ai(A[0]), .bi(B[0]), .gi(bit_g[0]), .pi(bit_p[0]));
    gpbit gpbit1(.ai(A[1]), .bi(B[1]), .gi(bit_g[1]), .pi(bit_p[1]));
    gpbit gpbit2(.ai(A[2]), .bi(B[2]), .gi(bit_g[2]), .pi(bit_p[2]));
    gpbit gpbit3(.ai(A[3]), .bi(B[3]), .gi(bit_g[3]), .pi(bit_p[3]));
    gpbit gpbit4(.ai(A[4]), .bi(B[4]), .gi(bit_g[4]), .pi(bit_p[4]));
    gpbit gpbit5(.ai(A[5]), .bi(B[5]), .gi(bit_g[5]), .pi(bit_p[5]));
    gpbit gpbit6(.ai(A[6]), .bi(B[6]), .gi(bit_g[6]), .pi(bit_p[6]));
    gpbit gpbit7(.ai(A[7]), .bi(B[7]), .gi(bit_g[7]), .pi(bit_p[7]));
    gpbit gpbit8(.ai(A[8]), .bi(B[8]), .gi(bit_g[8]), .pi(bit_p[8]));
    gpbit gpbit9(.ai(A[9]), .bi(B[9]), .gi(bit_g[9]), .pi(bit_p[9]));
    gpbit gpbit10(.ai(A[10]), .bi(B[10]), .gi(bit_g[10]), .pi(bit_p[10]));
    gpbit gpbit11(.ai(A[11]), .bi(B[11]), .gi(bit_g[11]), .pi(bit_p[11]));
    gpbit gpbit12(.ai(A[12]), .bi(B[12]), .gi(bit_g[12]), .pi(bit_p[12]));
    gpbit gpbit13(.ai(A[13]), .bi(B[13]), .gi(bit_g[13]), .pi(bit_p[13]));
    gpbit gpbit14(.ai(A[14]), .bi(B[14]), .gi(bit_g[14]), .pi(bit_p[14]));
    gpbit gpbit15(.ai(A[15]), .bi(B[15]), .gi(bit_g[15]), .pi(bit_p[15]));

    // Level 1: Generate block level GPs by combining 2 bits
    logic g2_1, p2_1; 
    logic g4_3, p4_3;
    logic g6_5, p6_5;
    logic g8_7, p8_7;
    logic g10_9, p10_9;
    logic g12_11, p12_11;
    logic g14_13, p14_13;

    // Cin is the carry in for bit 0
    assign Cout[0] = Cin;

    // Generate block level gps
    carry_generate carry1(.gij(bit_g[0]), .pij(bit_p[0]), .cj_1(Cin), .cout(Cout[1]));
    gpblk level1_blk1(.gik(bit_g[2]), .pik(bit_p[2]), .gk_1j(bit_g[1]), .pk_1j(bit_p[1]), .gij(g2_1), .pij(p2_1));
    gpblk level1_blk2(.gik(bit_g[4]), .pik(bit_p[4]), .gk_1j(bit_g[3]), .pk_1j(bit_p[3]), .gij(g4_3), .pij(p4_3));
    gpblk level1_blk3(.gik(bit_g[6]), .pik(bit_p[6]), .gk_1j(bit_g[5]), .pk_1j(bit_p[5]), .gij(g6_5), .pij(p6_5));
    gpblk level1_blk4(.gik(bit_g[8]), .pik(bit_p[8]), .gk_1j(bit_g[7]), .pk_1j(bit_p[7]), .gij(g8_7), .pij(p8_7));
    gpblk level1_blk5(.gik(bit_g[10]), .pik(bit_p[10]), .gk_1j(bit_g[9]), .pk_1j(bit_p[9]), .gij(g10_9), .pij(p10_9));
    gpblk level1_blk6(.gik(bit_g[12]), .pik(bit_p[12]), .gk_1j(bit_g[11]), .pk_1j(bit_p[11]), .gij(g12_11), .pij(p12_11));
    gpblk level1_blk7(.gik(bit_g[14]), .pik(bit_p[14]), .gk_1j(bit_g[13]), .pk_1j(bit_p[13]), .gij(g14_13), .pij(p14_13));


    // Level 2: Generate Block level GPs by combining 4 bits
    logic g5_3, p5_3;
    logic g6_3, p6_3;
    logic p9_7, g9_7;
    logic p10_7, g10_7;
    logic g13_11, p13_11;
    logic g14_11, p14_11;

    carry_generate carry2(.gij(bit_g[1]), .pij(bit_p[1]), .cj_1(Cout[1]), .cout(Cout[2]));
    carry_generate carry3(.gij(g2_1), .pij(p2_1), .cj_1(Cout[1]), .cout(Cout[3]));
    gpblk level2_blk1(.gik(bit_g[5]), .pik(bit_p[5]), .gk_1j(g4_3), .pk_1j(p4_3), .gij(g5_3), .pij(p5_3));
    gpblk level2_blk2(.gik(g6_5), .pik(p6_5), .gk_1j(g4_3), .pk_1j(p4_3), .gij(g6_3), .pij(p6_3));
    gpblk level2_blk3(.gik(bit_g[9]), .pik(bit_p[9]), .gk_1j(g8_7), .pk_1j(p8_7), .gij(g9_7), .pij(p9_7));
    gpblk level2_blk4(.gik(g10_9), .pik(p10_9), .gk_1j(g8_7), .pk_1j(p8_7), .gij(g10_7), .pij(p10_7));
    gpblk level2_blk5(.gik(bit_g[13]), .pik(bit_p[13]), .gk_1j(g12_11), .pk_1j(p12_11), .gij(g13_11), .pij(p13_11));
    gpblk level2_blk6(.gik(g14_13), .pik(p14_13), .gk_1j(g12_11), .pk_1j(p12_11), .gij(g14_11), .pij(p14_11));

    // Level 3: Generate Block level GPs by combining 8 bits
    logic g11_7, p11_7;
    logic g12_7, p12_7;
    logic g13_7, p13_7;
    logic g14_7, p14_7;

    carry_generate carry4(.gij(bit_g[3]), .pij(bit_p[3]), .cj_1(Cout[3]), .cout(Cout[4]));
    carry_generate carry5(.gij(g4_3), .pij(p4_3), .cj_1(Cout[3]), .cout(Cout[5]));
    carry_generate carry6(.gij(g5_3), .pij(p5_3), .cj_1(Cout[3]), .cout(Cout[6]));
    carry_generate carry7(.gij(g6_3), .pij(p6_3), .cj_1(Cout[3]), .cout(Cout[7]));
    gpblk level3_blk1(.gik(bit_g[11]), .pik(bit_p[11]), .gk_1j(g10_7), .pk_1j(p10_7), .gij(g11_7), .pij(p11_7));
    gpblk level3_blk2(.gik(g12_11), .pik(p12_11), .gk_1j(g10_7), .pk_1j(p10_7), .gij(g12_7), .pij(p12_7));
    gpblk level3_blk3(.gik(g13_11), .pik(p13_11), .gk_1j(g10_7), .pk_1j(p10_7), .gij(g13_7), .pij(p13_7));
    gpblk level3_blk4(.gik(g14_11), .pik(p14_11), .gk_1j(g10_7), .pk_1j(p10_7), .gij(g14_7), .pij(p14_7));

    //Level 4: Final level - Generate all carry outs
    carry_generate carry8(.gij(bit_g[7]), .pij(bit_p[7]), .cj_1(Cout[7]), .cout(Cout[8]));
    carry_generate carry9(.gij(g8_7), .pij(p8_7), .cj_1(Cout[7]), .cout(Cout[9]));
    carry_generate carry10(.gij(g9_7), .pij(p9_7), .cj_1(Cout[7]), .cout(Cout[10]));
    carry_generate carry11(.gij(g10_7), .pij(p10_7), .cj_1(Cout[7]), .cout(Cout[11]));
    carry_generate carry12(.gij(g11_7), .pij(p11_7), .cj_1(Cout[7]), .cout(Cout[12]));
    carry_generate carry13(.gij(g12_7), .pij(p12_7), .cj_1(Cout[7]), .cout(Cout[13]));
    carry_generate carry14(.gij(g13_7), .pij(p13_7), .cj_1(Cout[7]), .cout(Cout[14]));
    carry_generate carry15(.gij(g14_7), .pij(p14_7), .cj_1(Cout[7]), .cout(Cout[15]));

    // Final Cout Generation
    carry_generate carry16(.gij(bit_g[15]), .pij(bit_p[15]), .cj_1(Cout[15]), .cout(Cout[16]));

endmodule

module ppa_16bit(input logic [15:0] A, B,
                 input logic Cin, 
                 output logic [15:0] Sum,
                 output logic Cout);
    // Generate carry for all 16 bits
    logic [16:0] carry_out;
    ppa_16_bit_carry_generate carry_gen(.A(A),.B(B), .Cin(Cin), .Cout(carry_out));

    // Generate sum for all 16 bits
    sum_16bits sum_16bits(.A(A), .B(B), .Cin(carry_out[15:0]), .Sum(Sum));

    assign Cout = carry_out[16];
endmodule 

