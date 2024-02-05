module bit_comparator(
	input logic ai, bi,nextcheck,
	output logic less_than, nextbit);
	logic greater;
	assign greater = ~bi & ai;
    assign less_than = ~ai & bi & nextcheck;
    assign nextbit = ~(less_than | greater) & nextcheck ;
endmodule

module  comparator(
	input logic [16:0]ai, bi,
	output logic isLess); 
    logic [15:0]less_than, nextbit;
    bit_comparator compare15(ai[15],bi[15],1'b1 ,less_than[15],nextbit[15]);
    bit_comparator compare14(ai[14],bi[14],nextbit[15],less_than[14],nextbit[14]);//,greater[14],equal[14]);
    bit_comparator compare13(ai[13],bi[13],nextbit[14],less_than[13],nextbit[13]);//,greater[13],equal[13]);
    bit_comparator compare12(ai[12],bi[12],nextbit[13],less_than[12],nextbit[12]);//,greater[12],equal[12]);
    bit_comparator compare11(ai[11],bi[11],nextbit[12],less_than[11],nextbit[11]);//,greater[11],equal[11]);
    bit_comparator compare10(ai[10],bi[10],nextbit[11],less_than[10],nextbit[10]);//,greater[10],equal[10]);
    bit_comparator compare9(ai[9],bi[9],nextbit[10],less_than[9],nextbit[9]);//,greater[9],equal[9]);
    bit_comparator compare8(ai[8],bi[8],nextbit[9],less_than[8],nextbit[8]);//,greater[8],equal[8]);
    bit_comparator compare7(ai[7],bi[7],nextbit[8],less_than[7],nextbit[7]);//,greater[7],equal[7]);
    bit_comparator compare6(ai[6],bi[6],nextbit[7],less_than[6],nextbit[6]);//,greater[6],equal[6]);
    bit_comparator compare5(ai[5],bi[5],nextbit[6],less_than[5],nextbit[5]);//,greater[5],equal[5]);
    bit_comparator compare4(ai[4],bi[4],nextbit[5],less_than[4],nextbit[4]);//,greater[4],equal[4]);
    bit_comparator compare3(ai[3],bi[3],nextbit[4],less_than[3],nextbit[3]);//,greater[3],equal[3]);
    bit_comparator compare2(ai[2],bi[2],nextbit[3],less_than[2],nextbit[2]);//,greater[2],equal[2]);
    bit_comparator compare1(ai[1],bi[1],nextbit[2],less_than[1],nextbit[1]);//,greater[1],equal[1]);
    bit_comparator compare0(ai[0],bi[0],nextbit[1],less_than[0],nextbit[0]);//,greater[0],equal[0]);
    assign isLess = less_than[15] | less_than[14] | less_than[13] | less_than[12] | less_than[11] | less_than[10] | less_than[9] | less_than[8] | less_than[7] | less_than[6] | less_than[5] | less_than[4] | less_than[3] | less_than[2] | less_than[1] | less_than[0];
endmodule

module signBit(
	input logic [16:0]a,b,
	input logic op,
	output logic signBit,actual_operation);
	comparator c1(a,b, isLess);
	assign signBit = (a[16] & ~isLess) | (op & ~b[16] & isLess) | (~op & b[16] & isLess);
	assign actual_operation = (~b[16] & ((~op & a[16])+(op & ~a[16]))) | (b[16] & ((~op & ~a[16]) | (op & a[16])));

endmodule

module new_input(
	input logic [16:0]a,b,
	input logic op,
	output logic signBit,actual_operation,
	output logic [16:0]a_new,b_new);
	logic [3:0]c;
	comparator c2(a,b, isLess);
	signBit sign1(a,b,op,signBit,actual_operation);
	assign c[3]=op;
	assign c[2]=a[16];
	assign c[1]=b[16];
	assign c[0]=isLess;
	always_comb 
	 begin
	  case(c)
	    4'b0011 : begin 
			 a_new = b;
			 b_new = a;
		      end
	    4'b0101 : begin 
			 a_new = b;
			 b_new = a;
		      end
	    4'b1001 : begin 
			 a_new = b;
			 b_new = a;
		      end
	    4'b1111 : begin 
			 a_new = b;
			 b_new = a;
		      end
	    default : begin
			 a_new = a;
			 b_new = b;
		      end
	  endcase
	 end
endmodule
module final_operation(
	input logic [16:0]a,b,
	input logic op,
	output logic [16:0]Y,
	output logic OF);
	logic bout,cout;
	logic [15:0]sum,diff;
	logic [16:0]a_new,b_new;
	new_input n1(a,b,op,signBit,actual_operation,a_new,b_new);
	ppa_16bit add(a_new[15:0],b_new[15:0],1'b0,sum,cout);
	Subtractor_16bit sub(a_new[15:0],b_new[15:0],1'b0,diff,bout);
	assign Y[15:0]=actual_operation?diff:sum ;
	assign OF=actual_operation?bout:cout;
	assign Y[16]=signBit;
endmodule