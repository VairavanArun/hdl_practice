/*
 * This file contains the code to implement a pattern matching
 * circuit with dont cares
 */

module pattern_match(input logic [31:0] A,B,
                     output logic [31:0] Y);
    //generate dont cares
    logic [3:0] dont_care;
    dont_care_generate dont_care_gen_circ(B[5:4], B[6], dont_care);

    //start pattern matching
    generate
        genvar i;
        for (i = 0; i <= 28; i = i + 1) begin : appx_match_for_block
            appx_match appx_match_check_circ(A[i+3:i], B[3:0], dont_care, Y[i]);
		  end
    endgenerate

    //assing the last 4 bits of output to 0
    assign Y[31:29] = 4'b0;

endmodule