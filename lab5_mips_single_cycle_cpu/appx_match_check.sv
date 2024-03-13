/*
 * This file checks approximate matching of a 4 bit pattern
 * One of the 4 bits can be a dont care
 */

module mux2_1(input logic s,a,b,
              output logic y);
    assign y = s ? b : a;
endmodule

module exact_match(input logic a,b,
                   output logic y);
    assign y = ~(a ^ b);
endmodule

module appx_match(input logic [3:0] a, b, dont_care,
                  output logic pattern_match);

    logic exact_match0, exact_match1, exact_match2, exact_match3;
    logic appx_match0, appx_match1, appx_match2, appx_match3;

    //get exact match
    exact_match match0(a[0], b[0], exact_match0);
    exact_match match1(a[1], b[1], exact_match1);
    exact_match match2(a[2], b[2], exact_match2);
    exact_match match3(a[3], b[3], exact_match3);

    //get appx match
    mux2_1 appx_match_0(dont_care[0], exact_match0, 1'b1, appx_match0);
    mux2_1 appx_match_1(dont_care[1], exact_match1, 1'b1, appx_match1);
    mux2_1 appx_match_2(dont_care[2], exact_match2, 1'b1, appx_match2);
    mux2_1 appx_match_3(dont_care[3], exact_match3, 1'b1, appx_match3);

    assign pattern_match = appx_match0 & appx_match1 & appx_match2 & appx_match3;

endmodule