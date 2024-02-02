module Subtractor_Blk(
	//Input and output logic
	input logic A, B, B_in,
	output logic Diff, B_out);
	//Logic gates for circuit
	logic A_prime, a, b, c, c_prime, d, e, f;
	//Assign gates to inputs and outputs
	assign b = B ^ B_in;
	assign a = A ^ b;
	assign c = A ^ B;
	assign c_prime = ~c;
	assign d = c_prime & B_in;
	assign A_prime = ~A;
	assign e = A_prime & B;
	assign f = d | e;
	assign Diff = A ^ b;
	assign B_out = f;
endmodule //Subtractor-Blk

module Subtractor_8bit(
	//Inputs and outputs. A, B, and Diff are 8 bits
	//while B_in and B_out are 1 bit
	input logic [7:0] A, B, 
	input logic B_in,
	output logic [7:0] Diff,
	output logic B_out);

	logic [7:0] B_out_block;
	//Heirarchical structural programming for
	//8 bit subtractor
	Subtractor_Blk sub_0(A[0], B[0], B_in,
	Diff[0], B_out_block[0]);

	Subtractor_Blk sub_1(A[1], B[1], B_out_block[0],
	Diff[1], B_out_block[1]);

	Subtractor_Blk sub_2(A[2], B[2], B_out_block[1],
	Diff[2], B_out_block[2]);

	Subtractor_Blk sub_3(A[3], B[3], B_out_block[2],
	Diff[3], B_out_block[3]);

	Subtractor_Blk sub_4(A[4], B[4], B_out_block[3],
	Diff[4], B_out_block[4]);

	Subtractor_Blk sub_5(A[5], B[5], B_out_block[4],
	Diff[5], B_out_block[5]);

	Subtractor_Blk sub_6(A[6], B[6], B_out_block[5],
	Diff[6], B_out_block[6]);

	Subtractor_Blk sub_7(A[7], B[7], B_out_block[6],
	Diff[7], B_out_block[7]);

	assign B_out = B_out_block[7];
	
endmodule //Subtractor_8bit

module Subtractor_16bit(
	//Inputs and outputs. A, B, and Diff are 16 bits
	//while B_in and B_out are 1 bit
	input logic [15:0] A, B,
	input logic B_in,
	output logic [15:0] Diff,
	output logic B_out);
	logic B_out_block_7_to_0;
	//B_out_block[0] is B_in
	// assign B_out_block[0] = B_in;
	//Heirarchical structural programming for
	//16 bit subtractor
	Subtractor_8bit sub_8bit_0(A[7:0], B[7:0], B_in,
	Diff[7:0], B_out_block_7_to_0);

	Subtractor_8bit sub_8bit_1(A[15:8], B[15:8], B_out_block_7_to_0,
	Diff[15:8], B_out);
endmodule //Subtractor_16bit	
