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
    assign pij = pik & pik_j;
    assign gij = gik | (pik & gk_1j)
endmodule

module carry_generate(input logic gij, pij, cj_1,
                      output logic cout)
    assign cout = gij | (pij & cj_1);
endmodule 

module gpblk_with_1carry(input logic gik, pik, gk_1j, pk_1j, c0, 
                         output logic gij, pij, c1);
    // This module generates the carry out of the k-1th bit and 
    // block level generate and propogate

    // Step-1: Get block level generate and propogate
    gpblk blk0(.gik(gik), .pik(pik), .gk_1j(pk_1j), .gij(gij), .pij(pij));

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
                            .gij(g1_0), pij.(p1_0), c1.(c1), c2.(c2));

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
                            .gij(g1_0), pij.(p1_0), c1.(c1));

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
    hcla_2bit_2carry hcla_2_bit_32(A[3:2], B[3:2], cout[1], g3_2, p3_2, cout[2]);

    // Generate g3_0 and p3_0
    gpblk gpblk_30(g3_2, p3_2, g1_0, p1_0, g3_0, p3_0);
endmodule 








