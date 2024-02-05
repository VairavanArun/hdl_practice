//This file contains the test cases to verify the functionality of a 16-bit
// sign magnitude system

module final_operation_tb();
    logic [16:0] A,B;
    logic OP;
    logic [16:0] Y;
    logic OF;

    //Instantiate the module
    final_operation dut(A, B, OP, Y, OF);

    // start the test case
    initial begin
        //initialize all inputs to 0
        A = 17'h00000; B = 17'h00000; OP = 1'b0; #60;
        // TB #1 pos A + pos B = pos Y
        A = 17'h0AAAA; B = 17'h05555; OP = 1'b0; #60;
        // TB #2 pos A + pos B = overflow
        A = 17'h0FFF0; B = 17'h0001F; OP = 1'b0; #60;
        // TB #3 pos A + neg B = pos Y
        A = 17'h00007; B = 17'h10005; OP = 1'b0; #60;
        // TB #4 pos A + neg B = neg Y
        A = 17'h000FF; B = 17'h1FF00; OP = 1'b0; #60;
        // TB #5 neg A + pos B = pos Y
        A = 17'h100FF; B = 17'h0FF00; OP = 1'b0; #60;
        // TB #6 neg A + pos B = neg Y
        A = 17'h1CCCC; B = 17'h03333; OP = 1'b0; #60;
        // TB #7 neg A + neg B overflow
        A = 17'h17FF8; B = 17'h18008; OP = 1'b0; #60;
        // TB #8 neg A + neg B = neg Y
        A = 17'h17FF8; B = 17'h18007; OP = 1'b0; #60;
        // TB #9 pos A - pos B = pos Y
        A = 17'h00007; B = 17'h00002; OP = 1'b1; #60;
        // TB #10 pos A - pos B = neg Y
        A = 17'h00002; B = 17'h00007; OP = 1'b1; #60;
        // TB #11 pos A - neg B = pos Y
        A = 17'h0AAAA; B = 17'h15555; OP = 1'b1; #60;
        // TB #12 pos A - neg B overflow
        A = 17'h07FF8; B = 17'h18008; OP = 1'b1; #60;
        // TB #13 neg A - pos B overflow
        A = 17'h1CCCC; B = 17'h03334; OP = 1'b1; #60;
        // TB #14 neg A - pos B = neg Y
        A = 17'h1F000; B = 17'h00FFF; OP = 1'b1; #60;
        // TB #15 neg A - neg B = pos Y
        A = 17'h10FFF; B = 17'h1F000; OP = 1'b1; #60;
        // TB #16 neg A - neg B = neg Y
        A = 17'h1F000; B = 17'h10FFF; OP = 1'b1; #60;
    end

endmodule