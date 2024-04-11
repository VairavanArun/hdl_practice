module overflow(
	input logic A,B,
	input logic [2:0] F,
	input logic S,
	output logic OF,SLT);
	logic X1,Xn1,check,OF_int;
	logic [31:0] D2;
	//assign nB = F[2] ? (~B):B;
	//ppa_32bit adder1(A, B, F[2], D2, Cout);
	//assign S = D2;
	assign  check =  (F[1] & (~F[0]));
	assign Xn1 = ~(F[2] ^ A ^ B);
	assign X1 = S ^ A;
	assign OF_int =  X1 & Xn1;
	assign OF = OF_int & check;
	assign SLT= (S ^ OF_int );
endmodule
