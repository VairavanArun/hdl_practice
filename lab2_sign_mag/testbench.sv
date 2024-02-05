module testbench();
	logic [15:0] A, B;
	logic B_in;
	logic [15:0] Diff;
	logic B_out;
	Subtractor_16bit dut(A[15:0], B[15:0], B_in, Diff[15:0], B_out);
	initial begin
		A = 16'h0321; B = 16'h0132; B_in = 0; #60;
		A = 16'hFFFF; B = 16'h0001; B_in = 0; #60;
		A = 16'h0001; B = 16'hFFFF; B_in = 0; #60;
		A = 16'hAAAA; B = 16'h5555; B_in = 0; #60;
		A = 16'h5555; B = 16'hAAAA; B_in = 0; #60;
		A = 16'h8000; B = 16'h7FFF; B_in = 0; #60;
		A = 16'h8000; B = 16'h0001; B_in = 0; #60;
		A = 16'h7FFF; B = 16'h7000; B_in = 0; #60;
	end
endmodule