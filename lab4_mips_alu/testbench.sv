module testbench();
    logic clk, reset;
    logic [31:0] A, B, Y, Y_expected;
    logic [2:0] F;
    logic Z, Z_expected;
    logic OF,OF_expected;
    logic [31:0] vectornum, errors;
    logic [108:0] test_vectors[100000:0];

    //instantiate the ALU
    mips_alu dut(A, B, F, Y, Z,OF);

    //read the test vector file
    initial
        begin
            $readmemh("C:/Users/tanvi/OneDrive/Documents/UIC spring24sem2/ece469HDL/Lab3/testvectorModuleC.tv.txt", test_vectors);
            vectornum = 0;
            errors = 0;
            reset = 1; #30; reset = 0;
            $display("\n\n=============================================");
            $display("Starting simulation");
        end

    always 
        begin
            clk = 1; #5; clk = 0; #5;
        end

    always @(posedge clk)
        begin
            #1;
            F = test_vectors[vectornum][106:104];
            A = test_vectors[vectornum][103:72];
            B = test_vectors[vectornum][71:40];
            Y_expected = test_vectors[vectornum][39:8];
            Z_expected = test_vectors[vectornum][4];
	    OF_expected = test_vectors[vectornum][0];
        end
    
    always @(negedge clk)
        begin
            if (~reset) begin

                if ((Y != Y_expected) || (Z != Z_expected) || OF !=OF_expected) begin
                    $display("\t\tError: \t\tinput = %h-%h-%h | exp_output = %h-%h-%h | actual_output = %h-%h-%h | Testvector - %h", F, A, B,Y_expected, Z_expected,OF_expected, Y, Z, OF, vectornum);
                    errors = errors + 1;
                end

                if ((Y == Y_expected) || (Z == Z_expected) || OF!=OF_expected) begin
                    $display("\t\tPassed: \t\tinput = %h-%h-%h | exp_output = %h-%h-%h | actual_output = %h-%h-%h | Testvector - %h", F, A, B,Y_expected, Z_expected,OF_expected, Y, Z, OF, vectornum);
                end

                if (A === 32'bx) begin
				    $display("\tTests complete :%h \n\tErrors :%h", vectornum, errors);
				    $display("\nSimulation done ");
				    $display("====================================================================================================\n\n");
				    $stop;
			    end
			    vectornum = vectornum + 1;
            end
        end
endmodule
