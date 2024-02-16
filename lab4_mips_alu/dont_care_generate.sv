/*
 * This file contains the system verilog code for generating the don't care
 * bits for the approximate pattern match circuit
 * The don't care generate circuit is nothing but a decoder with an enable
 * signal. Decoder with an enable signal can also be considered as a 
 * demultiplexer 
 */

module dont_care_generate
    #(parameter N = 2)
     (input logic [N - 1 : 0] a,
      input logic             en,
      output logic [2**N - 1 : 0] dont_care);

    always_comb 
        begin : decoder_block
            //Check if decoder is enabled
            if (en)
                begin
                    dont_care = 0;
                    dont_care[a] = 1'b1;
                end
            else
                dont_care = 0;
        end
endmodule
