/*
 * This file contains the system verilog code to implement
 * Content Addressable Memory
 */


//register file
module register_file(input logic clk, init,
                     input logic [3:0] write_data,
                     input logic [7:0] en,
                     output logic [3:0] r[7:0]);
    
    always @(posedge clk, posedge init) begin
        if (init) begin
            r[0] <= 4'b1000;
            r[1] <= 4'b1001;
            r[2] <= 4'b1010;
            r[3] <= 4'b1011;
            r[4] <= 4'b1100;
            r[5] <= 4'b1101;
            r[6] <= 4'b1110;
            r[7] <= 4'b1111;
        end else begin
            if (en[0]) r[0] <= write_data;
            if (en[1]) r[1] <= write_data;
            if (en[2]) r[2] <= write_data;
            if (en[3]) r[3] <= write_data;
            if (en[4]) r[4] <= write_data;
            if (en[5]) r[5] <= write_data;
            if (en[6]) r[6] <= write_data;
            if (en[7]) r[7] <= write_data;
        end
    end

endmodule


module comparator_4bit(input logic [3:0] a,b,
                       output logic eq);

    assign eq = (a[0] xnor b[0]) and (a[1] xnor b[1]) and (a[2] xnor b[2]) and (a[3] nor b[3]);

endmodule


module comparator (input logic [3:0] D_lookup,
                   input logic [3:0]r[7:0],
                   output logic [7:0]r_eq);

    always_comb begin
        generate
            genvar i;
            for (i = 0; i < 8; i = i + 1) begin: comparator_generate_block
                comparator_4bit equal_check(D_lookup, r[i], r_eq[i]);
            end

        endgenerate
    end

endmodule


module write_enable_generate(input logic setD,
                             input logic [7:0]r_eq,
                             output logic [7:0]en);

    always_comb begin
        generate
            genvar i;
            for (i = 0; i < 8; i = i + 1) begin: write_enable_generate_block
                en[i] = setD & r_eq[i];
            end
        endgenerate
    end
    
endmodule


module priority_encoder(input logic [7:0]r_eq,
                        output logic [2:0]y,
                        output logic valid);

    always_comb begin
        valid = 1'b1;
        y = 3'b000;
        if (r_eq[7]) y = 3'b111;
        else if (r_eq[6]) y = 3'b110;
        else if (r_eq[5]) y = 3'b101;
        else if (r_eq[4]) y = 3'b100;
        else if (r_eq[3]) y = 3'b011;
        else if (r_eq[2]) y = 3'b010;
        else if (r_eq[1]) y = 3'b001;
        else if (r_eq[0]) y = 3'b000;
        else valid = 1'b0;
    end

endmodule


module priority_inv_encoder(input logic [7:0]r_eq,
                            output logic [2:0]y);

    logic valid;

    always_comb begin
        y = 3'b000;
        valid = 1'b1;
        if (r_eq[0]) y = 3'b000;
        else if (r_eq[1]) y = 3'b001;
        else if (r_eq[2]) y = 3'b010;
        else if (r_eq[3]) y = 3'b011;
        else if (r_eq[4]) y = 3'b100;
        else if (r_eq[5]) y = 3'b101;
        else if (r_eq[6]) y = 3'b110;
        else if (r_eq[7]) y = 3'b111;
        else valid = 1'b0;
    end

endmodule


module cam(input logic clk,
           input logic [3:0]D_lookup,
           input logic setD,
           input logic [3:0]newD,
           input logic init,
           output logic [2:0]minaddr, maxaddr,
           output logic valid);

    logic [3:0]r[7:0];
    logic [7:0]en, r_eq;

    register_file rf(clk, init, newD, en, r);
    comparator eq_check(D_lookup, r, r_eq);
    write_enable_generate enable_generate(setD, r_eq, en);
    priority_encoder priority_enc(r_eq, minaddr, valid);
    priority_inv_encoder priority_inv_enc(r_eq, maxaddr);

endmodule


