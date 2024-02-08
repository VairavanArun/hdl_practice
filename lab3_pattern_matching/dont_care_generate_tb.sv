/*
 * This file contains the test bench for testing the dont care generate circuit
 * This circuit tests the decoder with enable bit
 */

module dont_care_generate_tb();
    logic        clk, reset;
    logic [1:0]  a;
    logic        en;
    logic [3:0]  y, yexpected;
    logic [31:0] vectornum, errors;
    logic [3:0]  testvectors[10000:0];

    //instantiate the DUT
    dont_care_generate #(2) dut(a, en, y);

    // generate clock
    always
        begin
            clk = 1; #5; clk = 0; #5;
        end
    
    //start of test, load the test vectors
    initial 
        begin
            $readmemb("dont_care_generate_tv.tv", testvectors);
            vectornum = 0; errors = 0;
            reset = 1; #27; reset = 0;
        end

    // apply test vectors at positive edge
    always @(posedge clk) begin
        #1; {en, a, yexpected} = testvectors[vectornum];
    end

    // Check results in the negative edge
    always @(negedge clk) begin
        // skip if reset
        if (~reset) begin
            if (y !== yexpected) begin
                $display("Error: Inputs: en: %b,a: %b", en, a);
                $display("Error: Output: %b(%b expected)", y, yexpected);
                errors = errors + 1;
            end

            // increment vector number
            vectornum = vectornum + 1;
            // check if last input
            if (testvectors[vectornum] === 7'bx) begin
                $display("%d Tests completed with %d errors", vectornum, errors);
                $finish;            
            end
        end
    end
endmodule